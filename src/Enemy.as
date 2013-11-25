package  
{
	import org.flixel.*;
	
	public class Enemy extends FlxSprite
	{
		//movement constants
		private const MAX_VELOCITY_COEFFICIENT:Number = 3;
		private const ACCELERATION_COEFFICIENT:Number = 4;
		private const ACCELERATION_JUMP_COEFFICIENT:Number = 1;
		private const ACCELERATION_FALL_COEFFICIENT:Number = 2;
		private const DRAG_COEFFICIENT:Number = 4;
		private const TURNAROUND_COEFFICIENT:Number = .65;
		
		//movement
		public static var maxVelocityX:int = 96;
		public static var maxVelocityY:int = 192;
		
		public function Enemy(x:uint, y:uint, direction:uint) 
		{
			super(x, y);
			
			//load graphics and animations
			loadGraphic(Assets.enemy, true, true, 32, 64);
			addAnimation("idle", new Array(0, 0), 4);
			//addAnimation("runLeft", new Array(1, 1), 4);
			//addAnimation("runRight", new Array(2, 2), 4);
			play("idle");
			facing = direction;
			
			//set movement physics
			maxVelocity.x = width * MAX_VELOCITY_COEFFICIENT;
			maxVelocity.y = height * MAX_VELOCITY_COEFFICIENT;
			drag.x = maxVelocity.x * DRAG_COEFFICIENT;
			drag.y = maxVelocity.y * DRAG_COEFFICIENT;
		}
		
		override public function update():void 
		{
			super.update();
			
			updateMovement();
		}
		
		private function updateMovement():void 
		{
			maxVelocity.x = maxVelocityX;
			maxVelocity.y = maxVelocityY;
			
			if (isTouching(FlxObject.LEFT) || isTouching(FlxObject.RIGHT))
				changeDirection();
			
			if (isTouching(FLOOR))
			{
				if (facing == FlxObject.RIGHT)
					moveRight();
				else if (facing == FlxObject.LEFT)
					moveLeft();
			}
			else
				fall();
		}
		
		public function changeDirection():void 
		{
			if (facing == FlxObject.RIGHT)
				facing = FlxObject.LEFT;
			else if (facing == FlxObject.LEFT)
				facing = FlxObject.RIGHT;
			
			velocity.x *= -1;
			acceleration.x *= -1;
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
		
		public function fall():void 
		{
			acceleration.y = maxVelocity.y * ACCELERATION_FALL_COEFFICIENT;
		}
	}
}