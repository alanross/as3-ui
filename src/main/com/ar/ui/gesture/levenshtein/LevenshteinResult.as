package com.ar.ui.gesture.levenshtein
{
	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class LevenshteinResult
	{
		public var key:String;
		public var distance:int;

		/**
		 * Creates a new instance of LevenshteinResult.
		 */
		public function LevenshteinResult( id:String, distance:int )
		{
			this.key = id;
			this.distance = distance;
		}

		/**
		 * Creates and returns a string representation of the LevenshteinResult object.
		 */
		public function toString():String
		{
			return "[LevenshteinResult key:" + key + ", distance:" + distance + "]";
		}
	}
}