package com.ar.ui.utils.graphics
{
	import com.ar.core.error.MissingImplementationError;
	import com.ar.core.error.UnsupportedOperationError;
	import com.ar.core.error.ValueError;
	import com.ar.core.utils.IDisposable;
	import com.ar.math.Maths;
	import com.ar.math.geom.Circle;
	import com.ar.math.geom.IShape;
	import com.ar.math.geom.Point2D;
	import com.ar.math.geom.Polygon;
	import com.ar.math.geom.Rect;

	import flash.display.Graphics;
	import flash.display.GraphicsPath;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class Drawing implements IDisposable
	{
		private var _path:GraphicsPath;

		private var _fillColor:int = 0xFFFFFF;

		private var _fillColorAlpha:Number = 1.0;

		private var _outlineColor:int = 0x777777;

		private var _outlineColorAlpha:Number = 1.0;

		private var _outlineThickness:Number = 1.0;

		/**
		 * Creates a new instance of Drawing.
		 */
		public function Drawing()
		{
			_path = new GraphicsPath( new Vector.<int>(), new Vector.<Number>() );
		}

		/**
		 * Draw a rectangle
		 */
		public function drawRect( g:Graphics, x:Number, y:Number, width:Number, height:Number, drawType:int = 0 ):void
		{
			if( width <= 0 || height <= 0 )
			{
				return;
			}

			const t1:Number = _outlineThickness;
			const t2:Number = _outlineThickness * 2.0;

			switch( drawType )
			{
				case DrawType.OUTLINE:
					createRectPath( _path, x, y, width, height );
					g.beginFill( _outlineColor, _outlineColorAlpha );
					g.drawPath( _path.commands, _path.data, _path.winding );

					createRectPath( _path, x + t1, y + t1, width - t2, height - t2 );
					g.drawPath( _path.commands, _path.data, _path.winding );
					g.endFill();
					break;

				case DrawType.FILL_AND_OUTLINE:
					createRectPath( _path, x, y, width, height );
					g.beginFill( _outlineColor, _fillColorAlpha );
					g.drawPath( _path.commands, _path.data, _path.winding );
					g.endFill();

					createRectPath( _path, x + t1, y + t1, width - t2, height - t2 );
					g.beginFill( _fillColor, _fillColorAlpha );
					g.drawPath( _path.commands, _path.data, _path.winding );
					g.endFill();
					break;

				case DrawType.FILL:
					createRectPath( _path, x, y, width, height );
					g.beginFill( _fillColor, _fillColorAlpha );
					g.drawPath( _path.commands, _path.data, _path.winding );
					g.endFill();
					break;

				default:
					throw new ValueError( "drawType is unknown" );
			}
		}

		/**
		 * Draw a rectangle with rounded corners.
		 */
		public function drawRoundedRect( g:Graphics, x:Number, y:Number, width:Number, height:Number, rTL:Number = 0, rTR:Number = 0, rBL:Number = 0, rBR:Number = 0, drawType:int = 0 ):void
		{
			if( width <= 0 || height <= 0 )
			{
				return;
			}

			const t1:Number = _outlineThickness;
			const t2:Number = _outlineThickness * 2;

			switch( drawType )
			{
				case DrawType.OUTLINE:
					createRoundedRectPath( _path, x, y, width, height, rTL, rTR, rBL, rBR );
					g.beginFill( _outlineColor, _outlineColorAlpha );
					g.drawPath( _path.commands, _path.data, _path.winding );

					createRoundedRectPath( _path, x + t1, y + t1, width - t2, height - t2, rTL, rTR, rBL, rBR );
					g.drawPath( _path.commands, _path.data, _path.winding );
					g.endFill();
					break;

				case DrawType.FILL_AND_OUTLINE:
					createRoundedRectPath( _path, x, y, width, height, rTL, rTR, rBL, rBR );
					g.beginFill( _outlineColor, _outlineColorAlpha );
					g.drawPath( _path.commands, _path.data, _path.winding );
					g.endFill();

					createRoundedRectPath( _path, x + t1, y + t1, width - t2, height - t2, rTL, rTR, rBL, rBR );
					g.beginFill( _fillColor, _fillColorAlpha );
					g.drawPath( _path.commands, _path.data, _path.winding );
					g.endFill();
					break;

				case DrawType.FILL:
					createRoundedRectPath( _path, x, y, width, height, rTL, rTR, rBL, rBR );
					g.beginFill( _fillColor, _fillColorAlpha );
					g.drawPath( _path.commands, _path.data, _path.winding );
					g.endFill();
					break;

				default:
					throw new ValueError( "drawType is unknown" );
			}
		}

		/**
		 * Draw a circle
		 */
		public function drawCircle( g:Graphics, x:int, y:int, radius:int, drawType:int = 0 ):void
		{
			if( radius <= 0 )
			{
				return;
			}

			const t:Number = _outlineThickness * 1.2;

			switch( drawType )
			{
				case DrawType.FILL:
					createCirclePath( _path, x, y, radius );
					g.beginFill( _fillColor, _fillColorAlpha );
					g.drawPath( _path.commands, _path.data, _path.winding );
					g.endFill();
					break;

				case DrawType.OUTLINE:
					createCirclePath( _path, x, y, radius );
					g.beginFill( _outlineColor, _outlineColorAlpha );
					g.drawPath( _path.commands, _path.data, _path.winding );

					createCirclePath( _path, x, y, radius - t );
					g.drawPath( _path.commands, _path.data, _path.winding );
					g.endFill();
					break;

				case DrawType.FILL_AND_OUTLINE:
					createCirclePath( _path, x, y, radius );
					g.beginFill( _outlineColor, _outlineColorAlpha );
					g.drawPath( _path.commands, _path.data, _path.winding );
					g.endFill();

					createCirclePath( _path, x, y, radius - t );
					g.beginFill( _fillColor, _fillColorAlpha );
					g.drawPath( _path.commands, _path.data, _path.winding );
					g.endFill();
					break;

				default:
					throw new ValueError( "drawType is unknown" );
			}
		}

		/**
		 * Draw a pie.
		 */
		public function drawPie( g:Graphics, x:int, y:int, radius:int, value:Number, drawType:int = 0 ):void
		{
			if( radius <= 0 )
			{
				return;
			}

			const t:Number = _outlineThickness * 1.2;

			const artStart:Number = -Math.PI * 0.5;
			const arcFull:Number = Math.PI * 2.0;
			const arcEnd:Number = artStart + value * arcFull;

			switch( drawType )
			{
				case DrawType.FILL:
					createPiePath( _path, x, y, radius, artStart, arcEnd );
					g.beginFill( _fillColor, _fillColorAlpha );
					g.drawPath( _path.commands, _path.data, _path.winding );
					g.endFill();
					break;

				case DrawType.OUTLINE:
					createPiePath( _path, x, y, radius, artStart, arcEnd );
					g.beginFill( _outlineColor, _outlineColorAlpha );
					g.drawPath( _path.commands, _path.data, _path.winding );

					createPiePath( _path, x, y, radius - t, artStart, arcEnd );
					g.drawPath( _path.commands, _path.data, _path.winding );
					g.endFill();
					break;

				case DrawType.FILL_AND_OUTLINE:
					createPiePath( _path, x, y, radius, artStart, arcEnd );
					g.beginFill( _outlineColor, _outlineColorAlpha );
					g.drawPath( _path.commands, _path.data, _path.winding );
					g.endFill();

					createPiePath( _path, x, y, radius - t, artStart, arcEnd );
					g.beginFill( _fillColor, _fillColorAlpha );
					g.drawPath( _path.commands, _path.data, _path.winding );
					g.endFill();
					break;

				default:
					throw new ValueError( "drawType is unknown" );
			}
		}

		/**
		 * Draw a polygon shape
		 */
		public function drawPolygon( g:Graphics, points:Vector.<Point2D>, drawType:int = 0 ):void
		{
			if( points == null || points.length == 0 )
			{
				return
			}

			switch( drawType )
			{
				case DrawType.OUTLINE:
					throw new MissingImplementationError();
					break;

				case DrawType.FILL_AND_OUTLINE:
					throw new MissingImplementationError();
					break;

				case DrawType.FILL:
					createPolygonPath( _path, points );
					g.beginFill( _fillColor, _fillColorAlpha );
					g.drawPath( _path.commands, _path.data, _path.winding );
					g.endFill();
					break;

				default:
					throw new ValueError( "drawType is unknown" );
			}
		}

		/**
		 * Draw shape
		 */
		public function drawFromShape( g:Graphics, shape:IShape, drawType:int = 0 ):void
		{
			var r:Rect = shape as Rect;
			if( null != r )
			{
				drawRect( g, r.x, r.y, r.width, r.height, drawType );
				return;
			}

			var c:Circle = shape as Circle;
			if( null != c )
			{
				drawCircle( g, c.x, c.y, c.radius, drawType );
				return;
			}

			var p:Polygon = shape as Polygon;
			if( null != p )
			{
				drawPolygon( g, p.points, drawType );
				return;
			}

			throw new UnsupportedOperationError( "The given shape object is not supported" );
		}

		/**
		 * Creates and returns a graphics path defining a rectangle.
		 */
		public function createRectPath( p:GraphicsPath, x:Number, y:Number, width:Number, height:Number ):void
		{
			clearPath( p );

			// start position
			p.moveTo( x, y );

			p.lineTo( x + width, y );
			p.lineTo( x + width, y + height );
			p.lineTo( x, y + height );
			p.lineTo( x, y );
		}

		/**
		 * Creates and returns a graphics path defining a rectangle with rounded corners
		 */
		public function createRoundedRectPath( p:GraphicsPath, x:Number, y:Number, width:Number, height:Number, radiusTL:Number, radiusTR:Number, radiusBL:Number, radiusBR:Number ):void
		{
			clearPath( p );

			var offset0:Number;
			var offset1:Number;

			// if a radius is greater than dimensions permits, use a radius that will fit
			var h:Number = height * 0.5;
			var w:Number = width * 0.5;

			radiusTL = ( radiusTL > w ) ? w : ( radiusTL > h ) ? h : radiusTL;
			radiusTR = ( radiusTR > w ) ? w : ( radiusTR > h ) ? h : radiusTR;
			radiusBL = ( radiusBL > w ) ? w : ( radiusBL > h ) ? h : radiusBL;
			radiusBR = ( radiusBR > w ) ? w : ( radiusBR > h ) ? h : radiusBR;

			w = x + width;
			h = y + height;

			// start position
			p.moveTo( x + radiusTL, y );

			// top right corner
			offset0 = 0.4142 * radiusTR;
			offset1 = 0.7071 * radiusTR;

			p.lineTo( w - radiusTR, y );
			p.curveTo( w - radiusTR + offset0, y, w - radiusTR + offset1, y - offset1 + radiusTR );
			p.curveTo( w, y - offset0 + radiusTR, w, y + radiusTR );

			// bottom right corner
			offset0 = 0.4142 * radiusBR;
			offset1 = 0.7071 * radiusBR;

			p.lineTo( w, h - radiusBR );
			p.curveTo( w, h - radiusBR + offset0, w + offset1 - radiusBR, h - radiusBR + offset1 );
			p.curveTo( w + offset0 - radiusBR, h, w - radiusBR, h );

			// bottom left corner
			offset0 = 0.4142 * radiusBL;
			offset1 = 0.7071 * radiusBL;

			p.lineTo( x + radiusBL, y + height );
			p.curveTo( x + radiusBL - offset0, h, x + radiusBL - offset1, h + offset1 - radiusBL );
			p.curveTo( x, h + offset0 - radiusBL, x, h - radiusBL );

			// top left corner
			offset0 = 0.4142 * radiusTL;
			offset1 = 0.7071 * radiusTL;

			p.lineTo( x, y + radiusTL );
			p.curveTo( x, y + radiusTL - offset0, x - offset1 + radiusTL, y + radiusTL - offset1 );
			p.curveTo( x - offset0 + radiusTL, y, x + radiusTL, y );
		}

		/**
		 * Creates and returns a graphics path defining a circle
		 */
		public function createCirclePath( p:GraphicsPath, x:Number, y:Number, radius:Number ):void
		{
			clearPath( p );

			const offset0:Number = 0.4142 * radius;
			const offset1:Number = 0.7071 * radius;

			// start position
			p.moveTo( x + radius, y );

			p.curveTo( x + radius, y + offset0, x + offset1, y + offset1 );
			p.curveTo( x + offset0, y + radius, x, y + radius );

			p.curveTo( x - offset0, y + radius, x - offset1, y + offset1 );
			p.curveTo( x - radius, y + offset0, x - radius, y );

			p.curveTo( x - radius, y - offset0, x - offset1, y - offset1 );
			p.curveTo( x - offset0, y - radius, x, y - radius );

			p.curveTo( x + offset0, y - radius, x + offset1, y - offset1 );
			p.curveTo( x + radius, y - offset0, x + radius, y );
		}

		/**
		 * Creates and returns a graphics path defining a pie
		 */
		public function createPiePath( p:GraphicsPath, x:Number, y:Number, radius:Number, angleStart:Number, angleEnd:Number ):void
		{
			clearPath( p );

			var arc:Number = angleEnd - angleStart;

			while( arc < 0.0 )
			{
				arc += Math.PI * 2.0;
			}

			var segmentsNum:Number = Math.ceil( arc / ( Math.PI * 0.25 ) );
			var segmentAngle:Number = -arc / segmentsNum;
			var theta:Number = -segmentAngle * 0.5;
			var cosTheta:Number = Math.cos( theta );
			var angleMid:Number;

			// start position
			p.moveTo( x + Math.cos( angleStart ) * radius, y + Math.sin( angleStart ) * radius );

			for( var i:int = 0; i < segmentsNum; ++i )
			{
				angleStart += theta * 2.0;
				angleMid = angleStart - theta;

				p.curveTo(
						x + Math.cos( angleMid ) * ( radius / cosTheta ),
						y + Math.sin( angleMid ) * ( radius / cosTheta ),
						x + Math.cos( angleStart ) * radius,
						y + Math.sin( angleStart ) * radius
				);
			}

			p.lineTo( x, y );
		}

		/**
		 * Creates and returns a graphics path defining a polygon
		 */
		public function createPolygonPath( p:GraphicsPath, points:Vector.<Point2D> ):void
		{
			clearPath( p );

			if( points.length < 2 )
			{
				return;
			}

			const n:int = points.length;
			var point:Point2D = points[0];

			// start position
			p.moveTo( point.x, point.y );

			for( var i:int = 1; i < n; ++i )
			{
				point = points[i];
				p.lineTo( point.x, point.y );
			}
		}

		/**
		 * Removes all drawing instructions from a graphics path
		 */
		public function clearPath( p:GraphicsPath ):void
		{
			p.commands.splice( 0, p.commands.length );
			p.data.splice( 0, p.data.length );
		}

		/**
		 * Frees all internal references of the object.
		 */
		public function dispose():void
		{
			_path = null;
		}

		/**
		 *
		 */
		public function setFillColor( color:int, alpha:Number ):void
		{
			_fillColor = color;

			_fillColorAlpha = alpha;
		}

		/**
		 *
		 */
		public function setOutlineColor( color:int, alpha:Number ):void
		{
			_outlineColor = color;

			_outlineColorAlpha = alpha;
		}

		/**
		 *
		 */
		public function get fillColor():int
		{
			return _fillColor;
		}

		/**
		 *
		 */
		public function set fillColor( value:int ):void
		{
			_fillColor = value;
		}

		/**
		 *
		 */
		public function get fillColorAlpha():Number
		{
			return _fillColorAlpha;
		}

		/**
		 *
		 */
		public function set fillColorAlpha( value:Number ):void
		{
			_fillColorAlpha = Maths.clamp( value, 0, 1 );
		}

		/**
		 *
		 */
		public function get outlineColor():int
		{
			return _outlineColor;
		}

		/**
		 *
		 */
		public function set outlineColor( value:int ):void
		{
			_outlineColor = value;
		}

		/**
		 *
		 */
		public function get outlineColorAlpha():Number
		{
			return _outlineColorAlpha;
		}

		/**
		 *
		 */
		public function set outlineColorAlpha( value:Number ):void
		{
			_outlineColorAlpha = Maths.clamp( value, 0, 1 );
		}

		/**
		 *
		 */
		public function get outlineThickness():Number
		{
			return _outlineThickness;
		}

		/**
		 *
		 */
		public function set outlineThickness( value:Number ):void
		{
			_outlineThickness = Maths.clamp( value, 0.001, 100 );
		}

		/**
		 * Creates and returns a string representation of the Drawing object.
		 */
		public function toString():String
		{
			return "[Drawing]";
		}
	}
}