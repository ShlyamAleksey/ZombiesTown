package
{
	import Events.GameEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class ServerTime extends EventDispatcher
	{
		static public var TIME:int;
		static public var _timer:Timer;
		
		static private var __init:ServerTime
		
		static public function get instance():ServerTime
		{
			if(!__init) __init = new ServerTime();
			return __init;
		}
		
		public function ServerTime()
		{
		}
		
		public function set_time(val:int):void
		{
			TIME = val;
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
		}
		
		public function onTimer(event:TimerEvent):void
		{
			TIME ++;
			dispatchEvent(new Event( GameEvent.SERVER_TIME ));
			//trace("Social.SERVER_TIME", TIME);
		}
		
		
	}
}