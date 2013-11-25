package  
{
	import org.flixel.*;
	import flash.ui.Mouse;
	
	public class MenuState extends FlxState
	{
		private var splash:FlxSprite = new FlxSprite(0, 0, Assets.titleScreen);
		
		public function MenuState() 
		{
		}
		
		override public function create():void 
		{
			add(splash);
			FlxG.fade(0xffffffff, 1);
		}
		
		override public function update():void 
		{
			Mouse.show();
			
			if (FlxG.keys.any())
				FlxG.fade(0xffffffff, 1, nextState);
		}
		
		private function nextState():void 
		{
			FlxG.switchState(new PlayState());
		}
	}
}