package com.ar.ui.tile
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Alan Ross
	 * @version 0.1
	 */
	public final class TileMapIsoRenderer implements ITileRenderer
	{
		private const spriteRect:Rectangle = new Rectangle();
		private const spriteOffset:Point = new Point( 0, 0 );
		private var _output:BitmapData;
		private var _tileSprites:BitmapData;
		private var _tileMap:Array;
		private var _spriteWidth:int;
		private var _spriteHeight:int;
		private var _mapMaxRows:int;
		private var _mapMaxCols:int;
		private var _outMaxRows:int;
		private var _outMaxCols:int;
		private var _numSpritesCol:int;
		private var _numSpritesRow:int;

		private var _isometricTileHeight:int;

		public function TileMapIsoRenderer( output:BitmapData, tileSprites:BitmapData, tileMap:Array, spriteWidth:int, spriteHeight:int, isometricTileHeight:int )
		{
			_output = output;
			_tileSprites = tileSprites;
			_tileMap = tileMap;

			_isometricTileHeight = isometricTileHeight;

			_numSpritesCol = int( tileSprites.width / spriteWidth );
			_numSpritesRow = int( tileSprites.height / spriteHeight );

			spriteRect.width = _spriteWidth = spriteWidth;
			spriteRect.height = _spriteHeight = spriteHeight;

			_mapMaxRows = _tileMap.length;
			_mapMaxCols = _tileMap[0].length;

			_outMaxRows = int( _output.height / _isometricTileHeight ) + 4;
			_outMaxCols = int( _output.width / _spriteWidth ) + 4;
		}

		public function render( offsetX:int, offsetY:int )
		{
			var mapColOffset:int = int( offsetX / _spriteWidth );
			var mapRowOffset:int = int( offsetY / _isometricTileHeight );

			var restX:int = offsetX % _spriteWidth;
			var restY:int = offsetY % _isometricTileHeight;

			_output.fillRect( _output.rect, 0 );

			for( var i:int = 0; i < _outMaxRows; ++i )
			{
				var mapRowIndex:int = mapRowOffset + i;

				spriteOffset.y = ( i * _isometricTileHeight ) - restY;
				spriteOffset.y -= _spriteHeight;

				for( var j:int = 0; j < _outMaxCols; ++j )
				{
					var mapColIndex:int = mapColOffset + j;

					if( mapRowIndex < 0 || mapRowIndex >= _mapMaxRows || mapColIndex < 0 || mapColIndex >= _mapMaxCols )
					{
						continue;
					}

					spriteOffset.x = ( j * _spriteWidth ) - restX;

					if( mapRowIndex % 2 == 0 )
					{
						spriteOffset.x -= _spriteWidth / 2;
					}

					var val:int = _tileMap[ mapRowIndex ][ mapColIndex ];

					spriteRect.x = int( val % _numSpritesCol ) * _spriteWidth;
					spriteRect.y = int( val / _numSpritesCol ) * _spriteHeight;

					_output.copyPixels( _tileSprites, spriteRect, spriteOffset );
				}
			}
		}

		public function toString():String
		{
			return "[TileMapIsoRenderer]";
		}
	}
}