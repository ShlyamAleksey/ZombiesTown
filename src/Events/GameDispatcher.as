package Events 
{
	import Events.GameEvent;
	
	import flash.events.EventDispatcher;

	/**
	 * ...
	 * @author me
	 */
	public class GameDispatcher extends EventDispatcher
	{
		private static var instance		: GameDispatcher;
		
		public function GameDispatcher() 
		{
			
		}
		
		public static function getInstance(): GameDispatcher {
			return instance ? instance : instance = new GameDispatcher();
		}
		
		public function dispatchGameEvent(type: String, obj:Object = null): void
		{			
			var ge:GameEvent = new GameEvent(type)
			switch(type)
			{
				case GameEvent.ITEMS_CHECK:
				case GameEvent.ZOMBIE_MOVE:
				case GameEvent.NINJA_MOVE:
				case GameEvent.GRAVE_CHECK:
				case GameEvent.COMPLETE_ANIM:
				case GameEvent.SHOW_HELP:
				case GameEvent.SHOW_HELP_CRISTAL:
					ge.object = obj;
					break;
			}
			dispatchEvent(ge);
		}
	}
}