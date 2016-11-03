package com.ar.ui.component.list
{
	import com.ar.core.utils.StringUtils;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public class UICellRenderer
	{
		private var _bounds:Rectangle;
		private var _data:UICellItem;

		private var _container:Sprite;
		private var _textField:TextField;
		private var _color:int = 0x0;

		public function UICellRenderer()
		{
			_container = new Sprite();

			_bounds = new Rectangle();

			_textField = new TextField();
			_textField.text = "UNDEFINED";
			_textField.textColor = 0xffffff;
			_textField.selectable = false;

			_container.addChild( _textField );
		}

		private function repaint():void
		{
			_container.graphics.clear();
			_container.graphics.beginFill( _color, 0.8 );
			_container.graphics.drawRect( 0, 0, _bounds.width, _bounds.height );
			_container.graphics.endFill();
		}

		public function onAttach( data:UICellItem, cellWidth:int, cellHeight:int ):void
		{
			if( _data != null )
			{
				throw new Error( this + " Attach – Data is not null!" );
			}

			_data = data;
			_bounds.width = cellWidth;
			_bounds.height = cellHeight;

			_textField.text = _data.text + " - " + StringUtils.randomSequence( 5 );

			repaint();
		}

		public function onDetach():void
		{
			if( _data == null )
			{
				throw new Error( this + " Detach – Data is null!" );
			}

			_data = null;

			_bounds.width = _bounds.height = 0;
			_textField.text = "UNDEFINED";
		}

		public function get data():UICellItem
		{
			return _data;
		}

		public function get displayObject():DisplayObject
		{
			return _container;
		}

		public function set x( value:int ):void
		{
			_container.x = value;
		}

		public function get x():int
		{
			return _container.x;
		}

		public function set y( value:int ):void
		{
			_container.y = value;
		}

		public function get y():int
		{
			return _container.y;
		}

		public function get width():int
		{
			return _bounds.width;
		}

		public function get height():int
		{
			return _bounds.height;
		}

		public function get color():int
		{
			return _color;
		}

		public function set color( value:int ):void
		{
			_color = value;
		}

		public function toString():String
		{
			return "[UICellRenderer info:" + _textField.text + "]";
		}
	}
}