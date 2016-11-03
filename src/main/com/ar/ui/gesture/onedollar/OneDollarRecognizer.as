package com.ar.ui.gesture.onedollar
{
	import com.ar.core.utils.IDisposable;
	import com.ar.math.Maths;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * One Dollar Gesture Recognizer by Wobbrock et al.
	 *
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class OneDollarRecognizer implements IDisposable
	{
		public static const NUM_POINTS:int = 64;
		public static const SQUARE_SIZE:Number = 250.0;
		public static const HALF_DIAGNOAL:Number = 0.5 * Math.sqrt( SQUARE_SIZE * SQUARE_SIZE + SQUARE_SIZE * SQUARE_SIZE );
		public static const ANGLE_RANGE:Number = 45.0;
		public static const ANGLE_PRECISION:Number = 2.0;

		private var _templates:Vector.<OneDollarTemplate> = new Vector.<OneDollarTemplate>();
		private var _observer:IOneDollarRecognizerObserver;
		private var _inputPath:Vector.<Point> = new Vector.<Point>();
		private var _quantizeH:int;
		private var _quantizeV:int;
		private var _record:Boolean = false;

		/**
		 * Creates a new instance of OneDollarRecognizer.
		 */
		public function OneDollarRecognizer( observer:IOneDollarRecognizerObserver, quantizeH:int = 2, quantizeV:int = 2 )
		{
			_observer = observer;
			_quantizeH = quantizeH;
			_quantizeV = quantizeV;
		}

		/**
		 * Frees all internal references of the object.
		 */
		public function dispose():void
		{
			if( null != _templates )
			{
				_templates.splice( 0, _templates.length );
				_templates = null;
			}
		}

		/**
		 * Add a new template to the list of templates a path is matched with.
		 */
		public function addTemplate( template:OneDollarTemplate ):void
		{
			const index:int = _templates.indexOf( template );

			if( -1 != index )
			{
				throw new Error( "Will not add given template, as it allready exists!" );
			}

			template.points = makeInvariant( template.points );

			_templates.push( template );
		}

		/**
		 * Remove a new template from the list of templates a path is matched with.
		 */
		public function removeTemplate( template:OneDollarTemplate ):void
		{
			const index:int = _templates.indexOf( template );

			if( -1 == index )
			{
				throw new Error( "Can't remove given template, as it does not exist!" );
			}

			_templates.splice( index, 1 );
		}

		/**
		 * Returns true if given template is part of the template list a path is compared to.
		 */
		public function hasTemplate( template:OneDollarTemplate ):Boolean
		{
			return ( -1 != _templates.indexOf( template ) );
		}

		/**
		 * Returns the number of templates in the list.
		 */
		public function get numTemplates():int
		{
			return _templates.length;
		}

		/**
		 * Start a new stroke to be recognized as gesture.
		 */
		public function onStrokeStart( posX:int, posY:int ):void
		{
			_record = true;

			clearDots();

			addDot( new Point( posX, posY ) );
		}

		/**
		 * Update a stroke
		 */
		public function onStrokeUpdate( posX:int, posY:int ):void
		{
			if( _record )
			{
				addDot( new Point( posX, posY ) );
			}
		}

		/**
		 * Complete the stroke
		 */
		public function onStrokeEnd( posX:int, posY:int ):void
		{
			_record = false;

			recognize( _inputPath );
		}

		/**
		 * @private
		 */
		private function addDot( p:Point ):void
		{
			Maths.quantize2D( p, _quantizeH, _quantizeV );

			if( _inputPath.length > 0 )
			{
				var last:Point = _inputPath[ _inputPath.length - 1];

				if( last.x == p.x && last.y == p.y )
				{
					return;
				}
			}

			_inputPath.push( p );

			_observer.onOneDollarUpdated( _inputPath );
		}

		/**
		 * @private
		 */
		private function clearDots():void
		{
			_inputPath.splice( 0, _inputPath.length );
		}

		/**
		 * @private
		 */
		private function recognize( points:Vector.<Point> ):void
		{
			if( _templates.length == 0 || points.length < 2 )
			{
				_observer.onOneDollarRecognized( null );
				return;
			}

			points = makeInvariant( points );

			var b:Number = Number.POSITIVE_INFINITY;
			var d:Number;

			var templateIndex:int = 0;

			const n:int = _templates.length;

			for( var i:int = 0; i < n; ++i )
			{
				d = getDistAtBestAngle( points, _templates[i].points, -ANGLE_RANGE, +ANGLE_RANGE, ANGLE_PRECISION );

				if( d < b )
				{
					b = d;

					templateIndex = i;
				}
			}

			// threshold here

			var score:Number = Math.max( 0, Math.min( 1, 1.0 - ( b / HALF_DIAGNOAL ) ) );

			_observer.onOneDollarRecognized( new OneDollarResult( _templates[ templateIndex ].id, score ) );
		}

		/**
		 * @private
		 */
		private function makeInvariant( points:Vector.<Point> ):Vector.<Point>
		{
			if( !points || points.length < 1 )
			{
				return points;
			}

			points = resample( Vector.<Point>( points.concat() ) );
			points = rotateToZero( points );
			points = scaleToSquare( points );
			points = translateToOrigin( points );

			return points;
		}

		/**
		 * @private
		 */
		private function resample( points:Vector.<Point> ):Vector.<Point>
		{
			var interval:Number = getLength( points ) / ( NUM_POINTS - 1 );

			var distance:Number = 0.0;
			var q:Point;
			var p1:Point;
			var p2:Point;
			var d:Number;

			var newPoints:Vector.<Point> = new Vector.<Point>();

			newPoints.push( points[0].clone() );

			for( var i:int = 1; i < points.length; ++i )
			{
				p1 = points[ i - 1 ];
				p2 = points[ i ];

				d = getDist( p1, p2 );

				if( ( distance + d ) >= interval )
				{
					q = new Point(
							p1.x + ( ( interval - distance ) / d ) * ( p2.x - p1.x ),
							p1.y + ( ( interval - distance ) / d ) * ( p2.y - p1.y )
					);

					newPoints.push( q );

					points.splice( i, 0, q );

					distance = 0;
				}
				else
				{
					distance += d;
				}
			}

			if( NUM_POINTS - 1 == newPoints.length )
			{
				newPoints.push( points[ points.length - 1 ].clone() );
			}

			return newPoints;
		}

		/**
		 * @private
		 */
		private function rotateToZero( points:Vector.<Point> ):Vector.<Point>
		{
			var c:Point = getCentroid( points );

			var p:Point = points[ 0 ];

			var theta:Number = Math.atan2( c.y - p.y, c.x - p.x );

			return rotateBy( points, -theta );
		}

		/**
		 * @private
		 */
		private function scaleToSquare( points:Vector.<Point> ):Vector.<Point>
		{
			var b:Rectangle = getBounds( points );

			var newPoints:Vector.<Point> = new Vector.<Point>();

			const n:int = points.length;

			var p:Point;

			for( var i:int = 0; i < n; ++i )
			{
				p = points[ i ];

				p.x *= ( SQUARE_SIZE / b.width );
				p.y *= ( SQUARE_SIZE / b.height );

				newPoints.push( new Point( p.x, p.y ) );
			}

			return newPoints;
		}

		/**
		 * @private
		 */
		private function translateToOrigin( points:Vector.<Point> ):Vector.<Point>
		{
			var c:Point = getCentroid( points );

			var newPoints:Vector.<Point> = new Vector.<Point>();

			var p:Point;

			const n:int = points.length;

			for( var i:int = 0; i < n; ++i )
			{
				p = points[ i ];

				newPoints.push( new Point( p.x - c.x, p.y - c.y ) );
			}

			return newPoints;
		}

		/**
		 * @private
		 */
		private function rotateBy( points:Vector.<Point>, angle:Number ):Vector.<Point>
		{
			const cos:Number = Math.cos( angle );
			const sin:Number = Math.sin( angle );
			const cen:Point = getCentroid( points );

			var newPoints:Vector.<Point> = new Vector.<Point>();

			var p:Point;

			const n:int = points.length;

			for( var i:int = 0; i < n; ++i )
			{
				p = points[ i ];

				newPoints.push(
						new Point(
								( p.x - cen.x ) * cos - ( p.y - cen.y ) * sin + cen.x,
								( p.x - cen.x ) * sin + ( p.y - cen.y ) * cos + cen.y
						) );
			}

			return newPoints;
		}

		/**
		 * @private
		 */
		private function getDistAtBestAngle( points1:Vector.<Point>, points2:Vector.<Point>, a:Number, b:Number, threshold:Number ):Number
		{
			const PHI:Number = 0.5 * ( -1 + Math.sqrt( 5 ) );
			const invPHI:Number = 1 - PHI;

			var x1:Number = PHI * a + invPHI * b;
			var x2:Number = invPHI * a + PHI * b;
			var f1:Number = getDistAtAngle( points1, points2, x1 );
			var f2:Number = getDistAtAngle( points1, points2, x2 );

			var abs:Number = a - b;

			if( abs < 0 )
			{
				abs = -abs;
			}

			while( abs > threshold )
			{
				if( f1 < f2 )
				{
					b = x2;
					x2 = x1;
					f2 = f1;
					x1 = PHI * a + invPHI * b;
					f1 = getDistAtAngle( points1, points2, x1 );
				}
				else
				{
					a = x1;
					x1 = x2;
					f1 = f2;
					x2 = invPHI * a + PHI * b;
					f2 = getDistAtAngle( points1, points2, x2 );
				}

				abs = a - b;

				if( abs < 0 )
				{
					abs = -abs;
				}
			}

			return ( f1 < f2 ) ? f1 : f2;
		}

		/**
		 * @private
		 */
		private function getDistAtAngle( points1:Vector.<Point>, points2:Vector.<Point>, theta:Number ):Number
		{
			var newPoints:Vector.<Point> = rotateBy( points1, theta );

			var d:Number = 0.0;

			const n:int = points1.length;

			for( var i:int = 0; i < n; ++i )
			{
				d += getDist( newPoints[ i ], points2[ i ] );
			}

			return d / n;
		}

		/**
		 * @private
		 */
		private function getCentroid( points:Vector.<Point> ):Point
		{
			var result:Point = new Point();

			var p:Point;

			const n:int = points.length;

			for( var i:int = 0; i < n; ++i )
			{
				p = points[ i ];

				result.x += p.x;
				result.y += p.y;
			}

			result.x /= n;
			result.y /= n;

			return result;
		}

		/**
		 * @private
		 */
		private function getBounds( points:Vector.<Point> ):Rectangle
		{
			var minX:Number = Number.POSITIVE_INFINITY;
			var maxX:Number = Number.NEGATIVE_INFINITY;
			var minY:Number = Number.POSITIVE_INFINITY;
			var maxY:Number = Number.NEGATIVE_INFINITY;

			var p:Point;

			const n:int = points.length;

			for( var i:int = 0; i < n; ++i )
			{
				p = points[ i ];

				if( p.x < minX )
				{
					minX = p.x;
				}
				if( p.x > maxX )
				{
					maxX = p.x;
				}
				if( p.y < minY )
				{
					minY = p.y;
				}
				if( p.y > maxY )
				{
					maxY = p.y;
				}
			}

			return new Rectangle( minX, minY, maxX - minX, maxY - minY );
		}

		/**
		 * @private
		 */
		private function getLength( points:Vector.<Point> ):Number
		{
			var d:Number = 0.0;

			const n:int = points.length;

			for( var i:int = 1; i < n; ++i )
			{
				d += getDist( points[ i - 1 ], points[ i ] );
			}

			return d;
		}

		/**
		 * @private
		 */
		private function getDist( p1:Point, p2:Point ):Number
		{
			const dx:Number = p2.x - p1.x;
			const dy:Number = p2.y - p1.y;

			return Math.sqrt( dx * dx + dy * dy );
		}

		/**
		 * Creates and returns a string representation of the OneDollarRecognizer object.
		 */
		public function toString():String
		{
			return "[OneDollarRecognizer]";
		}
	}
}