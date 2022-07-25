package Services.Levels
{
	import Events.ServiceEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class LevelModel extends EventDispatcher
	{
		private var __description:String;
		private var __level__id:String;
		private var __name:String;
		private var __required__points:int;
		private var __reward__currency__soft:int;
		
		
		public function LevelModel()
		{
		}
		
		public function get description():String
		{
			return __description;
		}
		
		public function set description(val:String):void
		{
			__description = val;
			dispatchEvent(new Event( ServiceEvent.LEVEL_SERVICE ));
		}
		
		public function get levelId():String
		{
			return __level__id;
		}
		
		public function set levelId(val:String):void
		{
			__level__id = val;
			dispatchEvent(new Event( ServiceEvent.LEVEL_SERVICE ));
		}
		
		public function get name():String
		{
			return __name;
		}
		
		public function set name(val:String):void
		{
			__name = val;
			dispatchEvent(new Event( ServiceEvent.LEVEL_SERVICE ));
		}
		
		public function get reguiredPoints():int
		{
			return __required__points;
		}
		
		public function set reguiredPoints(val:int):void
		{
			__required__points = val;
			dispatchEvent(new Event( ServiceEvent.LEVEL_SERVICE ));
		}
		
		public function get rewardCurrencySoft():int
		{
			return __reward__currency__soft;
		}
		
		public function set rewardCurrencySoft(val:int):void
		{
			__reward__currency__soft = val;
			dispatchEvent(new Event( ServiceEvent.LEVEL_SERVICE ));
		}
		
	}
}