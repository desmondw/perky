package  
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.flixel.*;
	
	public class Gameplay 
	{
		//constants
		private const PLAYER_SPAWN:FlxPoint = new FlxPoint(304, 256);
		private const ENEMY_SPAWN:FlxPoint = new FlxPoint(Game.SCREEN_WIDTH / 2 - 16, 0);
		
		//entities
		public var player:Player;
		private var enemies:Array = new Array();
		
		//map
		private var map:Map;
		
		//groups
		public var group:FlxGroup = new FlxGroup();
		public var grp_enemies:FlxGroup = new FlxGroup();
		
		//status
		public var gameOver:Boolean = false;
		public static var enemySpawnTimer:Timer;
		public static var enemySpawnDelay:uint = 500; //in ms
		
		public function Gameplay() 
		{
			//map
			map = new Map();
			
			//player
			player = new Player(PLAYER_SPAWN.x, PLAYER_SPAWN.y);
			player.initializeWeapon(map.getBounds());
			
			//enemy timer and first spawn
			enemySpawnTimer = new Timer(enemySpawnDelay);
			enemySpawnTimer.addEventListener(TimerEvent.TIMER, spawnEnemy);
			enemySpawnTimer.start();
			spawnEnemy(new TimerEvent("dummy"));
			
			//groups
			group.add(map);
			group.add(grp_enemies);
			group.add(player);
			group.add(player.grp_bullets);
			group.add(GUI.group);
		}
		
		public function update():void 
		{
			//update player
			player.update();
			
			//update enemy timer
			if (enemySpawnTimer.currentCount > 100)
			{
				enemySpawnTimer.reset();
				enemySpawnTimer.start();
				enemySpawnTimer.delay /= 2;
			}
			
			//update enemies
			for (var i:int = 0; i < enemies.length; i++)
				enemies[i].update();
			
			//check for collisions
			detectCollisions();
		}
		
		private function spawnEnemy(event:TimerEvent):void 
		{
			var facing:int;
			
			if (FlxG.random() < .5)
				facing = FlxObject.LEFT;
			else
				facing = FlxObject.RIGHT;
			
			enemies.push(new Enemy(ENEMY_SPAWN.x, ENEMY_SPAWN.y, facing));
			grp_enemies.add(enemies[enemies.length-1]);
		}
		
		private function detectCollisions():void 
		{
			if (!player.perks[player.NO_CLIPPING])
				FlxG.collide(map, player);
			FlxG.collide(map, grp_enemies);
			FlxG.collide(map, player.grp_bullets, bulletHitWall);
			FlxG.overlap(grp_enemies, player.grp_bullets, bulletHitEnemy);
			
			if (player.perks[player.COLLIDE_ENEMIES])
				FlxG.collide(grp_enemies, grp_enemies);
			
			//if player touches enemy or goes off map, set game over flag
			if (FlxG.overlap(player, grp_enemies) || !FlxG.overlap(map, player) || FlxG.overlap(PlayState.belowMap, grp_enemies))
				gameOver = true;
			
			//if enemy falls off map, add 3 kills to required to level
			//FlxG.overlap(PlayState.belowMap, grp_enemies, enemyFallOffMap)
		}
		
		private function bulletHitWall(map:FlxObject, bullet:FlxObject):void 
		{
			bullet.kill();
		}
		
		private function bulletHitEnemy(enemy:FlxObject, bullet:FlxObject):void 
		{
			enemy.kill();
			
			if (!player.perks[player.BULLET_PASS_THROUGH])
				bullet.kill();
			
			Player.killCount++;
			
			if (player.perks[player.DOUBLE_XP])
				Player.killsToLevel -= 2;
			else
				Player.killsToLevel--;
			
			if (Player.killsToLevel <= 0)
				player.levelUp();
		}
		
		private function enemyFallOffMap(belowMap:FlxObject, enemy:FlxObject):void 
		{
			enemy.kill();
			
			Player.killsToLevel += 3;
		}
	}
}