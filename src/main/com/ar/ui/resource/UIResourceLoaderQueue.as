package com.ar.ui.resource
{
	import com.ar.core.error.ElementAlreadyExistsError;
	import com.ar.core.error.ElementDoesNotExistError;
	import com.ar.core.job.IJob;
	import com.ar.core.job.IJobObserver;
	import com.ar.core.job.JobQueue;
	import com.ar.core.utils.IDisposable;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class UIResourceLoaderQueue implements IJobObserver, IDisposable
	{
		private var _observer:Vector.<IUIResourceLoaderQueueObserver>;

		private var _queue:JobQueue;

		/**
		 * Creates a new instance of UIResourceLoaderQueue.
		 */
		public function UIResourceLoaderQueue()
		{
			_observer = new Vector.<IUIResourceLoaderQueueObserver>();

			_queue = new JobQueue();
			_queue.addObserver( this );
		}

		/**
		 * Frees all internal references of the object.
		 */
		public function dispose():void
		{
			_observer.splice( 0, _observer.length );
			_observer = null;

			_queue.dispose();
			_queue = null;
		}

		/**
		 *
		 */
		public function addObserver( observer:IUIResourceLoaderQueueObserver ):void
		{
			if( hasObserver( observer ) )
			{
				throw new ElementAlreadyExistsError();
			}

			_observer.unshift( observer );
		}

		/**
		 *
		 */
		public function removeObserver( observer:IUIResourceLoaderQueueObserver ):void
		{
			if( !hasObserver( observer ) )
			{
				throw new ElementDoesNotExistError();
			}

			const index:int = _observer.indexOf( observer );

			_observer.splice( index, 1 );
		}

		/**
		 *
		 */
		public function hasObserver( observer:IUIResourceLoaderQueueObserver ):Boolean
		{
			return ( -1 != _observer.indexOf( observer ) );
		}

		/**
		 *
		 */
		public function add( loader:IUIResourceLoader ):void
		{
			_queue.addJob( loader );
		}

		/**
		 *
		 */
		public function remove( loader:IUIResourceLoader ):void
		{
			_queue.removeJob( loader );
		}

		/**
		 *
		 */
		public function clear():void
		{
			_queue.removeJobs();
		}

		/**
		 *
		 */
		public function load():void
		{
			_queue.start();
		}

		/**
		 *
		 */
		public function onJobProgress( job:IJob, progress:Number ):void
		{
		}

		/**
		 *
		 */
		public function onJobCompleted( job:IJob ):void
		{
			_queue.removeJobs();

			var n:int = _observer.length;

			while( --n > -1 )
			{
				_observer[n].onResourceLoadingSuccess();
			}
		}

		/**
		 *
		 */
		public function onJobCancelled( job:IJob ):void
		{
			throw new Error( "UIResourceLoaderQueue: Font loader in loading queue was cancelled." );
		}

		/**
		 *
		 */
		public function onJobFailed( job:IJob, error:Error ):void
		{
			var n:int = _observer.length;

			while( --n > -1 )
			{
				_observer[n].onResourceLoadingFailure( error );
			}
		}

		/**
		 * Creates and returns a string representation of the UIResourceLoaderQueue object.
		 */
		public function toString():String
		{
			return "[UIResourceLoaderQueue]";
		}
	}
}