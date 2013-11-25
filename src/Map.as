package  
{
	import org.flixel.*;
	import flash.display.BitmapData;
	
	public class Map extends FlxTilemap
	{
		private static const TILES_COLOR_CODE:Array = [0xffffff, 0x000000];
		
		public function Map() 
		{
			super();
			
			var pixels:BitmapData = new FlxSprite(0, 0, Assets.map).pixels;
			var worldString:String = FlxTilemap.bitmapToCSV(pixels, false, 1, TILES_COLOR_CODE);
			loadMap(worldString, Assets.tiles, 32, 32, OFF, 0, 1, 1);
		}
	}
}