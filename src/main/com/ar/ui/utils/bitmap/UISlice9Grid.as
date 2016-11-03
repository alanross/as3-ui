package com.ar.ui.utils.bitmap
{
	import com.ar.core.error.NullError;
	import com.ar.core.error.ValueError;

	import flash.geom.Rectangle;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public class UISlice9Grid
	{
		public var left:int;
		public var right:int;
		public var top:int;
		public var bottom:int;

		public static function createSliceRectangles( rect:Rectangle, sliceGrid:UISlice9Grid ):Vector.<Rectangle>
		{
			if( null == rect )
			{
				throw new NullError( "rect: rect can not be null" );
			}

			const left:int = sliceGrid.left;
			const right:int = sliceGrid.right;
			const top:int = sliceGrid.top;
			const bottom:int = sliceGrid.bottom;

			if( left < 0 || right < 0 || top < 0 || bottom < 0 )
			{
				throw new ValueError( "Slice value can not be smaller than zero. " +
						"Left:" + left + "Right:" + right + " Top:" + top + " Bottom:" + bottom );
			}

			if( rect.width < ( left + right ) )
			{
				throw new ValueError( "Source width is smaller than combined left+right slice width. " +
						"Source width: " + rect.width + " Left:" + left + " Right:" + right );
			}

			if( rect.height < ( top + bottom ) )
			{
				throw new ValueError( "Source height is smaller than combined top+bottom slice height. " +
						"Source height: " + rect.height + " Top:" + top + " Bottom:" + bottom );
			}

			const offsetRight:int = rect.width - right;
			const offsetBottom:int = rect.height - bottom;

			const centerWidth:int = rect.width - ( left + right );
			const centerHeight:int = rect.height - ( top + bottom );

			const offsetX:int = rect.x;
			const offsetY:int = rect.y;

			var slices:Vector.<Rectangle> = new Vector.<Rectangle>( 9, true );

			slices[0] = new Rectangle( offsetX, offsetY, left, top ); //tl
			slices[1] = new Rectangle( offsetX + left, offsetY, centerWidth, top ); //tc
			slices[2] = new Rectangle( offsetX + offsetRight, offsetY, right, top ); //tr

			slices[3] = new Rectangle( offsetX, offsetY + top, left, centerHeight ); //ml
			slices[4] = new Rectangle( offsetX + left, offsetY + top, centerWidth, centerHeight ); //mc
			slices[5] = new Rectangle( offsetX + offsetRight, offsetY + top, right, centerHeight ); //mr

			slices[6] = new Rectangle( offsetX, offsetY + offsetBottom, left, bottom ); //bl
			slices[7] = new Rectangle( offsetX + left, offsetY + offsetBottom, centerWidth, bottom ); //bc
			slices[8] = new Rectangle( offsetX + offsetRight, offsetY + offsetBottom, right, bottom ); //br

			return slices;
		}

		public function UISlice9Grid( left:int, right:int, top:int, bottom:int )
		{
			all( left, right, top, bottom );
		}

		public function all( left:int, right:int, top:int, bottom:int ):void
		{
			this.top = ( 0 > top ) ? 0 : top;
			this.right = ( 0 > right ) ? 0 : right;
			this.bottom = ( 0 > bottom ) ? 0 : bottom;
			this.left = ( 0 > left ) ? 0 : left;
		}

		public function leftright( left:int, right:int ):void
		{
			this.left = ( 0 > left ) ? 0 : left;
			this.right = ( 0 > right ) ? 0 : right;
		}

		public function topbottom( top:int, bottom:int ):void
		{
			this.top = ( 0 > top ) ? 0 : top;
			this.bottom = ( 0 > bottom ) ? 0 : bottom;
		}

		public function clear():void
		{
			this.top = 0;
			this.right = 0;
			this.bottom = 0;
			this.left = 0;
		}

		public function clone():UISlice9Grid
		{
			return new UISlice9Grid( left, right, top, bottom );
		}

		public function toString():String
		{
			return "[UISlice9Grid left:" + left + " right:" + right + " top:" + top + " bottom:" + bottom + "]";
		}
	}
}
