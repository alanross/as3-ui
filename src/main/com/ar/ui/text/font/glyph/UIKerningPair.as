package com.ar.ui.text.font.glyph
{
	import com.ar.core.utils.IDisposable;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public class UIKerningPair implements IDisposable
	{
		private var _firstGlyphCode:int;
		private var _secondGlyphCode:int;
		private var _kerning:int;

		/**
		 * Creates a new instance of UIKerningPair.
		 */
		public function UIKerningPair( firstGlyphCode:int, secondGlyphCode:int, kerningAmount:int )
		{
			_firstGlyphCode = firstGlyphCode;
			_secondGlyphCode = secondGlyphCode;
			_kerning = kerningAmount;
		}

		/**
		 * Frees all references of the object.
		 */
		public function dispose():void
		{
		}

		/**
		 *
		 */
		public function get firstGlyphCode():int
		{
			return _firstGlyphCode;
		}

		/**
		 *
		 */
		public function get secondGlyphCode():int
		{
			return _secondGlyphCode;
		}

		/**
		 *
		 */
		public function get kerning():int
		{
			return _kerning;
		}

		/**
		 * Creates and returns a string representation of the UIKerningPair object.
		 */
		public function toString():String
		{
			return "[UIKerningPair" +
					"  first" + _firstGlyphCode +
					"  second" + _secondGlyphCode +
					"  kerning" + _kerning + "]";
		}
	}
}