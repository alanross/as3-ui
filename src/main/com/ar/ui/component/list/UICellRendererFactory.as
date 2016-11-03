package com.ar.ui.component.list
{
	import com.ar.math.Colors;
	import com.ar.math.Rand;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class UICellRendererFactory implements IUICellRendererFactory
	{
		private var _rendererPool:Vector.<UICellRenderer> = new Vector.<UICellRenderer>();
		private var _rendererPoolGrowthRate:int = 8;


		public function UICellRendererFactory()
		{
		}

		public function create( index:int ):UICellRenderer
		{
			if( 0 >= _rendererPool.length )
			{
				var n:int = _rendererPoolGrowthRate;

				while( --n > -1 )
				{
					_rendererPool.push( new UICellRenderer() );
				}
			}

			var renderer:UICellRenderer = _rendererPool.pop();

			renderer.color = ( index % 2 == 0 ) ? Colors.hsv2rgb( Rand.randomMinMax( 0, 360 ), 1.0, 1.0 ) : 0x898989;

			return renderer;
		}

		public function release( renderer:UICellRenderer ):void
		{
			_rendererPool.push( renderer );
		}

		public function toString():String
		{
			return "[UICellRendererFactory]";
		}
	}
}