package com.ar.ui.text.processing
{
	import com.ar.ui.text.font.glyph.*;

	import flash.geom.Rectangle;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class UITextLine
	{
		public static const COMPLETE:int = 1;
		public static const TRUNCATE_WIDTH:int = 2;
		public static const TRUNCATE_LINE_BREAK:int = 3;

		public var glyphs:Vector.<UIGlyph>;
		public var bounds:Rectangle;
		public var result:int = -1;

		public static function build( glyphs:Vector.<UIGlyph>, offsetY:Number, tracking:Number, maxWidth:Number ):UITextLine
		{
			var n:int = glyphs.length;
			var i:int = 0;
			var glyph:UIGlyph = null;

			var ox:Number = 0;
			var oy:Number = offsetY;

			var result:Vector.<UIGlyph> = new Vector.<UIGlyph>();
			var bounds:Rectangle = new Rectangle( ox, oy, 0, 0 );

			while( i < n )
			{
				glyph = glyphs[i];
				glyph.setTo( ox, oy );

				if( glyph.code == UIGlyph.NEW_LINE )
				{
					return new UITextLine( result, bounds, TRUNCATE_LINE_BREAK );
				}

				result.push( glyph );

				if( bounds.width < glyph.x + glyph.width )
				{
					bounds.width = glyph.x + glyph.width;
				}

				if( bounds.height < glyph.y + glyph.height - oy )
				{
					bounds.height = glyph.y + glyph.height - oy;
				}

				if( ox + glyph.width > maxWidth )
				{
					return new UITextLine( result, bounds, TRUNCATE_WIDTH );
				}

				if( n > ++i )
				{
					ox += glyph.xAdvance + glyph.getKerning( glyphs[i].code ) + tracking;
				}
			}

			return new UITextLine( result, bounds, COMPLETE );
		}

		public function UITextLine( glyphs:Vector.<UIGlyph>, bounds:Rectangle, result:int )
		{
			this.glyphs = glyphs;
			this.bounds = bounds;
			this.result = result;
		}

		public function toString():String
		{
			return "[UITextLine]";
		}
	}
}