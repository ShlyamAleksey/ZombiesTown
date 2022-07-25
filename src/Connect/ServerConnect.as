package Connect
{
	import Connect.Local.Local;
	import Connect.OK.OK_API;
	
	import GUI.Screens.MapScreen;
	import GUI.Screens.PreloaderScreen;
	import GUI.Screens.ScreenManager;
	import GUI.Windows.FriendGift;
	import GUI.Windows.Loader;
	
	import Services.BonusController;
	import Services.FriendGiftsController;
	import Services.FriendsController;
	import Services.LevelItems.LevelItemsController;
	import Services.Levels.LevelController;
	import Services.Purchase.PurchaseController;
	import Services.Service;
	import Services.StatusPost.StatusPostController;
	import Services.User.UserController;

	public class ServerConnect
	{
		static private var _init:ServerConnect;
		static public function get instance():ServerConnect { return _init; }
		
		static private const SOCIAL					:String = "OK";
//		static private const SOCIAL					:String = "LOCAL";
		static public var SOCIAL_ID					:String;
		
		private var __connection					:Connection; 
		
		public function ServerConnect()
		{
			_init = this;
			setConnection();
		}
		
		private function setConnection():void
		{
			switch(SOCIAL)
			{
				case "LOCAL" : 
					SOCIAL_ID = "52a5cdfdfe24210407000001";
					this.__connection = new Local();
					break;
				case "VK" :
					break;
				case "OK" :
					SOCIAL_ID = "52a5cdfdfe24210407000001";
					Loader.instance.show(8, "Соединяем с Одноклассниками");
					this.__connection = new OK_API();
					break;
				case "MM" :
					break;
			}
			
			
			__connection.initConnection();
		}
		
		/**Информация о игроке*/
		public function userLoad(res:*):void
		{
			Loader.instance.show(100, "Рисуем карту");
			UserController.instance.init(res.response.player);
			LevelController.instance.init(res.response.levels);
			LevelItemsController.instance.init(res.response.level_items);
			PurchaseController.instance.init(res);
			StatusPostController.instance.init(res.response.status_post);
			FriendsController.instance.init(res.response.friends.players);
//			FriendsController.instance.init([{
//															"player_id": "53344f84387b674b3ec2bc93",
//															"social_player_id": "238828963813",
//															"first_name": "\u041c\u0430\u043a\u0441\u0438\u043c",
//															"last_name": "\u041e\u0441\u0442\u0430\u043f\u0435\u043d\u043a\u043e",
//															"url_image": "http:\/\/i508.mycdn.me\/getImage?photoId=533855257317&photoType=4&viewToken=Rffk41-PB3XO9L79xTCcug",
//															"points": 7,
//															"current_level_id": "53304e34387b678b54ee4799",
//															"can_gift": 1
//														}, {
//															"player_id": "53340d1a387b67de099a6ba2",
//															"social_player_id": "303669768733",
//															"first_name": "\u0415\u043b\u0435\u043d\u0430",
//															"last_name": "\u041c\u0430\u0440\u0442\u044b\u043d\u044e\u043a",
//															"url_image": "http:\/\/i500.mycdn.me\/getImage?photoId=187737569053&photoType=4&viewToken=e9QpamQ0Cd7vJg1nZF8CEA",
//															"points": 6,
//															"current_level_id": "53304e2a387b6784549def3a",
//															"can_gift": 1
//														}, {
//															"player_id": "5342b89f387b67355a054b17",
//															"social_player_id": "442206357685",
//															"first_name": "\u041d\u0430\u0442\u0430\u043b\u044c\u044f",
//															"last_name": "\u0420\u0443\u043b\u0438\u043a\u043e\u0432\u0430",
//															"url_image": "http:\/\/i508.mycdn.me\/getImage?photoId=225679153077&photoType=4&viewToken=Zmy4Jf1boXdotA2suSbZUQ",
//															"points": 5,
//															"current_level_id": "53204230387b67b674abf4e8",
//															"can_gift": 1
//														}, {
//															"player_id": "533410d7387b67d209340b1b",
//															"social_player_id": "475718395346",
//															"first_name": "\u041d\u0438\u043a\u0438\u0442\u0430",
//															"last_name": "\u0420\u0430\u0447\u043a\u0435\u0432\u0438\u0447",
//															"url_image": "http:\/\/i508.mycdn.me\/getImage?photoId=412537704914&photoType=4&viewToken=iNQxpaedGWeQQTHmvn985Q",
//															"points": 8,
//															"current_level_id": "53318a5f387b678e104dffa1",
//															"can_gift": 1
//														}, {
//															"player_id": "53340caa387b67d1095d2c43",
//															"social_player_id": "48757974812",
//															"first_name": "\u0410\u043b\u0435\u043a\u0441\u0435\u0439",
//															"last_name": "\u0421\u0430\u0432\u0447\u0435\u043d\u043a\u043e",
//															"url_image": "http:\/\/i500.mycdn.me\/getImage?photoId=48833687836&photoType=4&viewToken=XiCuJXbwUppSwg1PZGenoQ",
//															"points": 0,
//															"current_level_id": "530c94e8fe2421d412000000",
//															"can_gift": 1
//														}, {
//															"player_id": "533bc0bb387b677d5bc52aff",
//															"social_player_id": "558528498432",
//															"first_name": "\u041e\u043b\u044c\u0433\u0430",
//															"last_name": "\u0421\u0438\u0440\u0438\u043d\u0435\u043a",
//															"url_image": "http:\/\/i508.mycdn.me\/res\/stub_50x50.gif",
//															"points": 6,
//															"current_level_id": "53304e2a387b6784549def3a",
//															"can_gift": 1
//														}, {
//															"player_id": "5342989d387b67c04c2df10d",
//															"social_player_id": "515070426489",
//															"first_name": "\u2713\u0410\u043d\u0434\u0440\u0435\u0439",
//															"last_name": "\u0414\u044f\u0442\u043b\u0438\u043a\u2713",
//															"url_image": "http:\/\/i500.mycdn.me\/getImage?photoId=527516960633&photoType=4&viewToken=CrckAzrWUdBmOCxUd0o-mA",
//															"points": 0,
//															"current_level_id": "530c94e8fe2421d412000000",
//															"can_gift": 1
//														}, {
//															"player_id": "53340d68387b67bd094642f7",
//															"social_player_id": "574710564375",
//															"first_name": "\u0421\u0432\u0435\u0442\u043b\u0430\u043d\u0430",
//															"last_name": "\u041a\u0443\u0434\u0440\u044f\u0432\u0446\u0435\u0432\u0430",
//															"url_image": "http:\/\/i500.mycdn.me\/getImage?photoId=576305558807&photoType=4&viewToken=aKW3yQN_c2i2kNvFOjzlRg",
//															"points": 4,
//															"current_level_id": "53204225387b67b3744621b7",
//															"can_gift": 1
//														}]);
			
			
			BonusController.instance.init(res);
			FriendGiftsController.instance.init(res);
			
			FriendsController.life_reward = res.response.friends.reward_life_count;
			FriendsController.soft_reward = res.response.friends.reward_currency_soft;
			
			ServerTime.instance.set_time( res.response.app_info.server_time );	
			
			if(Service.instance.bonusModel.received_gifts != 0) 
			{
				FriendGift.NEED_SHOW = true;
			}
			
			//res.response.friend_gifts.total_content_count
			trace("a",res.response.bonus.daily_bonus)
			trace("b",res.response.friends.current_reward)
			
			if (res.response.bonus.daily_bonus == null && res.response.friends.current_reward_life_count == 0  && res.response.friends.current_reward_currency_soft == 0) 
			{
				GUI.Windows.Info.NEED_SHOW = false;
			}
		}
	}
}


