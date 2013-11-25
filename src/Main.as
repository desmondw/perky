package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(width = "640", height = "480", backgroundColor = "#aaaaaa")]
	
	public class Main extends Sprite
	{
		//used by mochiads to verify authenticity.
		public var _mochiads_game_id:String = "44aaff2c5b3831f2";
		
		public function Main():void
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addChild(new Game(this));
		}
	}
}