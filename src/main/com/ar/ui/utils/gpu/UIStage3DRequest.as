package com.ar.ui.utils.gpu
{
	import com.ar.core.error.ElementAlreadyExistsError;
	import com.ar.core.error.ElementDoesNotExistError;
	import com.ar.core.log.Context;
	import com.ar.core.log.Log;
	import com.ar.core.utils.IDisposable;

	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DRenderMode;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.system.ApplicationDomain;

	/**
	 * Requests GPU support and notifies observers of the result.
	 *
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class UIStage3DRequest implements IDisposable
	{
		private var _stage:Stage;

		private var _stage3D:Stage3D;

		private var _observer:Vector.<IUIStage3DRequestObserver>;

		/**
		 * Creates a new instance of UIContext3DRequest.
		 */
		public function UIStage3DRequest()
		{
			_observer = new Vector.<IUIStage3DRequestObserver>();
		}

		/**
		 * Add an observer to be notified if stage3d is supported when requested.
		 */
		public function addObserver( observer:IUIStage3DRequestObserver ):void
		{
			if( hasObserver( observer ) )
			{
				throw new ElementAlreadyExistsError();
			}

			_observer.unshift( observer );
		}

		/**
		 * Remove an observer from being notified if stage3d is supported when requested.
		 */
		public function removeObserver( observer:IUIStage3DRequestObserver ):void
		{
			if( !hasObserver( observer ) )
			{
				throw new ElementDoesNotExistError();
			}

			const index:int = _observer.indexOf( observer );

			_observer.splice( index, 1 );
		}

		/**
		 * Returns true of given observer is in the list of observers, false otherwise.
		 */
		public function hasObserver( observer:IUIStage3DRequestObserver ):Boolean
		{
			const index:int = _observer.indexOf( observer );

			return ( -1 != index );
		}

		/**
		 * Frees all internal references of the object.
		 */
		public function dispose():void
		{
			_observer.splice( 0, _observer.length );
			_observer = null;

			_observer = null;
			_stage3D = null;
		}

		/**
		 * Request Stage3D and Context3D support.
		 */
		public function getStage3D( stage:Stage, depth:int = 0, observer:IUIStage3DRequestObserver = null ):void
		{
			_stage = stage;

			if( observer != null )
			{
				addObserver( observer );
			}

			// check if running Flash 11 with Stage3D available
			if( ApplicationDomain.currentDomain.hasDefinition( "flash.display.Stage3D" ) )
			{
				_stage3D = stage.stage3Ds[depth];

				// Add event listener before requesting the context
				_stage3D.addEventListener( Event.CONTEXT3D_CREATE, onContext3DCreate );

				// This error is fired if the swf is not using wmode=direct
				_stage3D.addEventListener( ErrorEvent.ERROR, onContext3DCreateError );

				// Request hardware 3d mode
				_stage3D.requestContext3D( Context3DRenderMode.AUTO );
			}
			else
			{
				Log.trace( Context.UI, "No 3D context available" );

				dispatchContext3DFailed( _stage );
			}
		}

		/**
		 *
		 */
		private function onContext3DCreate( event:Event ):void
		{
			_stage3D.removeEventListener( Event.CONTEXT3D_CREATE, onContext3DCreate );
			_stage3D.removeEventListener( ErrorEvent.ERROR, onContext3DCreateError );

			// Remove existing frame handler. Note that a context
			// loss can occur at any time which will force you
			// to recreate all objects we create here.
			// A context loss occurs for instance if you hit
			// CTRL-ALT-DELETE on Windows.
			// It takes a while before a new context is available
			// hence removing the enterFrame handler is important!

			var context3D:Context3D = _stage3D.context3D;

			if( context3D != null )
			{
				var driverInfo:String = context3D.driverInfo;

				// detect software mode (html might not have wmode=direct)
				if( driverInfo == Context3DRenderMode.SOFTWARE || driverInfo.toLowerCase().indexOf( "software" ) > -1 )
				{
					Log.trace( Context.UI, "No 3D context available: Software mode detected" );

					dispatchContext3DFailed( _stage );
				}
				else
				{
					Log.trace( Context.UI, "3D context available:", driverInfo );

					// Disabling error checking will drastically improve performance.
					// If set to true, Flash sends helpful error messages regarding
					// AGAL compilation errors, uninitialized program constants, etc.
					context3D.enableErrorChecking = false;

					dispatchContext3DSuccess( _stage3D );
				}
			}
			else
			{
				Log.trace( Context.UI, "No 3D context available: Video driver issue?" );

				dispatchContext3DFailed( _stage );
			}
		}

		/**
		 *
		 */
		private function onContext3DCreateError( event:ErrorEvent ):void
		{
			_stage3D.removeEventListener( Event.CONTEXT3D_CREATE, onContext3DCreate );
			_stage3D.removeEventListener( ErrorEvent.ERROR, onContext3DCreateError );

			Log.trace( Context.UI, "No 3D context available: " +
					"If SWF: Is embed wmode=direct set? " +
					"If AIR: Is renderMode=direct in the application descriptor set?" +
					event.text );

			dispatchContext3DFailed( _stage );
		}

		/**
		 *
		 */
		private function dispatchContext3DFailed( stage:Stage ):void
		{
			var n:int = _observer.length;

			while( --n > -1 )
			{
				_observer[n].onStage3DUnavailable( stage );
			}
		}

		/**
		 *
		 */
		private function dispatchContext3DSuccess( stage3d:Stage3D ):void
		{
			var n:int = _observer.length;

			while( --n > -1 )
			{
				_observer[n].onStage3DAvailable( stage3d );
			}
		}

		/**
		 * Generates and returns the string representation of the UIContext3DRequest object.
		 */
		public function toString():String
		{
			return "[UIStage3DRequest]";
		}
	}
}