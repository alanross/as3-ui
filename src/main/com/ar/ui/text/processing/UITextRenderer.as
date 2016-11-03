package com.ar.ui.text.processing
{
	import com.ar.ui.text.UITextFormat;
	import com.ar.ui.text.font.glyph.UIGlyph;
	import com.ar.ui.utils.bitmap.UITintBitmapDataFilter;

	import flash.display.BitmapData;
	import flash.display.Sprite;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class UITextRenderer extends Sprite
	{
		private var _tint:UITintBitmapDataFilter;

		private var _bitmapData:BitmapData;

		public function UITextRenderer()
		{
			_tint = new UITintBitmapDataFilter();
			_bitmapData = new BitmapData( 1, 1, true, 0 );
		}

		public function process( block:UITextLayout, format:UITextFormat ):void
		{
			if( block.bounds.width <= 0 || block.bounds.height <= 0 )
			{
				_bitmapData = new BitmapData( 1, 1, true, 0 );

				return;
			}

			_bitmapData = new BitmapData( block.bounds.width, block.bounds.height, true, 0x33898989 );

			var n:int = block.lines.length;

			for( var i:int = 0; i < n; ++i )
			{
				var line:UITextLine = block.lines[i];

				var glyphs:Vector.<UIGlyph> = line.glyphs;

				var m:int = glyphs.length;

				for( var j:int = 0; j < m; ++j )
				{
					var g:UIGlyph = glyphs[j];

					_bitmapData.copyPixels( g.bitmapData, g.sourceRect, g.topLeft, null, null, true );
				}
			}

			_tint.setByHex( format.color );
			_tint.process( _bitmapData );
		}

		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}

		override public function toString():String
		{
			return "[UITextRenderer]";
		}
	}
}