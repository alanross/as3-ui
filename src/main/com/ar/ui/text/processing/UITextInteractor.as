package com.ar.ui.text.processing
{
	import com.ar.ui.text.UITextSelection;
	import com.ar.ui.text.font.glyph.*;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class UITextInteractor
	{
		public function UITextInteractor()
		{
		}

		public function getCursorIndexForPoint( glyphs:Vector.<UIGlyph>, point:Point ):int
		{
			var n:int = glyphs.length;

			var glyph:UIGlyph;

			for( var i:int = 0; i < n; ++i )
			{
				glyph = glyphs[i];

				if( glyph.containsPoint( point ) )
				{
					var b:Rectangle = glyph.selectionRect;

					var x:int = point.x - ( b.x + b.width * 0.5 );

					if( x < 0 )
					{
						return i - 1; // can and should result in -1;
					}
					else
					{
						return i;
					}
				}
			}

			return -1;
		}

		public function getGlyphUnderPoint( glyphs:Vector.<UIGlyph>, point:Point ):UIGlyph
		{
			var n:int = glyphs.length;

			for( var i:int = 0; i < n; ++i )
			{
				if( glyphs[i].containsPoint( point ) )
				{
					return glyphs[i];
				}
			}

			return null;
		}

		public function getWordUnderPoint( glyphs:Vector.<UIGlyph>, point:Point, selection:UITextSelection ):void
		{
			var n:int = glyphs.length;
			var glyph:UIGlyph = null;

			selection.firstIndex = 0;
			selection.lastIndex = 0;

			for( var i:int = 0; i < n; ++i )
			{
				glyph = glyphs[i];

				if( glyph.containsPoint( point ) )
				{
					if( UIGlyphUtils.isWordSeparator( glyph ) )
					{
						selection.firstIndex = i;
						selection.lastIndex = i;
					}
					else
					{
						selection.firstIndex = 0;
						selection.lastIndex = n - 1;

						for( var min:int = i; min > -1; --min )
						{
							if( UIGlyphUtils.isWordSeparator( glyphs[min] ) )
							{
								break;
							}

							selection.firstIndex = min;
						}

						for( var max:int = i; max < n; ++max )
						{
							if( UIGlyphUtils.isWordSeparator( glyphs[max] ) )
							{
								break;
							}

							selection.lastIndex = max;
						}
					}
				}
			}
		}

		public function toString():String
		{
			return "[UITextInteractor]";
		}
	}
}