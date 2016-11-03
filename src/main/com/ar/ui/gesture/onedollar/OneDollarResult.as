package com.ar.ui.gesture.onedollar
{
	/**
	 * One Dollar Gesture Recognizer by Wobbrock et al.
	 *
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class OneDollarResult
	{
		public var id:String;
		public var score:Number;

		/**
		 * Creates a new instance of OneDollarResult.
		 */
		public function OneDollarResult( id:String, score:Number )
		{
			this.id = id;
			this.score = score;
		}

		/**
		 * Creates and returns a string representation of the OneDollarResult object.
		 */
		public function toString():String
		{
			return "[OneDollarResult]";
		}
	}
}