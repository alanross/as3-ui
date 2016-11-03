package com.ar.ui.text.font
{
	import com.ar.ds.atlas.Atlas;
	import com.ar.ds.atlas.IAtlasElement;
	import com.ar.ui.text.font.glyph.UIGlyph;

	import flash.display.BitmapData;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public class UIFont extends Atlas implements IAtlasElement
	{
		private var _textureData:BitmapData;
		private var _id:String;

		private var _face:String;
		private var _size:int;
		private var _lineHeight:int;
		private var _bold:Boolean;
		private var _italic:Boolean;

		public function UIFont( textureData:BitmapData, id:String, face:String, size:int, bold:Boolean, italic:Boolean, lineHeight:int )
		{
			_textureData = textureData;
			_id = id;
			_face = face;
			_size = size;
			_bold = bold;
			_italic = italic;
			_lineHeight = lineHeight;
		}

		public function addGlyph( glyph:UIGlyph ):Boolean
		{
			return addElement( glyph );
		}

		public function removeGlyph( glyph:UIGlyph ):Boolean
		{
			return removeElement( glyph );
		}

		public function getGlyphWithChar( character:String ):UIGlyph
		{
			return getGlyphWithCode( UIGlyph.charToCode( character ) );
		}

		public function getGlyphWithCode( code:int ):UIGlyph
		{
			return UIGlyph( getElement( String( code ) ) ).clone();
		}

		public function hasGlyphWithChar( character:String ):Boolean
		{
			return UIGlyph( getElement( String( UIGlyph.charToCode( character ) ) ) ).clone();
		}

		public function hasGlyphWithCode( code:int ):Boolean
		{
			return hasElementWithId( String( code ) );
		}

		override public function dispose():void
		{
			super.dispose();

			_face = null;
		}

		public function get bitmapData():BitmapData
		{
			return _textureData;
		}

		public function get face():String
		{
			return _face;
		}

		public function get size():int
		{
			return _size;
		}

		public function get bold():Boolean
		{
			return _bold;
		}

		public function get italic():Boolean
		{
			return _italic;
		}

		public function get lineHeight():int
		{
			return _lineHeight;
		}

		public function get id():String
		{
			return _id;
		}

		override public function toString():String
		{
			return "[UIFont" +
					" id:" + id +
					", fontId:" + face +
					", size:" + size +
					", bold:" + bold +
					", italic:" + italic + "]";
		}
	}
}