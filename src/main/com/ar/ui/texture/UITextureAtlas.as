package com.ar.ui.texture
{
	import com.ar.ds.atlas.Atlas;
	import com.ar.ds.atlas.IAtlasElement;
	import com.ar.ui.utils.bitmap.UISlice9Grid;

	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public class UITextureAtlas extends Atlas implements IAtlasElement
	{
		private var _textureData:BitmapData;
		private var _id:String;

		public function UITextureAtlas( textureData:BitmapData, id:String )
		{
			_textureData = textureData;
			_id = id;
		}

		public function addTextureFromData( id:String, rect:Rectangle, sliceGrid:UISlice9Grid = null ):UITexture
		{
			var element:UITexture = new UITexture( _textureData, id, rect, sliceGrid );

			if( addElement( element ) )
			{
				return element;
			}

			throw new Error( this, "There was a problem creating UITexture" );
		}

		public function addTexture( element:UITexture ):Boolean
		{
			if( addElement( element ) )
			{
				element.onAttachToAtlas( _textureData );

				return true;
			}

			return false;
		}

		public function removeTexture( element:UITexture ):Boolean
		{
			if( removeElement( element ) )
			{
				element.onDetachAtlas( _textureData );

				return true;
			}

			return false;
		}

		public function getTexture( id:String ):UITexture
		{
			return UITexture( getElement( id ) );
		}

		public function hasTexture( element:UITexture ):Boolean
		{
			return hasTextureWithID( element.id );
		}

		public function hasTextureWithID( id:String ):Boolean
		{
			return hasElementWithId( id );
		}

		override public function dispose():void
		{
			super.dispose();
		}

		public function getBitmapData():BitmapData
		{
			return _textureData;
		}

		public function get id():String
		{
			return _id;
		}

		override public function toString():String
		{
			return "[UITextureAtlas _id:" + _id + "]";
		}
	}
}