package com.ar.ui.component.list
{
	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public interface IUICellRendererFactory
	{
		function create( index:int ):UICellRenderer;

		function release( renderer:UICellRenderer ):void;
	}
}