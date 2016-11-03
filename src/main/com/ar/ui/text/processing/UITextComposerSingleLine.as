package com.ar.ui.text.processing
{
	import com.ar.ui.text.UITextFormat;
	import com.ar.ui.text.font.UIFont;
	import com.ar.ui.text.font.glyph.*;

	import flash.geom.Rectangle;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class UITextComposerSingleLine implements IUITextComposer
	{
		public function UITextComposerSingleLine()
		{
		}

		public function process( glyphs:Vector.<UIGlyph>, ellipsis:Vector.<UIGlyph>, font:UIFont, format:UITextFormat, maxSize:Rectangle ):UITextLayout
		{
			var lines:Vector.<UITextLine> = new Vector.<UITextLine>;

			var line:UITextLine = UITextLine.build( glyphs, 0, format.tracking, int.MAX_VALUE );

			if( line.bounds.width > maxSize.width )
			{
				var diff:int = Math.abs( line.bounds.width - maxSize.width );

				if( diff < glyphs.length * ( font.size * 0.1 ) )
				{
					line = UITextLine.build( glyphs, 0, format.tracking - (diff / glyphs.length), maxSize.width );
				}
				else
				{
					while( glyphs.length > 0 )
					{
						if( line.bounds.width <= maxSize.width )
						{
							break;
						}

						var cutIndex:int = UIGlyphUtils.findLastIndexOf( line.glyphs, ' ' );

						cutIndex = Math.max( ( ( cutIndex != -1 ) ? cutIndex : (glyphs.length - 1) - ellipsis.length ), 0 );

						glyphs.splice( cutIndex, glyphs.length - cutIndex );
						glyphs = glyphs.concat( ellipsis );

						if( glyphs.length <= ellipsis.length )
						{
							return new UITextLayout( lines, new Rectangle() ); //empty
						}

						line = UITextLine.build( glyphs, 0, format.tracking, maxSize.width );
					}
				}
			}

			lines.push( line );

			return new UITextLayout( lines, line.bounds );
		}

		public function toString():String
		{
			return "[UITextLayouterSingleLine]";
		}
	}
}