package com.ar.ui.gesture.onedollar
{
	import flash.geom.Point;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public interface IOneDollarRecognizerObserver
	{
		/**
		 * Called when a stroke to be recognized was updated.
		 */
		function onOneDollarUpdated( path:Vector.<Point> ):void;

		/**
		 * Called when the matching process of path am templates has completed.
		 */
		function onOneDollarRecognized( result:OneDollarResult ):void;
	}
}