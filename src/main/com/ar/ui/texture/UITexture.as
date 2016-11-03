package com.ar.ui.texture
{
	import com.ar.core.utils.IDisposable;
	import com.ar.ds.atlas.IAtlasElement;
	import com.ar.ui.utils.bitmap.UISlice9Grid;

	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public class UITexture implements IAtlasElement, IDisposable
	{
		private var _id:String;
		private var _rect:Rectangle;
		private var _sliceGrid:UISlice9Grid;
		private var _textureData:BitmapData;

		public function UITexture( textureData:BitmapData, id:String, rect:Rectangle, sliceGrid:UISlice9Grid = null )
		{
			_id = id;
			_rect = rect;
			_sliceGrid = sliceGrid;

			onAttachToAtlas( textureData );
		}

		function onAttachToAtlas( textureData:BitmapData ):void
		{
			_textureData = textureData;
		}

		function onDetachAtlas( textureData:BitmapData ):void
		{
			_textureData = null;
		}

		public function dispose():void
		{
			_rect = null;
			_sliceGrid = null;
		}

		public function getSkinRect():Rectangle
		{
			return _rect;
		}

		public function getTextureRect():Rectangle
		{
			return new Rectangle( 0, 0, _textureData.width, _textureData.height );
		}

		public function getBitmapData():BitmapData
		{
			return _textureData;
		}

		public function getSliceGrid():UISlice9Grid
		{
			return _sliceGrid;
		}

		public function get id():String
		{
			return _id;
		}

		public function toString():String
		{
			return "[UITexture id:" + _id + ", slices:" + _sliceGrid + "]";
		}
	}
}