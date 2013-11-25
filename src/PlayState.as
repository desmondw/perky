package  
{
	import org.flixel.*;
	import flash.ui.Mouse;
	
	public class PlayState extends FlxState
	{
		public static var belowMap:FlxObject = new FlxObject(0, Game.SCREEN_HEIGHT, Game.SCREEN_WIDTH, Game.SCREEN_HEIGHT * 2);
		
		//classes
		public var gameplay:Gameplay;
		
		//group
		private var group:FlxGroup = new FlxGroup();
		
		//status
		public static var paused:Boolean = false;
		public static var gameOver:Boolean = false;
		public static var gameWon:Boolean = false;
		
		public function PlayState() 
		{
		}
		
		override public function create():void 
		{
			//TODO: disable debug for release
			//FlxG.debug = true;
			//FlxG.visualDebug = true;
			
			FlxG.fade(0xffffffff, 1);
			
			//flixel initialization
			FlxG.bgColor = Game.BG_COLOR;
			FlxG.flashFramerate = 60;
			
			//initialize classes
			gameplay = new Gameplay();
			GUI.create();
			
			//groups
			group.add(gameplay.group);
			group.add(GUI.group);
			add(group);
		}
		
		override public function update():void 
		{
			if (gameWon)
				FlxG.fade(0xffffffff, 1, winState);
			else if (gameOver)
				FlxG.fade(0xffffffff, 1, playState);
			else if (paused)
			{
				if (FlxG.keys.justPressed("ONE"))
				{
					gameplay.player.choosePerk(0);
					GUI.hidePerks();
				}
				else if (FlxG.keys.justPressed("TWO"))
				{
					gameplay.player.choosePerk(1);
					GUI.hidePerks();
				}
				else if (FlxG.keys.justPressed("THREE"))
				{
					gameplay.player.choosePerk(2);
					GUI.hidePerks();
				}
			}
			else
			{
				super.update();
				Mouse.show();
				
				gameplay.update();
				GUI.update();
				
				if (gameplay.gameOver)
				{
					gameplay = new Gameplay();
					
					remove(group);
					group = new FlxGroup();
					group.add(gameplay.group);
					group.add(GUI.group);
					add(group);
				}
			}
		}
		
		private function playState():void 
		{
			Player.level = 1;
			Player.killCount = 0;
			Player.killsToLevel = 10;
			Enemy.maxVelocityX = 96;
			GUI.update();
			Gameplay.enemySpawnTimer.stop();
			Gameplay.enemySpawnTimer.reset();
			Gameplay.enemySpawnTimer.delay = Gameplay.enemySpawnDelay;
			FlxG.switchState(new PlayState());
		}
		
		private function winState():void 
		{
			Player.level = 1;
			Player.killCount = 0;
			Player.killsToLevel = 10;
			Enemy.maxVelocityX = 96;
			GUI.update();
			Gameplay.enemySpawnTimer.stop();
			Gameplay.enemySpawnTimer.reset();
			Gameplay.enemySpawnTimer.delay = Gameplay.enemySpawnDelay;
			FlxG.switchState(new WinState());
		}
	}
}