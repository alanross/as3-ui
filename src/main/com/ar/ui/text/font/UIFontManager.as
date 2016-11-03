package com.ar.ui.text.font
{
	import com.ar.core.error.SingletonError;
	import com.ar.ds.atlas.Atlas;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public class UIFontManager extends Atlas
	{
		private static var _instance:UIFontManager;

		public static function initialize():void
		{
			if( _instance != null )
			{
				throw new SingletonError( "UIFontManager" );
			}

			_instance = new UIFontManager( new Lock() );
		}

		public static function get():UIFontManager
		{
			return _instance;
		}

		public function UIFontManager( lock:Lock )
		{
		}

		public function addFont( element:UIFont ):Boolean
		{
			return addElement( element );
		}

		public function removeFont( element:UIFont ):Boolean
		{
			return removeElement( element );
		}

		public function getFont( id:String ):UIFont
		{
			return UIFont( getElement( id ) );
		}

		public function hasFont( element:UIFont ):Boolean
		{
			return hasFontWithId( element.id );
		}

		public function hasFontWithId( id:String ):Boolean
		{
			return hasFontWithId( id );
		}

		override public function toString():String
		{
			return "[UIFontManager]";
		}
	}
}

class Lock
{
}