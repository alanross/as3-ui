package com.ar.ui.text.processing
{
	import com.ar.ui.text.UITextFormat;
	import com.ar.ui.text.font.UIFont;
	import com.ar.ui.text.font.glyph.UIGlyph;

	import flash.geom.Rectangle;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public interface IUITextComposer
	{
		function process( glyphs:Vector.<UIGlyph>, ellipsis:Vector.<UIGlyph>, font:UIFont, format:UITextFormat, maxSize:Rectangle ):UITextLayout;
	}
}