package com.ar.ui.text.font.glyph
{
	import com.ar.core.utils.IDisposable;
	import com.ar.ds.atlas.IAtlasElement;
	import com.ar.ui.text.font.UIFont;

	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class UIGlyph implements IAtlasElement, IDisposable
	{
		public static var NEW_LINE:int = 10;

		// id
		private var _code:int;
		private var _character:String;

		// the font of which the glyph is part of
		private var _font:UIFont;

		// the source texture bounds of the glyph
		private var _sourceRect:Rectangle;

		// the selection hit test bounds of the glyph
		private var _selectionRect:Rectangle;

		// the real bounds of the glyph
		private var _bounds:Rectangle;

		// metrics
		private var _xAdvance:int;
		private var _offset:Point;
		private var _lineHeight:int;
		private var _base:int;
		private var _kerning:Vector.<UIKerningPair>;

		public static function charToCode( character:String ):int
		{
			return character.charCodeAt( 0 );
		}

		public static function codeToChar( code:int ):String
		{
			return String.fromCharCode( code );
		}

		public function UIGlyph( atlas:UIFont, code:int, sourceRect:Rectangle, bounds:Rectangle, offset:Point, xAdvance:int, lineHeight:int, base:int, kerning:Vector.<UIKerningPair> )
		{
			_font = atlas;

			_code = code;
			_character = codeToChar( code );

			_sourceRect = sourceRect;
			_selectionRect = new Rectangle( 0, 0, xAdvance, lineHeight );
			_bounds = bounds;

			_offset = offset;
			_xAdvance = xAdvance;
			_lineHeight = lineHeight;
			_base = base;
			_kerning = kerning;

			setTo( 0, 0 );
		}

		public function clone():UIGlyph
		{
			return new UIGlyph( _font, _code, _sourceRect, _bounds.clone(), _offset, _xAdvance, _lineHeight, _base, _kerning );
		}

		public function setTo( x:int, y:int ):void
		{
			_selectionRect.x = x;
			_selectionRect.y = y;

			_bounds.x = xOffset + x;
			_bounds.y = yOffset + y;
		}

		public function containsPoint( point:Point ):Boolean
		{
			var px:int = point.x - _selectionRect.x;
			var py:int = point.y - _selectionRect.y;

			return !(px < 0 || px > _selectionRect.width || py < 0 || py > _selectionRect.height);
		}

		public function dispose():void
		{
			_font = null;
			_character = null;
			_sourceRect = null;
			_selectionRect = null;
			_bounds = null;
			_offset = null;
		}

		public function getKerning( code:int ):int
		{
			// amount of kerning between this glyph and the following one.
			// the code of the following glyph is passed into this function

			var n:int = _kerning.length;
			var pair:UIKerningPair;

			while( --n > -1 )
			{
				pair = _kerning[n];

				if( pair.secondGlyphCode == code )
				{
					return pair.kerning;
				}
			}

			return 0;
		}

		public function get code():int
		{
			return _code;
		}

		public function get character():String
		{
			return _character;
		}

		public function get sourceRect():Rectangle
		{
			return _sourceRect;
		}

		public function get bitmapData():BitmapData
		{
			return _font.bitmapData;
		}

		public function get selectionRect():Rectangle
		{
			return _selectionRect;
		}

		public function get topLeft():Point
		{
			return _bounds.topLeft;
		}

		public function get x():int
		{
			return _bounds.x;
		}

		public function get y():int
		{
			return _bounds.y;
		}

		public function get width():int
		{
			return _bounds.width;
		}

		public function get height():int
		{
			return _bounds.height;
		}

		public function get xAdvance():int
		{
			return _xAdvance;
		}

		public function get xOffset():int
		{
			return _offset.x;
		}

		public function get yOffset():int
		{
			return _offset.y;
		}

		public function get lineHeight():int
		{
			return _lineHeight;
		}

		public function get base():int
		{
			return _base;
		}

		public function get id():String
		{
			return String( _code );
		}

		public function toString():String
		{
			return "[UIGlyph" +
					" code:" + code +
					"characterr:" + character +
					" width:" + width +
					" height:" + height +
					" lineHeight:" + lineHeight +
					" base:" + base +
					" xAdvance:" + xAdvance +
					" xOffset:" + xOffset +
					" yOffset:" + yOffset + "]";
		}

	}
}