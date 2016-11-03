package com.ar.ui.utils.bitmap
{
	import com.ar.core.utils.IDisposable;
	import com.ar.math.Colors;

	import flash.display.BitmapData;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class UITintBitmapDataFilter implements IDisposable
	{
		private const origin:Point = new Point();

		private var _filter:ColorMatrixFilter;

		private var _color:int;

		public function UITintBitmapDataFilter( hexARGB:int = 0xFF000000 )
		{
			setByHex( hexARGB );
		}

		public function process( bitmapData:BitmapData ):void
		{
			bitmapData.applyFilter( bitmapData, bitmapData.rect, origin, _filter );
		}

		public function setByHex( hexARGB:int ):void
		{
			var colors:Array = Colors.hex2argb( hexARGB );

			setByArgb( colors[0], colors[1], colors[2], colors[3] );
		}

		public function setByArgb( a:int, r:int, g:int, b:int ):void
		{
			_color = Colors.argb2hex( a, r, g, b );

			_filter = new ColorMatrixFilter( [ r / 255.0, 0, 0, 0, 0,
											   0, g / 255.0, 0, 0, 0,
											   0, 0, b / 255.0, 0, 0,
											   0, 0, 0, a / 255.0, 0 ] );
		}

		public function dispose():void
		{
			_filter = null;
		}

		public function get color():int
		{
			return _color;
		}

		public function toString():String
		{
			return "[UITintBitmapDataFilter]";
		}
	}
}