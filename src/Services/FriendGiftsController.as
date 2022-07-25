package Services
{
	public class FriendGiftsController
	{
		static private var __init:FriendGiftsController
		
		static public function get instance():FriendGiftsController
		{
			if(!__init) __init = new FriendGiftsController();
			return __init;
		}
		
		
		public function init(res:*):void
		{
			if(res.response.friend_gifts.received_gifts != null)
			{
				var allGiftCount:int = 0;
				
				for each (var i:* in res.response.friend_gifts.received_gifts.players) 
				{
					allGiftCount += i.content_count;
				}
				
				Service.instance.bonusModel.received_gifts = allGiftCount;
			}
		}
		
		public function FriendGiftsController()
		{
		}
	}
}