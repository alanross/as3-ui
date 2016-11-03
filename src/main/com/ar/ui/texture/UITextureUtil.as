package com.ar.ui.texture
{
	import com.ar.core.error.ValueError;
	import com.ar.math.Maths;

	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class UITextureUtil
	{
		/**
		 * validates the size of a potential texture (bitmap)
		 * and returns a valid size a texture for the gpu can have.
		 *
		 * supported size are 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048
		 *
		 * Example: 145 would return 512.
		 */
		public static function validateSize( size:int ):int
		{
			if( size <= 0 )
			{
				throw new ValueError( size + " is not a valid size, it is smaller than 0." );
			}
			if( size < 2 )
			{
				return 2;
			}
			if( size > 2048 )
			{
				return 2048;
			}

			return Maths.nextPowerOfTwo( size );
		}

		/**
		 * Creates and returns a new BitmapData with given BitmapData copied into it,
		 * with a valid gpu texture size.
		 */
		public static function createFromBitmapData( bmd:BitmapData ):BitmapData
		{
			var result:BitmapData = createFromSize( ( bmd.width >= bmd.height ) ? bmd.width : bmd.height );

			result.lock();
			result.copyPixels( bmd, bmd.rect, new Point() );
			result.unlock();

			return result;
		}

		/**
		 * Creates and returns a new BitmapData with a valid gpu texture size.
		 */
		public static function createFromSize( size:int ):BitmapData
		{
			size = validateSize( size );

			return new BitmapData( size, size, true, 0x00ffffff );
		}

		/**
		 * Creates a Vector containing the UV coordinates of given sprite rectangle in relation to
		 * the texture rectangle.
		 */
		public static function createUVs( textureRect:Rectangle, spriteRect:Rectangle ):Vector.<Number>
		{
			var x:Number = spriteRect.x / textureRect.width;
			var y:Number = spriteRect.y / textureRect.height;
			var w:Number = spriteRect.width / textureRect.width;
			var h:Number = spriteRect.height / textureRect.height;

			var uvs:Vector.<Number> = new Vector.<Number>( 8, true );

			// bl, tl, tr, br
			uvs[0] = x;
			uvs[1] = y + h;
			uvs[2] = x;
			uvs[3] = y;
			uvs[4] = x + w;
			uvs[5] = y;
			uvs[6] = x + w;
			uvs[7] = y + h;

			return uvs;
		}

		/**
		 * Creates a new Rectangle containing the normalized uv coordinates defined by the spriteRect.
		 */
		public static function createUVRect( textureRect:Rectangle, spriteRect:Rectangle ):Rectangle
		{
			return new Rectangle(
					spriteRect.x / textureRect.width,
					spriteRect.y / textureRect.height,
					spriteRect.width / textureRect.width,
					spriteRect.height / textureRect.height
			);
		}

		/**
		 * Creates a new instance of UITextureUtil.
		 */
		public function UITextureUtil()
		{
			throw new Error( "You can not instantiate UITextureUtil as it is a static container." );
		}

		/**
		 * Generates and returns the string representation of the UITextureUtil object.
		 */
		public function toString():String
		{
			return "[UITextureUtil]";
		}
	}
}