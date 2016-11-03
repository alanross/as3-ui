package com.ar.ui.text.processing
{
	import flash.geom.Rectangle;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class UITextLayout
	{
		public var lines:Vector.<UITextLine>;
		public var bounds:Rectangle = new Rectangle();

		public function UITextLayout( lines:Vector.<UITextLine>, bounds:Rectangle )
		{
			this.lines = ( lines != null ) ? lines : new Vector.<UITextLine>();
			this.bounds = bounds;
		}

		public function toString():String
		{
			return "[UITextLayout]";
		}
	}
}