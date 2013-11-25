package  
{
	public class Assets 
	{
		[Embed(source = "../bin/assets/titleScreen.png")] public static var titleScreen:Class;
		[Embed(source = "../bin/assets/winScreen.png")] public static var winScreen:Class;
		
		[Embed(source = "../bin/assets/map.png")] public static var map:Class;
		[Embed(source = "../bin/assets/tiles.png")] public static var tiles:Class;
		
		[Embed(source = "../bin/assets/player.png")] public static var player:Class;
		[Embed(source = "../bin/assets/bulletRight.png")] public static var bulletRight:Class;
		[Embed(source = "../bin/assets/bulletLeft.png")] public static var bulletLeft:Class;
		
		[Embed(source = "../bin/assets/enemy.png")] public static var enemy:Class;
		
		//player sounds
		//[Embed(source = "../bin/assets/player_hit.mp3")] public static var player_hit:Class;
	}
}