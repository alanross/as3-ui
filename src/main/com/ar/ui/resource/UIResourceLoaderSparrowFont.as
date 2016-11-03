package com.ar.ui.resource
{
	import com.ar.core.error.NullError;
	import com.ar.core.error.SyncError;
	import com.ar.core.job.IJob;
	import com.ar.core.job.IJobObserver;
	import com.ar.core.job.Job;
	import com.ar.core.job.JobQueue;
	import com.ar.core.log.Context;
	import com.ar.core.log.Log;
	import com.ar.ui.text.font.UIFont;
	import com.ar.ui.text.font.UIFontManager;
	import com.ar.ui.text.font.glyph.UIGlyph;
	import com.ar.ui.text.font.glyph.UIKerningPair;

	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public class UIResourceLoaderSparrowFont extends Job implements IUIResourceLoader, IJobObserver
	{
		private var _texLoader:UILoadTexJob;
		private var _xmlLoader:UILoadXmlJob;
		private var _loadQueue:JobQueue;
		private var _id:String;

		public function UIResourceLoaderSparrowFont( fontTextureUrl:String, fontXmlUrl:String, id:String )
		{
			_id = id;
			_texLoader = new UILoadTexJob( fontTextureUrl );
			_xmlLoader = new UILoadXmlJob( fontXmlUrl );

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

		/**
		 * @private
		 */
		private function createFont( bmd:BitmapData, xml:XML ):UIFont
		{
			var common:XMLList = xml.common;
			var info:XMLList = xml.info;
			var glyphs:XMLList = xml.chars;
			var kernings:XMLList = xml.kernings;

			// var face:String = info.getAttribute( "fontId" );
			var face:String = info.@face;
			var bold:Boolean = ( info.@bold != "0" );
			var italic:Boolean = ( info.@italic != "0" );
			var size:int = parseInt( info.@size );

			var lineHeight:int = parseInt( common.@lineHeight );
			var base:int = parseInt( common.@base );

			var font:UIFont = new UIFont( bmd, _id, face, size, bold, italic, lineHeight );

			glyphs = glyphs.descendants();

			kernings = kernings.descendants();

			var n:int = glyphs.length();

			while( --n > -1 )
			{
				font.addGlyph( createGlyph( font, lineHeight, base, glyphs[n], kernings ) );
			}

			if( !font.hasGlyphWithCode( 10 ) ) // new-line character
			{
				font.addGlyph( createNewLineGlyph( font ) );
			}

			return font;
		}

		/**
		 * @private
		 */
		private function createGlyph( font:UIFont, lineHeight:int, base:int, glyph:XML, kernings:XMLList ):UIGlyph
		{
			var id:String = glyph.@id;

			var code:int = parseInt( id );

			var kerningPairs:Vector.<UIKerningPair> = createKerningPairs( kernings.(@first == id) );

			var xAdvance:int = parseInt( glyph.@xadvance );

			var offset:Point = new Point( parseInt( glyph.@xoffset ), parseInt( glyph.@yoffset ) );

			var sourceRect:Rectangle = new Rectangle(
					parseInt( glyph.@x ),
					parseInt( glyph.@y ),
					parseInt( glyph.@width ),
					parseInt( glyph.@height )
			);

			// non-white space characters
			if( sourceRect.width > 0 && sourceRect.height > 0 )
			{
				sourceRect.y -= 2;
				sourceRect.width += 1;
				sourceRect.height += 1;
			}

			var bounds:Rectangle = new Rectangle( 0, 0, sourceRect.width, sourceRect.height );

			return new UIGlyph( font, code, sourceRect, bounds, offset, xAdvance, lineHeight, base, kerningPairs );
		}

		/**
		 * @private
		 */
		private function createNewLineGlyph( font:UIFont ):UIGlyph
		{
			// try an create a new line character by using the info from the space character

			if( !font.hasGlyphWithChar( " " ) ) // new-line character
			{
				throw new NullError( this + " No space character present in the font atlas." );
			}

			var glyph:UIGlyph = font.getGlyphWithChar( ' ' );

			var code:int = UIGlyph.NEW_LINE;
			var xAdvance:int = 0;
			var offset:Point = new Point();
			var lineHeight:int = glyph.lineHeight;
			var base:int = glyph.base;
			var sourceRect:Rectangle = new Rectangle();
			var bounds:Rectangle = new Rectangle();
			var kerningPairs:Vector.<UIKerningPair> = new Vector.<UIKerningPair>();

			return new UIGlyph( font, code, sourceRect, bounds, offset, xAdvance, lineHeight, base, kerningPairs );
		}

		/**
		 * @private
		 */
		private function createKerningPairs( data:XMLList ):Vector.<UIKerningPair>
		{
			var result:Vector.<UIKerningPair> = new Vector.<UIKerningPair>();

			var n:int = data.length();

			while( --n > -1 )
			{
				var pair:XML = data[n];

				result.push( new UIKerningPair(
						parseInt( pair.@first ),
						parseInt( pair.@second ),
						parseInt( pair.@amount ) )
				);
			}

			return result;
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
			UIFontManager.get().addFont( createFont( _texLoader.bitmapData, _xmlLoader.xml ) );

			Log.trace( Context.UI, "Completed loading Font: " + _texLoader.url + " | " + _xmlLoader.url );

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
			return "[UIResourceLoaderSparrowFont]";
		}
	}
}