package com.ar.ui.resource
{
	import com.ar.core.job.Job;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class UILoadTexJob extends Job
	{
		private var _loader:Loader;
		private var _url:String;
		private var _bitmapData:BitmapData;

		/**
		 * Creates a new instance of UILoadTexJob.
		 */
		public function UILoadTexJob( url:String )
		{
			_url = url;

			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onLoadComplete );
			_loader.contentLoaderInfo.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onLoadSecurityError );
			_loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onLoadIOError );
		}

		/**
		 * @private
		 */
		private function onLoadIOError( event:IOErrorEvent ):void
		{
			fail( new Error( "LoadIOError: " + event.toString() ) );
		}


		/**
		 * @private
		 */
		private function onLoadSecurityError( event:SecurityErrorEvent ):void
		{
			fail( new Error( "SecurityError: " + event.toString() ) );
		}

		/**
		 * @private
		 */
		private function onLoadComplete( event:Event ):void
		{
			var bitmap:Bitmap = event.target.content;

			_bitmapData = bitmap.bitmapData;

			complete();
		}

		/**
		 * @inheritDoc
		 */
		override protected function onStart():void
		{
			_loader.load( new URLRequest( _url ) );
		}

		/**
		 * Frees all internal references of the object.
		 */
		override public function dispose():void
		{
			super.dispose();

			_loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, onLoadComplete );
			_loader = null;

			_bitmapData = null;
		}

		/**
		 * The loaded image. Will be null if the image is not loaded yet.
		 */
		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}

		/**
		 * The url of the image to load.
		 */
		public function get url():String
		{
			return _url;
		}

		/**
		 * Creates and returns a string representation of the UILoadTexJob object.
		 */
		override public function toString():String
		{
			return "[UILoadTexJob]";
		}
	}
}