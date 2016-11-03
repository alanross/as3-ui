package com.ar.ui.text
{
	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class UITextSelection
	{
		public var firstIndex:int = -1;
		public var lastIndex:int = -1;

		public function UITextSelection( firstIndex:int = 0, lastIndex:int = 0 )
		{
			this.firstIndex = firstIndex;
			this.lastIndex = lastIndex;
		}

		public function toString():String
		{
			return "[UITextSelection]";
		}
	}
}