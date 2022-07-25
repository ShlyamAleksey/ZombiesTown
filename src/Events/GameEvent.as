package Events
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class GameEvent extends Event
	{
		static public const ITEMS_CHECK				:String = "On items check";
		static public const GRAVE_CHECK				:String = "Grave check";
		static public const CHANGE_FIELD			:String = "Change game field";
		static public const ZOMBIE_MOVE				:String = "Zombie move";
		static public const NINJA_MOVE				:String = "Ninja move";
		static public const COMPLETE_ANIM			:String = "Complete all anim";
		static public const SHOW_HELP				:String = "Show help";
		static public const SHOW_HELP_CRISTAL		:String = "Show help cristal";
		static public const DROP_ITEM				:String = "Drop item";
		static public const SERVER_TIME				:String = "Server time";
	
		public var object:*; 
		
		public function GameEvent(type: String, bubbles: Boolean = false, cancelable: Boolean = false) 
		{
			super(type, bubbles, cancelable);
		}
	}
	
	
}