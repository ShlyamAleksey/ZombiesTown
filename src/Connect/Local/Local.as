package Connect.Local
{
	import Connect.Connection;
	import Connect.ServerConnect;
	import Connect.ServiceHandler;

	public class Local extends Connection
	{
		static private var _init:Local;
		static public function instance():Local { return _init; }
		
		private var __handler:ServiceHandler;
		
		private var _avatar:String = "http://puu.sh/7LnRo.jpg";
		private var _firstName:String = "Aleksey";
		private var _lastName:String = "Shlyam";
		
		public function Local()
		{
			_init = this;
			
		}
		
		override public function initConnection():void
		{
			nc = new URLConnector();
			
			this.__handler = new ServiceHandler(nc, gateway);
			userInfo(zombietown.instance, ServerConnect.instance.userLoad);
		}
		
		/**ЗАПРОС О ПОЛЬЗОВАТЕЛЕ*/
		override public function userInfo(target:*, fun:Function):void
		{
			var param:Object = { 	"social_id" 		:	ServerConnect.SOCIAL_ID,
									"social_player_id" :	USER_ID, 
									"url_image"		 	:	_avatar,
									"first_name"		:	_firstName,
									"last_name"		 	:	_lastName};
		
			nc.send(gateway + "game/init", onResult, onFault  , param);
			function onResult(result:Object):void
			{
				fun.call(target, result); 
			}		
		}
	}
}