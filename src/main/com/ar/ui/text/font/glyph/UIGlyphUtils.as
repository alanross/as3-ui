package com.ar.ui.text.font.glyph
{
	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class UIGlyphUtils
	{
		private static var _wordSeparatorChars:Vector.<int>;

		public static function findLastIndexOf( glyphs:Vector.<UIGlyph>, character:String ):int
		{
			var code:int = UIGlyph.charToCode( character );
			var n:int = glyphs.length;

			while( --n > -1 )
			{
				if( glyphs[n].code == code )
				{
					return n;
				}
			}

			return -1;
		}

		public static function glyphsToString( glyphs:Vector.<UIGlyph> ):String
		{
			const n:int = glyphs.length;
			var str:String = "";

			for( var i:int = 0; i < n; ++i )
			{
				str += UIGlyph.codeToChar( glyphs[i].code );
			}

			return str;
		}

		public static function isWordSeparator( glyph:UIGlyph ):Boolean
		{
			if( _wordSeparatorChars == null )
			{
				_wordSeparatorChars = new Vector.<int>();
				_wordSeparatorChars.push( UIGlyph.charToCode( " " ) );
				_wordSeparatorChars.push( UIGlyph.charToCode( "." ) );
				_wordSeparatorChars.push( UIGlyph.charToCode( "," ) );
				_wordSeparatorChars.push( UIGlyph.charToCode( ";" ) );
				_wordSeparatorChars.push( UIGlyph.charToCode( "!" ) );
				_wordSeparatorChars.push( UIGlyph.charToCode( "?" ) );
			}

			var code:int = glyph.code;

			const n:int = _wordSeparatorChars.length;

			for( var i:int = 0; i < n; ++i )
			{
				if( _wordSeparatorChars[i] == code )
				{
					return true;
				}
			}

			return false;
		}

		public function UIGlyphUtils()
		{
			throw new Error( "UIGlyphUtils class is static container only" );
		}

		public function toString():String
		{
			return "[UIGlyphUtils]";
		}
	}
}