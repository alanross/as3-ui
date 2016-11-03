package com.ar.ui.utils.bitmap
{
	import com.ar.core.error.NullError;
	import com.ar.core.error.ValueError;
	import com.ar.core.utils.IDisposable;

	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public class UISlice9Image implements IDisposable
	{
		private var _point:Point;
		private var _rect:Rectangle;
		private var _matrix:Matrix;

		private var _tl:BitmapData;	//top left
		private var _tc:BitmapData; //top center
		private var _tr:BitmapData; //top right

		private var _ml:BitmapData; // middle left
		private var _mc:BitmapData; // middle center
		private var _mr:BitmapData; // middle right

		private var _bl:BitmapData; // bottom left
		private var _bc:BitmapData; // bottom center
		private var _br:BitmapData; // bottom right

		private var _sliceLeft:int = 0;
		private var _sliceRight:int = 0;
		private var _sliceTop:int = 0;
		private var _sliceBottom:int = 0;

		private var _minWidth:int = 0;
		private var _minHeight:int = 0;

		public function UISlice9Image( source:BitmapData, sliceGrid:UISlice9Grid = null )
		{
			_point = new Point();
			_rect = new Rectangle();
			_matrix = new Matrix();

			create( source, sliceGrid );
		}

		private function slice( source:BitmapData, x:int, y:int, width:int, height:int ):BitmapData
		{
			if( width <= 0 || height <= 0 )
			{
				return null;
			}

			_rect.setTo( x, y, width, height );
			_point.setTo( 0, 0 );

			const result:BitmapData = new BitmapData( width, height, true, 0 );

			result.copyPixels( source, _rect, _point );

			return result;
		}

		public function create( source:BitmapData, sliceGrid:UISlice9Grid ):void
		{
			if( null == source )
			{
				throw new NullError( this + " Source can not be null" );
			}

			if( null != sliceGrid )
			{
				_sliceLeft = sliceGrid.left;
				_sliceRight = sliceGrid.right;
				_sliceTop = sliceGrid.top;
				_sliceBottom = sliceGrid.bottom;
			}
			else
			{
				_sliceLeft = 0;
				_sliceRight = 0;
				_sliceTop = 0;
				_sliceBottom = 0;
			}

			_minWidth = _sliceLeft + _sliceRight;
			_minHeight = _sliceTop + _sliceBottom;

			if( _sliceLeft < 0 || _sliceRight < 0 || _sliceTop < 0 || _sliceBottom < 0 )
			{
				throw new ValueError( "Slice value can not be smaller than zero. " +
						"Left:" + _sliceLeft + "Right:" + _sliceRight + " Top:" + _sliceTop + " Bottom:" + _sliceBottom );
			}

			if( source.width < ( _sliceLeft + _sliceRight ) )
			{
				throw new ValueError( "Source width is smaller than combined left+right slice width. " +
						"Source width: " + source.width + " Left:" + _sliceLeft + " Right:" + _sliceRight );
			}

			if( source.height < ( _sliceTop + _sliceBottom ) )
			{
				throw new ValueError( "Source height is smaller than combined top+bottom slice height. " +
						"Source height: " + source.height + " Top:" + _sliceTop + " Bottom:" + _sliceBottom );
			}

			const offsetRight:int = source.width - _sliceRight;
			const offsetBottom:int = source.height - _sliceBottom;
			const sliceCenterWidth:int = source.width - ( _sliceLeft + _sliceRight );
			const sliceCenterHeight:int = source.height - ( _sliceTop + _sliceBottom );

			_tl = slice( source, 0, 0, _sliceLeft, _sliceTop );
			_tc = slice( source, _sliceLeft, 0, sliceCenterWidth, _sliceTop );
			_tr = slice( source, offsetRight, 0, _sliceRight, _sliceTop );

			_ml = slice( source, 0, _sliceTop, _sliceLeft, sliceCenterHeight );
			_mc = slice( source, _sliceLeft, _sliceTop, sliceCenterWidth, sliceCenterHeight );
			_mr = slice( source, offsetRight, _sliceTop, _sliceRight, sliceCenterHeight );

			_bl = slice( source, 0, offsetBottom, _sliceLeft, _sliceBottom );
			_bc = slice( source, _sliceLeft, offsetBottom, sliceCenterWidth, _sliceBottom );
			_br = slice( source, offsetRight, offsetBottom, _sliceRight, _sliceBottom );
		}

		public function resizeTo( width:int, height:int ):BitmapData
		{
			if( width <= 0 || height <= 0 )
			{
				return null;
			}

			if( width < _minWidth )
			{
				throw new ValueError( "Width is smaller than combined left+right slices width. " +
						"Width: " + width + " Left:" + _sliceLeft + " Right:" + _sliceRight );
			}

			if( height < _minHeight )
			{
				throw new ValueError( "Height is smaller than combined top+bottom slices height. " +
						"Height: " + height + "Top:" + _sliceTop + " Bottom:" + _sliceBottom );
			}

			const offsetRight:int = width - _sliceRight;
			const offsetBottom:int = height - _sliceBottom;

			const centerWidth:int = width - ( _sliceLeft + _sliceRight );
			const centerHeight:int = height - ( _sliceTop + _sliceBottom );

			const a:Number = centerWidth / _mc.width;
			const d:Number = centerHeight / _mc.height;

			const output:BitmapData = new BitmapData( width, height, true, 0 );

			if( _tl != null )
			{
				_point.setTo( 0, 0 );
				output.copyPixels( _tl, _tl.rect, _point );
			}

			if( _bl != null )
			{
				_point.setTo( 0, offsetBottom );
				output.copyPixels( _bl, _bl.rect, _point );
			}

			if( _tr != null )
			{
				_point.setTo( offsetRight, 0 );
				output.copyPixels( _tr, _tr.rect, _point );
			}

			if( _br != null )
			{
				_point.setTo( offsetRight, offsetBottom );
				output.copyPixels( _br, _br.rect, _point );
			}

			_matrix.a = a;
			_matrix.d = d;

			if( _mc != null )
			{
				_matrix.tx = _sliceLeft;
				_matrix.ty = _sliceTop;
				_rect.setTo( _sliceLeft, _sliceTop, centerWidth, centerHeight );
				output.draw( _mc, _matrix, null, null, _rect );
			}

			_matrix.a = 1;
			_matrix.d = d;

			if( _ml != null )
			{
				_matrix.tx = 0;
				_matrix.ty = _sliceTop;
				_rect.setTo( 0, _sliceTop, _sliceLeft, centerHeight );
				output.draw( _ml, _matrix, null, null, _rect );
			}

			if( _mr != null )
			{
				_matrix.tx = offsetRight;
				_matrix.ty = _sliceTop;
				_rect.setTo( offsetRight, _sliceTop, _sliceRight, centerHeight );
				output.draw( _mr, _matrix, null, null, _rect );
			}

			_matrix.a = a;
			_matrix.d = 1;

			if( _tc != null )
			{
				_matrix.tx = _sliceLeft;
				_matrix.ty = 0;
				_rect.setTo( _sliceLeft, 0, centerWidth, _sliceTop );
				output.draw( _tc, _matrix, null, null, _rect );
			}

			if( _bc != null )
			{
				_matrix.tx = _sliceLeft;
				_matrix.ty = offsetBottom;
				_rect.setTo( _sliceLeft, offsetBottom, centerWidth, _sliceBottom );
				output.draw( _bc, _matrix, null, null, _rect );
			}

			return output;
		}

		public function dispose():void
		{
			_point = null;
			_rect = null;
			_matrix = null;

			_tl = null;
			_tc = null;
			_tr = null;

			_mc = null;
			_ml = null;
			_mr = null;

			_bl = null;
			_bc = null;
			_br = null;

			_sliceLeft = 0;
			_sliceRight = 0;
			_sliceTop = 0;
			_sliceBottom = 0;

			_minWidth = 0;
			_minHeight = 0;
		}

		public function get minWidth():int
		{
			return _minWidth;
		}

		public function get minHeight():int
		{
			return _minHeight;
		}

		public function toString():String
		{
			return "[UISlice9Image]";
		}
	}
}