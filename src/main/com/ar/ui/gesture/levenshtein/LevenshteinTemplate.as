package com.ar.ui.gesture.levenshtein
{
	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class LevenshteinTemplate
	{
		public var id:String;
		public var sequence:String;

		/**
		 * Creates a new instance of LevenshteinTemplate.
		 */
		public function LevenshteinTemplate( id:String, sequence:String )
		{
			this.id = id;
			this.sequence = sequence;
		}

		/**
		 * Creates and returns a string representation of the LevenshteinTemplate object.
		 */
		public function toString():String
		{
			return "[LevenshteinTemplate id:" + id + ", sequence:" + sequence + "]";
		}
	}
}