package Game.Logic
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class Pause extends EventDispatcher
	{
		static private var __init:Pause;
		static public var PAUSE:String = "Pause game";
		static public var stop:Boolean = false;
		
		static public function get instance():Pause
		{
			if(!__init) __init = new Pause();
			return __init;
		}
		
		public function Pause()
		{
		}
		
		public function pause():void
		{
			if(!stop) stop = true;
			else stop = false;
			dispatchEvent(new Event( PAUSE ));	
		}
		
		public function play():void
		{
		
		}
	}
}