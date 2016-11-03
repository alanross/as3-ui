package com.ar.ui.text.processing
{
	import com.ar.ui.text.UITextFormat;
	import com.ar.ui.text.font.UIFont;
	import com.ar.ui.text.font.glyph.UIGlyph;
	import com.ar.ui.text.font.glyph.UIGlyphUtils;

	import flash.geom.Rectangle;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class UITextComposerMultiLine implements IUITextComposer
	{
		public function UITextComposerMultiLine()
		{
		}

		private function truncate( glyphs:Vector.<UIGlyph>, ellipsis:Vector.<UIGlyph>, tracking:Number, offset:Number, maxWidth:int ):UITextLine
		{
			if( glyphs[glyphs.length - 1].character == ' ' )
			{
				glyphs.pop();
			}

			while( glyphs.length > 0 )
			{
				glyphs = glyphs.concat( ellipsis );

				if( glyphs.length <= ellipsis.length )
				{
					return null;
				}

				var line:UITextLine = UITextLine.build( glyphs, offset, tracking, maxWidth );

				if( line.bounds.width <= maxWidth )
				{
					return line;
				}

				var cutIndex:int = Math.max( ( ( glyphs.length - 1 ) - ellipsis.length ), 0 );

				glyphs.splice( cutIndex, glyphs.length - cutIndex );
			}

			return null;
		}

		public function process( glyphs:Vector.<UIGlyph>, ellipsis:Vector.<UIGlyph>, font:UIFont, format:UITextFormat, maxSize:Rectangle ):UITextLayout
		{
			var lines:Vector.<UITextLine> = new Vector.<UITextLine>;
			var line:UITextLine;
			var offset:int = 0;
			var offsetStep:int = font.lineHeight + format.lineSpacing;
			var truncateLine:Boolean = false;

			while( glyphs.length > 0 )
			{
				line = UITextLine.build( glyphs, offset, format.tracking, maxSize.width );

				if( line.bounds.y + line.bounds.height > maxSize.height )
				{
					offset -= offsetStep;
					truncateLine = ( lines.length > 0 );
					break;
				}
				else if( line.result == UITextLine.COMPLETE )
				{
					glyphs.splice( 0, glyphs.length );
				}
				else if( line.result == UITextLine.TRUNCATE_LINE_BREAK )
				{
					glyphs.splice( 0, line.glyphs.length + 1 );
				}
				else if( line.result == UITextLine.TRUNCATE_WIDTH )
				{
					var cutIndex:int = UIGlyphUtils.findLastIndexOf( line.glyphs, ' ' );

					if( cutIndex == -1 )
					{
						if( lines.length == 0 )
						{
							lines.push( line );
						}

						truncateLine = true;
						break;
					}

					var removed:Vector.<UIGlyph> = glyphs.splice( 0, cutIndex + 1 );

					line = UITextLine.build( removed, offset, format.tracking, maxSize.width );
				}

				offset += offsetStep;

				lines.push( line );
			}

			if( truncateLine )
			{
				line = truncate( lines.pop().glyphs, ellipsis, format.tracking, offset, maxSize.width );

				if( line != null )
				{
					lines.push( line );
				}
			}

			var bounds:Rectangle = new Rectangle();

			for( var i:int = 0; i < lines.length; ++i )
			{
				line = lines[i];

				if( bounds.width < line.bounds.width )
				{
					bounds.width = line.bounds.width;
				}

				bounds.height += offsetStep;
			}

			return new UITextLayout( lines, bounds );
		}

		public function toString():String
		{
			return "[UITextComposerMultiLine]";
		}
	}
}