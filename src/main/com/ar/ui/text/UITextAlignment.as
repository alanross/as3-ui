package com.ar.ui.text
{
	import com.ar.core.utils.StringUtils;

	/**
	 * Enumeration of the different alignment types a text can have.
	 *
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class UITextAlignment
	{
		public static var LEFT:uint = 1;
		public static var CENTER:uint = 2;
		public static var RIGHT:uint = 4;

		public static var TOP:uint = 8;
		public static var MIDDLE:uint = 16;
		public static var BOTTOM:uint = 32;

		/**
		 * Creates and returns a string representation of alignment type.
		 */
		public static function typeToString( type:int ):String
		{
			var result:String = "";

			if( ( type & TOP ) == TOP )
			{
				result += "TOP";
			}
			if( ( type & MIDDLE ) == MIDDLE )
			{
				result += "MIDDLE";
			}
			if( ( type & BOTTOM ) == BOTTOM )
			{
				result += "BOTTOM";
			}
			if( ( type & LEFT ) == LEFT )
			{
				result += "LEFT";
			}
			if( ( type & CENTER ) == CENTER )
			{
				result += "CENTER";
			}
			if( ( type & RIGHT ) == RIGHT )
			{
				result += "RIGHT";
			}

			return ( StringUtils.isEmpty( result ) ) ? "unknown" : result;
		}

		/**
		 * UITextAlignment class is static container only.
		 */
		public function UITextAlignment()
		{
			throw new Error( "UITextAlignment class is static container only" );
		}

		/**
		 * Creates and returns a string representation of the UITextAlignment object.
		 */
		public function toString():String
		{
			return "[UITextAlignment]";
		}
	}
}