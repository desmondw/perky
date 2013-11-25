package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxWeapon;
	
	public class Player extends FlxSprite
	{
		//perks
		public const NUM_PERKS:uint = 9;
		public const BULLET_PASS_THROUGH:uint = 0;
		public const FLY:uint = 1;
		public const DOUBLE_XP:uint = 2;
		public const DOUBLE_SPEED:uint = 3;
		public const DOUBLE_BULLET_SPEED:uint = 4;
		public const NO_CLIPPING:uint = 5;
		public const COLLIDE_ENEMIES:uint = 6;
		public const SLOW_ENEMIES:uint = 7;
		public const DOUBLE_FIRE_RATE:uint = 8;
		
		//movement constants
		private const MAX_X_VELOCITY_COEFFICIENT:Number = 5;
		private const MAX_Y_VELOCITY_COEFFICIENT:Number = 8;
		private const ACCELERATION_COEFFICIENT:Number = 4;
		private const ACCELERATION_JUMP_COEFFICIENT:Number = 1.3;
		private const ACCELERATION_FALL_COEFFICIENT:Number = 2;
		private const DRAG_COEFFICIENT:Number = 4;
		private const TURNAROUND_COEFFICIENT:Number = .65;
		
		//movement
		private var maxVelocityX:int;
		private var maxVelocityY:int;
		
		//weapons
		public var weaponRight:FlxWeapon;
		public var weaponLeft:FlxWeapon;
		
		//groups
		public var grp_bullets:FlxGroup = new FlxGroup();
		
		//perks
		public var perks:Array = new Array(NUM_PERKS);
		public var perksText:Array  = new Array(NUM_PERKS);
		public var perksAvailable:Array  = new Array(NUM_PERKS);
		public var perksDisplay:Array = new Array(3);
		
		//status
		public static var level:uint = 1;
		public static var killCount:uint = 0;
		public static var killsToLevel:int = 10;
		public var baseKillsToLevel:uint = 10;
		public var killsToLevelInterval:uint = 10;
		
		override public function Player(x:uint, y:uint)
		{
			super(x, y);
			
			//load graphics and animations
			loadGraphic(Assets.player, true, true, 32, 64);
			addAnimation("idle", new Array(0, 0), 4);
			//addAnimation("runLeft", new Array(1, 1), 4);
			//addAnimation("runRight", new Array(2, 2), 4);
			play("idle");
			
			initializePerks();
			
			//set movement physics
			maxVelocity.x = width * MAX_X_VELOCITY_COEFFICIENT;
			maxVelocity.y = height * MAX_Y_VELOCITY_COEFFICIENT;
			drag.x = maxVelocity.x * DRAG_COEFFICIENT;
			drag.y = maxVelocity.y * DRAG_COEFFICIENT;
			maxVelocityX = maxVelocity.x;
			maxVelocityY = maxVelocity.y;
		}
		
		public function initializeWeapon(bounds:FlxRect):void 
		{
			//right bullets
			weaponRight = new FlxWeapon("weaponRight", this, "x", "y");
			weaponRight.setFireRate(800);
			weaponRight.setBulletBounds(bounds);
			weaponRight.makeImageBullet(50, Assets.bulletRight, 0, 0);
			weaponRight.setBulletOffset(16 - weaponRight.bounds.width / 2, 22 - weaponRight.bounds.height / 2);
			weaponRight.setBulletDirection(FlxWeapon.BULLET_RIGHT, 100);
			
			//left bullets
			weaponLeft = new FlxWeapon("weaponLeft", this, "x", "y");
			weaponLeft.setFireRate(800);
			weaponLeft.setBulletBounds(bounds);
			weaponLeft.makeImageBullet(50, Assets.bulletLeft, 0, 0);
			weaponLeft.setBulletOffset(16 - weaponLeft.bounds.width / 2, 22 - weaponLeft.bounds.height / 2);
			weaponLeft.setBulletDirection(FlxWeapon.BULLET_LEFT, 100);
			
			grp_bullets.add(weaponLeft.group)
			grp_bullets.add(weaponRight.group);
		}
		
		public function initializePerks():void 
		{
			//set perks to not active
			for (var i:int = 0; i < perks.length; i++)
				perks[i] = false;
			
			//set perks available
			for (var i:int = 0; i < perksAvailable.length; i++)
				perksAvailable[i] = i;
				
			//perksAvailable = new Array(0);
			
			//set perk text
			perksText[DOUBLE_SPEED] = "dubs";
			perksText[DOUBLE_XP] = "Feeling perky?";
			perksText[FLY] = "OH SWEET JESUS YES";
			perksText[BULLET_PASS_THROUGH] = "Bad breath.";
			perksText[DOUBLE_BULLET_SPEED] = "Blow like a blonde!";
			perksText[NO_CLIPPING] = "sv_cheats 1; noclip";
			perksText[COLLIDE_ENEMIES] = "Bottlenecken'";
			perksText[SLOW_ENEMIES] = "Double Dip Recession!";
			perksText[DOUBLE_FIRE_RATE] = "The \"coughs\"";
		}
		
		override public function update():void 
		{
			super.update();
			
			updateMovement();
			if (facing == FlxObject.RIGHT)
				weaponRight.fire();
			else if (facing == FlxObject.LEFT)
				weaponLeft.fire();
		}
		
		private function updateMovement():void 
		{
			//update null values
			acceleration.x = 0;
			maxVelocity.x = maxVelocityX;
			maxVelocity.y = maxVelocityY;
			play("idle");
			
			//dont execute horizontal movement if player deadlocks it with both keys
			if (!(FlxG.keys.A && FlxG.keys.D) && !(FlxG.keys.LEFT && FlxG.keys.RIGHT))
			{
				if (FlxG.keys.A || FlxG.keys.LEFT)
					moveLeft();
				if (FlxG.keys.D || FlxG.keys.RIGHT)
					moveRight();
			}
			if ((FlxG.keys.W || FlxG.keys.UP) && perks[FLY])
				fly();
			else if ((FlxG.keys.W || FlxG.keys.UP) && isTouching(FLOOR))
				jump();
			else if (FlxG.keys.S || FlxG.keys.DOWN)
				fastFall();
			else
				fall();
		}
		
		public function moveLeft():void 
		{
			if (velocity.x > 0)
				velocity.x *= TURNAROUND_COEFFICIENT;
			acceleration.x = -maxVelocity.x * ACCELERATION_COEFFICIENT;
			//play("runLeft");
			facing = FlxObject.LEFT;
		}
		
		public function moveRight():void 
		{
			if (velocity.x < 0)
				velocity.x *= TURNAROUND_COEFFICIENT;
			acceleration.x = maxVelocity.x * ACCELERATION_COEFFICIENT;
			//play("runRight");
			facing = FlxObject.RIGHT;
		}
		
		public function fly():void 
		{
			acceleration.y = -maxVelocity.y * ACCELERATION_COEFFICIENT;
		}
		
		public function moveDown():void 
		{
			acceleration.y = maxVelocity.y * ACCELERATION_COEFFICIENT;
		}
		
		public function jump():void 
		{
			velocity.y = -maxVelocity.y * ACCELERATION_JUMP_COEFFICIENT;
		}
		
		public function fall():void 
		{
			acceleration.y = maxVelocity.y * ACCELERATION_FALL_COEFFICIENT;
		}
		
		public function fastFall():void 
		{
			acceleration.y = maxVelocity.y * ACCELERATION_FALL_COEFFICIENT * 4;
		}
		
		public function levelUp():void 
		{
			//leveling number changes
			level++;
			killsToLevelInterval *= 1.2;
			killsToLevel = baseKillsToLevel + killsToLevelInterval;
			displayPerks();
		}
		
		private function displayPerks():void 
		{
			//get random perks
			if (perksAvailable.length >= 3)
			{
				perksDisplay[0] = getRandomPerk(-1, -1); 
				perksDisplay[1] = getRandomPerk(perksDisplay[0], -1);
				perksDisplay[2] = getRandomPerk(perksDisplay[0], perksDisplay[1]);
				GUI.showPerks(perksText[perksDisplay[0]], perksText[perksDisplay[1]], perksText[perksDisplay[2]]);
			}
			else if (perksAvailable.length == 2)
			{
				perksDisplay[0] = getRandomPerk(-1, -1); 
				perksDisplay[1] = getRandomPerk(perksDisplay[0], -1);
				GUI.showPerks(perksText[perksDisplay[0]], perksText[perksDisplay[1]], "");
			}
			else if (perksAvailable.length == 1)
			{
				perksDisplay[0] = getRandomPerk(-1, -1);
				GUI.showPerks(perksText[perksDisplay[0]], "", "");
			}
			else
			{
				//WIN GAME PERK
				perksDisplay[0] = -1;
				GUI.showPerks("WIN GAME", "", "");
			}
		}
		
		private function getRandomPerk(firstPerk:int, secondPerk:int):int 
		{
			if (firstPerk < 0 && secondPerk < 0)
				return FlxU.getRandom(perksAvailable) as int;
			else if (secondPerk < 0)
			{
				var perk:int = firstPerk;
				while (perk == firstPerk)
					perk = FlxU.getRandom(perksAvailable) as int;
				return perk;
			}
			else
			{
				var perk:int = firstPerk;
				while (perk == firstPerk || perk == secondPerk)
					perk = FlxU.getRandom(perksAvailable) as int;
				return perk;
			}
		}
		
		public function choosePerk(index:uint):void 
		{
			var chosenPerk:int = perksDisplay[index];
			
			//if won game, set flag
			if (chosenPerk == -1)
			{
				PlayState.gameWon = true;
				perksDisplay[index] = 0;
				return;
			}
			
			perks[chosenPerk] = true;
			
			//search for and remove chosen perk from available perks list
			for (var i:int = 0; i < perksAvailable.length; i++)
			{
				if (perksAvailable[i] == chosenPerk)
					perksAvailable.splice(i, 1);
			}
			
			//handle active perk changes
			switch (chosenPerk)
			{
				case DOUBLE_SPEED:
				maxVelocityX = width * MAX_X_VELOCITY_COEFFICIENT * 2;
				break;
				
				case DOUBLE_BULLET_SPEED:
				weaponLeft.setBulletSpeed(weaponLeft.getBulletSpeed() * 3);
				weaponRight.setBulletSpeed(weaponRight.getBulletSpeed() * 3);
				break;
				
				case SLOW_ENEMIES:
				Enemy.maxVelocityX /= 2;
				break;
				
				case DOUBLE_FIRE_RATE:
				weaponLeft.setFireRate(400);
				weaponRight.setFireRate(400);
				break;
			}
		}
	}
}