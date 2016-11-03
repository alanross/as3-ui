package com.ar.ui.gesture.levenshtein
{
	import flash.geom.Point;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public interface ILevenshteinRecognizerObserver
	{
		/**
		 * Called when the path to be recognized was updated.
		 */
		function onLevenshteinUpdated( path:Vector.<Point> ):void;

		/**
		 * Called when the patch was process.
		 */
		function onLevenshteinRecognized( result:Vector.<LevenshteinResult> ):void;
	}
}