package com.ar.ui.utils.gpu
{
	import flash.display.Stage;
	import flash.display.Stage3D;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public interface IUIStage3DRequestObserver
	{
		/**
		 * Called if Stage3D is available. This is true of the system supports GPU rendering.
		 */
		function onStage3DAvailable( stage3d:Stage3D ):void;

		/**
		 * Called if Stage3D is not available. This is true of the system only supports CPU rendering.
		 */
		function onStage3DUnavailable( stage:Stage ):void;
	}
}