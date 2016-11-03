package com.ar.ui.text
{
	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public class UITextFormat
	{
		public var fontId:String;

		public var color:int = 0xFF000000;
		public var leading:int = 0;
		public var tracking:int = 0;
		public var alignType:int = 0;
		public var lineSpacing:int = 0;

		public function UITextFormat( fontId:String, color:int = 0xFF000000, leading:int = 0, tracking:int = 0, alignType:int = 0, lineSpacing:int = 0 )
		{
			this.fontId = fontId;

			this.color = color;
			this.leading = leading;
			this.tracking = tracking;
			this.alignType = alignType;
			this.lineSpacing = lineSpacing;
		}

		public function clone():UITextFormat
		{
			return new UITextFormat( fontId, color, leading, tracking, alignType, lineSpacing );
		}

		public function toString():String
		{
			return "[UITextFormat" +
					", fontId" + fontId +
					", color" + color +
					", leading" + leading +
					", tracking" + tracking +
					", alignType" + alignType +
					", lineSpacing" + lineSpacing +
					"]";
		}
	}
}