package com.ar.ui.resource
{
	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public interface IUIResourceLoaderQueueObserver
	{
		/**
		 * Called of the resource loading process ended successfully.
		 */
		function onResourceLoadingSuccess():void;

		/**
		 * Called of the resource loading process failed.
		 */
		function onResourceLoadingFailure( error:Error ):void;
	}
}