package Services
{
	import flash.events.EventDispatcher;

	public class FriendModel extends EventDispatcher
	{
		public var uid:int;
		public var firstName:String;
		public var lastName:String;
		public var picture:String;
		public var playerId:String;
		public var canGift:int;
		public var canGiftLife:int;
		public var points:int;
		
		public function FriendModel()
		{
		}
	}
}