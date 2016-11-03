package com.ar.ui.resource
{
	import com.ar.core.error.SyncError;
	import com.ar.core.job.IJob;
	import com.ar.core.job.IJobObserver;
	import com.ar.core.job.Job;
	import com.ar.core.job.JobQueue;
	import com.ar.core.log.Context;
	import com.ar.core.log.Log;
	import com.ar.ui.texture.UITextureAtlas;
	import com.ar.ui.texture.UITextureManager;
	import com.ar.ui.utils.bitmap.UISlice9Grid;

	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public class UIResourceLoaderTexturePacker extends Job implements IUIResourceLoader, IJobObserver
	{
		private var _texLoader:UILoadTexJob;
		private var _xmlLoader:UILoadXmlJob;
		private var _loadQueue:JobQueue;
		private var _id:String;

		public function UIResourceLoaderTexturePacker( skinTextureUrl:String, skinXmlUrl:String, id:String )
		{
			_id = id;
			_texLoader = new UILoadTexJob( skinTextureUrl );
			_xmlLoader = new UILoadXmlJob( skinXmlUrl );

			_loadQueue = new JobQueue();
			_loadQueue.addJob( _texLoader );
			_loadQueue.addJob( _xmlLoader );
			_loadQueue.addObserver( this );
		}

		private function clear():void
		{
			_loadQueue.removeJob( _texLoader );
			_loadQueue.removeJob( _xmlLoader );

			_texLoader.dispose();
			_texLoader = null;

			_xmlLoader.dispose();
			_xmlLoader = null;
		}

		private function createTextureAtlas( textureData:BitmapData, xml:XML ):UITextureAtlas
		{
			var sprites:XMLList = xml.sprite;

			var atlas:UITextureAtlas = new UITextureAtlas( textureData, _id );

			var n:int = sprites.length();

			while( --n > -1 )
			{
				createTexture( atlas, sprites[n] );
			}

			return atlas;
		}

		private function createTexture( atlas:UITextureAtlas, sprite:XML ):void
		{
			var id:String = sprite.@n;

			var left:int = parseInt( sprite.@left );
			var right:int = parseInt( sprite.@right );
			var top:int = parseInt( sprite.@top );
			var bottom:int = parseInt( sprite.@bottom );

			var rect:Rectangle = new Rectangle(
					parseInt( sprite.@x ),
					parseInt( sprite.@y ),
					parseInt( sprite.@w ),
					parseInt( sprite.@h ) );

			if( left > 0 || right > 0 || top > 0 || bottom > 0 )
			{
				atlas.addTextureFromData( id, rect, new UISlice9Grid( left, right, top, bottom ) );
			}
			else
			{
				atlas.addTextureFromData( id, rect );
			}
		}

		override public function dispose():void
		{
			super.dispose();

			clear();

			_loadQueue.dispose();
			_loadQueue = null;
		}

		override protected function onStart():void
		{
			if( _loadQueue.isRunning() )
			{
				throw new SyncError( this + " is already running" );
			}

			_loadQueue.start();
		}

		override protected function onCancel():void
		{
			if( _loadQueue.isRunning() )
			{
				_loadQueue.cancel();
			}

			clear();
		}

		override protected function onComplete():void
		{
			clear();
		}

		override protected function onFail():void
		{
			clear();
		}

		public function onJobProgress( job:IJob, progress:Number ):void
		{
		}

		public function onJobCompleted( job:IJob ):void
		{
			UITextureManager.get().addAtlas( createTextureAtlas( _texLoader.bitmapData, _xmlLoader.xml ) );

			Log.trace( Context.UI, "Completed loading TextureAtlas: " + _texLoader.url + " | " + _xmlLoader.url );

			complete();
		}

		public function onJobCancelled( job:IJob ):void
		{
		}

		public function onJobFailed( job:IJob, error:Error ):void
		{
			fail( error );
		}

		override public function toString():String
		{
			return "[UIResourceLoaderTexturePacker]";
		}
	}
}