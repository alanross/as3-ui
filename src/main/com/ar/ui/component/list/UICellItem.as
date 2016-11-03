package com.ar.ui.component.list
{
	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public class UICellItem
	{
		internal var inViewRange:Boolean = false;

		private var _text:String;
		private var _height:int;

		public function UICellItem( text:String, height:int )
		{
			_text = text;
			_height = height;
		}

		public function get text():String
		{
			return _text;
		}

		public function get height():int
		{
			return _height;
		}

		public function get isInViewRange():Boolean
		{
			return inViewRange;
		}

		public function toString():String
		{
			return "[UICellItem text:" + text + "]";
		}
	}
}