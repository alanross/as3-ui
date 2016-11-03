package com.ar.ui.gesture.onedollar
{
	import flash.geom.Point;

	/**
	 * One Dollar Gesture Recognizer by Wobbrock et al.
	 *
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class OneDollarTemplate
	{
		public var id:String;

		public var points:Vector.<Point>;

		/**
		 * Creates a new instance of OneDollarTemplate.
		 */
		public function OneDollarTemplate( id:String, xyPoints:Array )
		{
			this.id = id;

			this.points = new Vector.<Point>();

			const n:int = xyPoints.length;

			for( var i:int = 0; i < n; i += 2 )
			{
				this.points.push( new Point( xyPoints[ i ], xyPoints[ i + 1 ] ) );
			}
		}

		/**
		 * Creates and returns a string representation of the OneDollarTemplate object.
		 */
		public function toString():String
		{
			return "[OneDollarTemplate]";
		}
	}
}