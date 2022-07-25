package Connect.OK
{
	import Connect.Connection;
	import Connect.Jsons.JSON;
	import Connect.Local.URLConnector;
	import Connect.ServerConnect;
	import Connect.ServiceHandler;
	
	import GUI.Screens.PreloaderScreen;
	import GUI.Windows.Loader;
	
	import api.com.odnoklassniki.Odnoklassniki;
	import api.com.odnoklassniki.events.ApiServerEvent;


	public class OK_API extends Connection
	{
		static private var _init:OK_API;
		static public function instance():OK_API { return _init; }
		
		static private const API_SECRET_KEY:String = "F7F3D1AB846AC239B3045C63";
		
		private var __handler:ServiceHandler;
		private var _friends_social_ids:Array = new Array();
		
		private var _avatar:String = "http://puu.sh/7LnRo.jpg";
		private var _firstName:String = "Aleksey";
		private var _lastName:String = "Shlyam";
		private var _socialFriendIDs:Array;
		
		
		public function OK_API()
		{
			_init = this;
			
		}
		
		override public function initConnection():void
		{			
			Odnoklassniki.initialize(zombietown.instance.stage, API_SECRET_KEY);
			Odnoklassniki.addEventListener(ApiServerEvent.CONNECTED, onConnect);
			Odnoklassniki.addEventListener(ApiServerEvent.CONNECTION_ERROR, onErrorConnection);
			Odnoklassniki.addEventListener(ApiServerEvent.PROXY_NOT_RESPONDING, onErrorConnection);
			Odnoklassniki.addEventListener(ApiServerEvent.NOT_YET_CONNECTED, onErrorConnection);
		}
		
		/**ЗАПРОС ИНФОРМАЦИИ О СЕБЕ В ОК*/
		private function onConnect( e: ApiServerEvent ): void
		{
			Loader.instance.show(20, "Запрашиваем информацию о пользователе");
			var uids:* = Odnoklassniki.session.uid;
			var fields:String = "uid, first_name, last_name, pic_1";
			Odnoklassniki.callRestApi( "users.getInfo" , _getUsersInfo, { uids:uids , fields:fields }, "JSON", "POST" );
			
			ForticomAPI.connection = zombietown.instance.stage.loaderInfo.parameters["apiconnection"];
		}
		
		/**ИНФОРМАЦИЯ О СЕБЕ В ОК*/
		private function _getUsersInfo( data: Object ): void
		{	
			Loader.instance.show(50, "Запрашиваем информацию о друзьях");
			USER_ID = data[0].uid
			_avatar = data[0].pic_1;
			_firstName = data[0].first_name;
			_lastName = data[0].last_name;
		
			var uids:* = Odnoklassniki.session.uid;
			Odnoklassniki.callRestApi( "friends.getAppUsers" , _getFriends, { uids:uids}, "JSON", "POST" );		 
		}
		
		/**СПИСОК ДРУЗЕЙ В ОК*/
		private function _getFriends( data: Object ):void
		{		
			Loader.instance.show(90, "Соединяемся с сервером");
			for (var i:int = 0; i < data.uids.length; i++) 
			{
				_friends_social_ids.push( data.uids[i] );
			}	
			
			initServer();
		}
		
		public function initServer():void
		{
			nc = new URLConnector();
			
			this.__handler = new ServiceHandler(nc, gateway);
			userInfo(zombietown.instance, ServerConnect.instance.userLoad);
		}
		
		/**ЗАПРОС О ПОЛЬЗОВАТЕЛЕ*/
		override public function userInfo(target:*, fun:Function):void
		{
			
			var param:Object = {  "social_id" 		 	:	ServerConnect.SOCIAL_ID,
									"social_player_id"  :	USER_ID,
									"url_image"		 	:	_avatar,
									"first_name"		:	_firstName,
									"last_name"		 	:	_lastName,
									"social_friends_ids": Connect.Jsons.JSON.encode(_friends_social_ids)};
			trace(ServerConnect.SOCIAL_ID);
			
			nc.send(gateway + "game/init", onResult, onFault  , param);
			function onResult(result:Object):void
			{
				fun.call(target, result); 
			}		
		}
		
		/**ДЛЯ ЛОКАЛЬНОГО СОЕДИНЕНИЯ*/
		protected function onErrorConnection(event:ApiServerEvent ):void
		{
			trace(String(event));
			initServer();
		}
	}
}