package com.ar.ui.component.list
{
	import com.ar.core.error.ElementAlreadyExistsError;
	import com.ar.core.error.ElementDoesNotExistError;
	import com.ar.math.Maths;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class UIList
	{
		private var _items:Vector.<UICellItem> = new Vector.<UICellItem>();

		private var _renderer:Vector.<UICellRenderer> = new Vector.<UICellRenderer>();
		private var _factory:IUICellRendererFactory;

		private var _container:Sprite = new Sprite();

		private var _bounds:Rectangle = new Rectangle();
		private var _itemsHeight:int = 0;
		private var _offset:int = 0;
		private var _cellSpacing:int = 1;
		private var _dirty:Boolean = false;

		public function UIList( rendererFactory:IUICellRendererFactory )
		{
			_factory = rendererFactory;

			_container.addEventListener( Event.RENDER, onRenderEvent );
		}

		private function getAssociatedRenderer( item:UICellItem ):UICellRenderer
		{
			var n:int = _renderer.length;

			while( --n > -1 )
			{
				if( _renderer[n].data == item )
				{
					return _renderer[n];
				}
			}

			return null;
		}

		private function measure():void
		{
			var result:int = 0;

			var n:int = _items.length;

			for( var i:int = 0; i < n; ++i )
			{
				result += _items[i].height + _cellSpacing;
			}

			_itemsHeight = result;
		}

		private function requestRender():void
		{
			_dirty = true;

			if( _container.stage )
			{
				_container.stage.invalidate();
			}
		}

		private function onRenderEvent( event:Event )
		{
			if( _dirty )
			{
				render();

				_dirty = false;
			}
		}

		private function render():void
		{
			if( _bounds.width < 1 || _bounds.height < 1 )
			{
				throw new Error( "Invalid size" );
			}

			var viewWidth:int = _bounds.width;
			var viewHeight:int = _bounds.height;
			var numItems:int = _items.length;
			var itemOffset:int = 0;
			var minView:int = _offset;
			var maxView:int = _offset + viewHeight;
			var renderer:UICellRenderer;

			for( var i:int = 0; i < numItems; ++i )
			{
				var item:UICellItem = _items[i];

				if( itemOffset + item.height < minView || itemOffset > maxView )
				{
					if( item.inViewRange )
					{
						renderer = getAssociatedRenderer( item );

						renderer.onDetach();

						item.inViewRange = false;

						_renderer.splice( _renderer.indexOf( renderer ), 1 );

						_container.removeChild( renderer.displayObject );

						_factory.release( renderer );
					}
				}
				else
				{
					if( !item.inViewRange )
					{
						renderer = _factory.create( i );

						if( itemOffset < _offset )
						{
							_renderer.unshift( renderer );
						}
						else
						{
							_renderer.push( renderer );
						}

						_container.addChild( renderer.displayObject );

						item.inViewRange = true;

						renderer.onAttach( item, viewWidth, item.height );
					}
					else
					{
						renderer = getAssociatedRenderer( item );
					}

					renderer.y = itemOffset - _offset;
				}

				itemOffset += item.height + _cellSpacing;
			}
		}

		public function addItem( item:UICellItem ):void
		{
			if( hasItem( item ) )
			{
				throw new ElementAlreadyExistsError();
			}

			_items.push( item );

			measure();

			requestRender();
		}

		public function removeItem( item:UICellItem ):void
		{
			if( !hasItem( item ) )
			{
				throw new ElementDoesNotExistError();
			}

			_items.splice( _items.indexOf( item ), 1 );

			measure();

			requestRender();
		}

		public function hasItem( item:UICellItem ):Boolean
		{
			return ( -1 != _items.indexOf( item ) );
		}

		public function getItem( item:UICellItem ):UICellItem
		{
			return _items[ _items.indexOf( item ) ];
		}

		public function moveTo( x:int, y:int ):void
		{
			_container.x = x;
			_container.y = y;
		}

		public function resizeTo( width:int, height:int ):void
		{
			if( width < 1 || height < 1 )
			{
				throw new Error( "Invalid size" );
			}

			if( _bounds.width != width || _bounds.height != height )
			{
				_bounds.width = width;
				_bounds.height = height;

				_container.graphics.clear();
				_container.graphics.beginFill( 0x454545 );
				_container.graphics.drawRect( 0, 0, width, height );
				_container.graphics.endFill();
				_container.scrollRect = _bounds;

				requestRender();
			}
		}

		public function get offset():int
		{
			return _offset;
		}

		public function set offset( value:int ):void
		{
			value = ( _itemsHeight < _bounds.height ) ? 0 : Maths.clampInt( value, 0, ( _itemsHeight - _bounds.height ) );

			if( _offset != value )
			{
				_offset = value;

				requestRender();
			}
		}

		public function get itemsHeight():int
		{
			return _itemsHeight;
		}

		public function get cellSpacing():int
		{
			return _cellSpacing;
		}

		public function get width():int
		{
			return _bounds.width;
		}

		public function get height():int
		{
			return _bounds.height;
		}

		public function get displayObject():DisplayObject
		{
			return _container;
		}

		public function toString():String
		{
			return "[UIList]";
		}
	}
}