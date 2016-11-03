package com.ar.ui.texture
{
	import com.ar.core.error.SingletonError;
	import com.ar.ds.atlas.Atlas;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public class UITextureManager extends Atlas
	{
		private static var _instance:UITextureManager;

		public static function initialize():void
		{
			if( _instance != null )
			{
				throw new SingletonError( "UITextureManager" );
			}

			_instance = new UITextureManager( new Lock() );
		}

		public static function get():UITextureManager
		{
			return _instance;
		}

		public function UITextureManager( lock:Lock )
		{
		}

		public function addAtlas( element:UITextureAtlas ):Boolean
		{
			return addElement( element );
		}

		public function removeAtlas( element:UITextureAtlas ):Boolean
		{
			return removeElement( element );
		}

		public function getAtlas( id:String ):UITextureAtlas
		{
			return UITextureAtlas( getElement( id ) );
		}

		public function hasAtlas( element:UITextureAtlas ):Boolean
		{
			return hasElementWithId( element.id );
		}

		public function hasAtlasWithId( id:String ):Boolean
		{
			return hasElementWithId( id );
		}

		override public function toString():String
		{
			return "[UITextureManager]";
		}
	}
}

class Lock
{
}