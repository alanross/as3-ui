package com.ar.ui.gesture.levenshtein
{
	import com.ar.core.error.ElementAlreadyExistsError;
	import com.ar.core.error.ElementDoesNotExistError;
	import com.ar.core.log.Context;
	import com.ar.core.log.Log;
	import com.ar.core.utils.StringUtils;
	import com.ar.math.Maths;

	import flash.geom.Point;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class LevenshteinRecognizer
	{
		private var _templates:Vector.<LevenshteinTemplate> = new Vector.<LevenshteinTemplate>();
		private var _inputPath:Vector.<Point> = new Vector.<Point>();
		private var _observer:ILevenshteinRecognizerObserver;
		private var _quantizeH:int;
		private var _quantizeV:int;
		private var _record:Boolean = false;

		/**
		 * Creates a new instance of LevenshteinRecognizer.
		 */
		public function LevenshteinRecognizer( observer:ILevenshteinRecognizerObserver, quantizeH:int = 10, quantizeV:int = 10 )
		{
			_observer = observer;
			_quantizeH = quantizeH;
			_quantizeV = quantizeV;
		}

		/**
		 * Add a new template a path is to be compared against
		 */
		public function addTemplate( template:LevenshteinTemplate ):void
		{
			if( hasTemplate( template ) )
			{
				throw new ElementAlreadyExistsError();
			}

			_templates.unshift( template );
		}

		/**
		 * Remove a template from the list of templates to compare with a given path.
		 */
		public function removeTemplate( template:LevenshteinTemplate ):void
		{
			if( !hasTemplate( template ) )
			{
				throw new ElementDoesNotExistError();
			}

			const index:int = _templates.indexOf( template );

			_templates.splice( index, 1 );
		}

		/**
		 * Returns true if given template is part of the list of templates.
		 */
		public function hasTemplate( template:LevenshteinTemplate ):Boolean
		{
			return ( -1 != _templates.indexOf( template ) );
		}

		/**
		 * Begin a new stroke to be recognized.
		 */
		public function onStrokeStart( posX:int, posY:int ):void
		{
			_record = true;

			clearDots();

			addDot( new Point( posX, posY ) );
		}

		/**
		 * Update a stroke to be recognized.
		 */
		public function onStrokeUpdate( posX:int, posY:int ):void
		{
			if( _record )
			{
				addDot( new Point( posX, posY ) );
			}
		}

		/**
		 * Finish the stroke to be recognized.
		 */
		public function onStrokeEnd( posX:int, posY:int ):void
		{
			_record = false;

			findBestMatch( pathToDirectionSequence( _inputPath ) );
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

			_observer.onLevenshteinUpdated( _inputPath );
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
		private function findBestMatch( sequence:String ):void
		{
			const result:Vector.<LevenshteinResult> = new Vector.<LevenshteinResult>();

			if( !StringUtils.isEmpty( sequence ) )
			{
				const distances:Array = new Array();

				const m:int = _templates.length;
				var t:LevenshteinTemplate;

				for( var e:int = 0; e < m; ++e )
				{
					t = _templates[ e ];

					const d:int = StringUtils.getLevenshteinDistance( sequence, t.sequence );

					distances.push( new LevenshteinResult( t.id, d ) );

					if( d == 0 )
					{
						break; // found best possible match
					}
				}

				if( distances.length > 0 )
				{
					// sort results by distance.
					distances.sortOn( "distance", Array.NUMERIC );

					var r:LevenshteinResult = distances[0];
					var best:int = r.distance;
					var n:int = distances.length;

					result.push( r );

					for( var i:int = 1; i < n; ++i )
					{
						r = distances[i];

						if( best < r.distance )
						{
							break;
						}

						result.push( r );
					}
				}
			}
			else
			{
				Log.warn( Context.DEFAULT, this, "Direction sequence is empty." );
			}

			_observer.onLevenshteinRecognized( result );
		}

		/**
		 * @private
		 */
		private function pathToDirectionSequence( path:Vector.<Point> ):String
		{
			if( path.length == 0 )
			{
				Log.warn( Context.DEFAULT, this, "Path is empty." );

				return "";
			}

			const inputPathDirections:Vector.<int> = new Vector.<int>();
			const n:int = path.length;

			var p:Point = path[0];
			var d:int = -1;
			var tmp:int;

			for( var i:int = 1; i < n; ++i )
			{
				tmp = Maths.getDirection2D( p, path[i] );

				if( tmp != d )
				{
					inputPathDirections.push( tmp );
					d = tmp;
				}

				p = path[i];
			}

			return inputPathDirections.join( "" );
		}

		/**
		 * Creates and returns a string representation of the LevenshteinRecognizer object.
		 */
		public function toString():String
		{
			return "[LevenshteinRecognizer]";
		}
	}
}