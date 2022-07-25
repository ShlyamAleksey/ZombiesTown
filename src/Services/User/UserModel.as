package Services.User
{
	import Events.ServiceEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class UserModel extends EventDispatcher
	{
		private var __abs:Array;
		private var __completedLevelsIds:Array;
		private var __currency__soft:int;
		private var __currentLevelId:String;
		private var __entryCount:int;
		private var __firstName:String;
		private var __lastName:String;
		private var __levelProgress:Array;
		private var __life:Object;
		private var __playerID:String;
		private var __points:int;
		private var __urlImage:String;
		private var __current_levels_progress:Object;
		
		
		public function UserModel()
		{
		}

		public function get currentLevelsProgress():Object
		{
			return __current_levels_progress;
		}

		public function set currentLevelsProgress(value:Object):void
		{
			__current_levels_progress = value;
		}

		public function get currencySoft():int
		{
			return this.__currency__soft;
		}
		
		public function set currencySoft(val:int):void
		{
			this.__currency__soft = val;
			dispatchEvent( new Event( ServiceEvent.USER_SERVICE ) );
		}
		
		public function get completedLevelIds():Array
		{
			return __completedLevelsIds;
		}
		
		public function set completedLevelIds(val:Array):void
		{
			__completedLevelsIds = val;
			dispatchEvent( new Event( ServiceEvent.USER_SERVICE ) );
		}
		
		public function get abs():Array
		{
			return __abs;
		}
		
		public function set abs(val:Array):void
		{
			__abs = val;
			dispatchEvent( new Event( ServiceEvent.USER_SERVICE ) );
		}
		
		public function get currentLevelId():String
		{
			return __currentLevelId;
		}
		
		public function set currentLevelId(val:String):void
		{
			__currentLevelId = val;
			dispatchEvent( new Event( ServiceEvent.USER_SERVICE ) );
		}
		
		public function get entryCount():int
		{
			return __entryCount;
		}
		
		public function set entryCount(val:int):void
		{
			__entryCount = val;
			dispatchEvent( new Event( ServiceEvent.USER_SERVICE ) );
		}
		
		public function get firstName():String
		{
			return __firstName;
		}
		
		public function set firstName(val:String):void
		{
			__firstName = val;
			dispatchEvent( new Event( ServiceEvent.USER_SERVICE ) );
		}
		
		public function get lastName():String
		{
			return __lastName;
		}
		
		public function set lastName(val:String):void
		{
			__lastName = val;
			dispatchEvent( new Event( ServiceEvent.USER_SERVICE ) );
		}
		
		public function get levelProgress():Array
		{
			return __levelProgress;
		}
		
		public function set levelProgress(val:Array):void
		{
			__levelProgress = val;
			dispatchEvent( new Event( ServiceEvent.USER_SERVICE ) );
		}
		
		public function get life():Object
		{
			return __life;
		}
		
		public function set life(val:Object):void
		{
			__life = val;
			dispatchEvent( new Event( ServiceEvent.USER_SERVICE ) );
		}
		
		public function get playerId():String
		{
			return __playerID;
		}
		
		public function set playerId(val:String):void
		{
			__playerID = val;
			dispatchEvent( new Event( ServiceEvent.USER_SERVICE ) );
		}
		
		public function get points():int
		{
			return __points;
		}
		
		public function set points(val:int):void
		{
			__points = val;
			if(__points < 0) __points = 0;
			dispatchEvent( new Event( ServiceEvent.USER_SERVICE ) );
		}
		
		public function get urlImage():String
		{
			return __urlImage;
		}
		
		public function set urlImage(val:String):void
		{
			__urlImage = val;
			dispatchEvent( new Event( ServiceEvent.USER_SERVICE ) );
		}
	}
}