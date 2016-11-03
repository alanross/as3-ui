package com.ar.ui.text
{
	import com.ar.core.error.OutOfBoundsError;
	import com.ar.core.utils.IDisposable;
	import com.ar.ui.text.font.UIFont;
	import com.ar.ui.text.font.UIFontManager;
	import com.ar.ui.text.font.glyph.UIGlyph;
	import com.ar.ui.text.processing.IUITextComposer;
	import com.ar.ui.text.processing.UITextComposerMultiLine;
	import com.ar.ui.text.processing.UITextComposerSingleLine;
	import com.ar.ui.text.processing.UITextInteractor;
	import com.ar.ui.text.processing.UITextLayout;
	import com.ar.ui.text.processing.UITextRenderer;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class UITextProcessor implements IDisposable
	{
		private var _glyphs:Vector.<UIGlyph> = new Vector.<UIGlyph>();
		private var _ellipsis:Vector.<UIGlyph> = new Vector.<UIGlyph>();

		private var _text:String = new String();

		private var _composer:IUITextComposer;
		private var _renderer:UITextRenderer;
		private var _interact:UITextInteractor;
		private var _format:UITextFormat;
		private var _font:UIFont;
		private var _block:UITextLayout;

		public static function create( format:UITextFormat, renderer:UITextRenderer, singleLine:Boolean ):UITextProcessor
		{
			var composer:IUITextComposer = ( singleLine ) ? new UITextComposerSingleLine() : new UITextComposerMultiLine();

			var interactor:UITextInteractor = new UITextInteractor();

			return new UITextProcessor( composer, renderer, interactor, format );
		}

		public function UITextProcessor( composer:IUITextComposer, renderer:UITextRenderer, interact:UITextInteractor, format:UITextFormat ):void
		{
			_composer = composer;
			_renderer = renderer;
			_interact = interact;

			setFormat( format );
		}

		public function setFormat( value:UITextFormat ):void
		{
			_format = value.clone();

			_font = UIFontManager.get().getFont( _format.fontId );

			var glyph:UIGlyph = _font.getGlyphWithChar( "." );

			_ellipsis = new <UIGlyph>[ glyph.clone(), glyph.clone(), glyph.clone() ];
		}

		public function setText( value:String ):void
		{
			value = value.replace( RegExp( /[\a\e\t]/gm ), ' ' );

			if( _composer is UITextComposerSingleLine )
			{
				value = value.replace( RegExp( /[\f\r\v]/gm ), ' ' );
			}
			else
			{
				value = value.replace( RegExp( /[\f\r\v]/gm ), '\n' );
			}

			_text = value;

			_glyphs.splice( 0, _glyphs.length );

			const n:int = value.length;

			for( var i:int = 0; i < n; ++i )
			{
				_glyphs.push( _font.getGlyphWithChar( value.charAt( i ) ).clone() );
			}
		}

		public function render( maxWidth:int = int.MAX_VALUE, maxHeight:int = int.MAX_VALUE ):void
		{
			if( maxWidth < 0 || maxHeight < 0 )
			{
				return;
			}

			var size:Rectangle = new Rectangle( 0, 0, maxWidth, maxHeight );

			_block = _composer.process( _glyphs.concat(), _ellipsis, _font, _format, size );

			_renderer.process( _block, _format );
		}

		public function dispose():void
		{
			_glyphs = null;
			_text = null;
			_block = null;

			_renderer = null;
			_composer = null;
			_interact = null;
		}

		public function getGlyphUnderPoint( point:Point ):UIGlyph
		{
			return _interact.getGlyphUnderPoint( _glyphs, point );
		}

		public function getWordUnderPoint( point:Point, selection:UITextSelection ):void
		{
			return _interact.getWordUnderPoint( _glyphs, point, selection );
		}

		public function getCursorIndex( point:Point ):int
		{
			return _interact.getCursorIndexForPoint( _glyphs, point );
		}

		public function getGlyphAt( index:int ):UIGlyph
		{
			if( index < 0 || index >= _glyphs.length )
			{
				throw new OutOfBoundsError( index, 0, _glyphs.length );
			}

			return _glyphs[index];
		}

		public function get text():String
		{
			return _text;
		}

		public function get textWidth():int
		{
			return ( _block != null ) ? _block.bounds.width : 0;
		}

		public function get textHeight():int
		{
			return ( _block != null ) ? _block.bounds.height : 0;
		}

		public function toString():String
		{
			return "[UITextProcessor]";
		}
	}
}