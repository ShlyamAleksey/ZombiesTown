package Services
{
	public class FriendsController
	{
		static private var _init:FriendsController
		static public var life_reward:int;
		static public var soft_reward:int;
		
		
		static public function get instance():FriendsController
		{
			if(!_init) _init = new FriendsController();
			return _init; 
		}
		
		public function FriendsController()
		{
		}
		
		public function init(o:*):void
		{
			Service.instance.friendsModel = new Vector.<FriendModel>();
			
			for (var i:int = 0; i < o.length; i++) 
			{
				var fm:FriendModel 		= new FriendModel();
					fm.firstName 		= o[i].first_name;
					fm.lastName 		= o[i].last_name;
					fm.picture 			= o[i].url_image;
					fm.uid 				= o[i].social_player_id;
					fm.playerId 		= o[i].player_id;
					fm.canGift 			= o[i].can_gift;
					fm.canGiftLife 			= o[i].can_gift_life;
					fm.points 			= o[i].points;
	
				Service.instance.friendsModel.push(fm);
			}
		}
	}
}