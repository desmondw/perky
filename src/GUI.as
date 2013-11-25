package  
{
	import org.flixel.*;
	
	public class GUI 
	{
		private static const TEXT_HEIGHT:uint = 36;
		
		//group
		public static var group:FlxGroup;
		
		//always shown
		private static var kills:FlxText;
		private static var levelIn:FlxText;
		private static var level:FlxText;
		
		//level up
		private static var perkText:FlxText;
		private static var perk1:FlxText;
		private static var perk2:FlxText;
		private static var perk3:FlxText;
		
		public static function create():void 
		{
			group = new FlxGroup();
			
			kills = new FlxText(0, -4, Game.SCREEN_WIDTH, "Kills: " + Player.killCount);
			kills.size = 32;
			
			levelIn = new FlxText(0, -4, Game.SCREEN_WIDTH, "Level in: " + Player.killsToLevel);
			levelIn.size = 32;
			levelIn.x = Game.SCREEN_WIDTH - levelIn.text.length * 19;
			
			level = new FlxText(0, Game.SCREEN_HEIGHT - 36, Game.SCREEN_WIDTH, "Level: " + Player.level);
			level.size = 32;
			
			perkText = new FlxText(0, TEXT_HEIGHT * 2, Game.SCREEN_WIDTH, "PERK?!");
			perkText.size = 32;
			perkText.visible = false;
			
			perk1 = new FlxText(0, TEXT_HEIGHT * 3, Game.SCREEN_WIDTH, "1: ");
			perk1.size = 32;
			perk1.visible = false;
			
			perk2 = new FlxText(0, TEXT_HEIGHT * 4, Game.SCREEN_WIDTH, "2: ");
			perk2.size = 32;
			perk2.visible = false;
			
			perk3 = new FlxText(0, TEXT_HEIGHT * 5, Game.SCREEN_WIDTH, "3: ");
			perk3.size = 32;
			perk3.visible = false;
			
			group.add(kills);
			group.add(levelIn);
			group.add(level);
			group.add(perkText);
			group.add(perk1);
			group.add(perk2);
			group.add(perk3);
		}
		
		public static function update():void 
		{
			kills.text = "Kills: " + Player.killCount;
			levelIn.text = "Level in: " + Player.killsToLevel;
			levelIn.x = Game.SCREEN_WIDTH - levelIn.text.length * 19;
			level.text = "Level: " + Player.level;
		}
		
		public static function showPerks(perk1:String, perk2:String, perk3:String):void 
		{
			PlayState.paused = true;
			Gameplay.enemySpawnTimer.stop();
			perkText.visible = true;
			
			GUI.perk1.text = "1: " + perk1;
			GUI.perk1.visible = true;
			
			GUI.perk2.text = "2: " + perk2;
			GUI.perk2.visible = true;
			
			GUI.perk3.text = "3: " + perk3;
			GUI.perk3.visible = true;
		}
		
		public static function hidePerks():void
		{
			PlayState.paused = false;
			Gameplay.enemySpawnTimer.start();
			
			perkText.visible = false;
			perk1.visible = false;
			perk2.visible = false;
			perk3.visible = false;
		}
	}
}