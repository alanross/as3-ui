package com.ar.ui.resource
{
	import com.ar.core.job.Job;

	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class UILoadXmlJob extends Job
	{
		private var _loader:URLLoader;
		private var _url:String;
		private var _xml:XML;

		/**
		 * Creates a new instance of UILoadXmlJob.
		 */
		public function UILoadXmlJob( url:String )
		{
			_url = url;

			_loader = new URLLoader();
			_loader.addEventListener( Event.COMPLETE, onLoadComplete );
			_loader.addEventListener( HTTPStatusEvent.HTTP_STATUS, onLoadHttpStatus );
			_loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onLoadSecurityError );
			_loader.addEventListener( IOErrorEvent.IO_ERROR, onLoadIOError );
		}

		/**
		 * @private
		 */
		private function onLoadComplete( event:Event ):void
		{
			_xml = new XML( event.target.data );

			complete();
		}

		/**
		 * @private
		 */
		private function onLoadHttpStatus( event:HTTPStatusEvent ):void
		{
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

			_loader.removeEventListener( Event.COMPLETE, onLoadComplete );
			_loader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onLoadSecurityError );
			_loader.removeEventListener( HTTPStatusEvent.HTTP_STATUS, onLoadHttpStatus );
			_loader.removeEventListener( IOErrorEvent.IO_ERROR, onLoadIOError );
			_loader = null;

			_xml = null;
		}

		/**
		 * The loaded xml definition. Will be null if the xml definition is not loaded yet.
		 */
		public function get xml():XML
		{
			return _xml;
		}

		/**
		 * The url of the xml definition to load.
		 */
		public function get url():String
		{
			return _url;
		}

		override public function toString():String
		{
			return "[UIXmlLoader]";
		}
	}
}