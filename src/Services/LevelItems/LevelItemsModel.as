package Services.LevelItems
{
	import Events.ServiceEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class LevelItemsModel extends EventDispatcher
	{
		private var __point:int;
		private var __id:String;
		
		public function LevelItemsModel(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function get points():int
		{
			return __point;
		}
		
		public function set points(val:int):void
		{
			__point = val;
			dispatchEvent(new Event( ServiceEvent.ITEMS_SERVICE ));
		}
		
		public function get id():String
		{
			return __id;
		}
		
		public function set id(val:String):void
		{
			__id = val;
			dispatchEvent(new Event( ServiceEvent.ITEMS_SERVICE ));
		}
	}
}