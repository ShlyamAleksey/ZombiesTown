/*	КЛАСС СОДЕРЖАЩИЙ В СЕБЕ ФУНКЦИИ ДЛЯ
	ВЫПОЛНЕНИЯ НА СТОРОНЕ СЕРВЕРА */

package Connect
{
	import Connect.Jsons.JSON;
	import Connect.Local.URLConnector;
	
	import flash.net.NetConnection;

	public class ServiceHandler
	{
		static private var _init:ServiceHandler;
		static public function get instance():ServiceHandler { return _init; }
		
		private var _gateway:String;
		private var _nc:URLConnector;
		
		public function ServiceHandler(netConnection:URLConnector, gateway:String)
		{
			_init = this;
			this._nc = netConnection;
			this._gateway = gateway;
		}
		
		/**НАЧАЛО НОВОГО УРОВНЯ*/
		public function startLevel(target:*, fun:Function, playerID:String, levelID:String):void
		{
			var params:Object = { "player_id" : playerID,
								  "level_id"  : levelID };
			
			_nc.send(_gateway + "level/start", onResult, onFault , params); 
			function onResult(result:Object):void { fun.call(target, result); }
		}
		
		/**КОНЕЦ УРОВНЯ*/
		public function endLevel(target:*, fun:Function, playerID:String, levelID:String, lifeCount:int, points:int, isWin:int):void
		{
			var params:Object = { 	"player_id" 				: playerID,
									"level_id"  				: levelID,
									"life_count"				: lifeCount,
									"points"					: points,
									"is_win"					: isWin};
			
			_nc.send(_gateway + "level/end", onResult, onFault , params); 
			function onResult(result:Object):void 
			{
				fun.call(target, result); 
			}
		}
		
		/**СОХРАНИТЬ ПРОГРЕСС*/
		public function saveLevel(target:*, fun:Function, playerID:String, clean:Boolean = false, field:Object = null, lifeCount:int = 0, points:int = 0):void
		{
			trace("SAVE GAME");
			var _js:* = Connect.Jsons.JSON.encode(   {		"field"				: 	field,
															"life_count"		: 	lifeCount,
															"points"			:	points});
			if(clean) _js = null;
			var params:Object = { 	"player_id" 				: playerID,									
									"current_level_progress"	: _js,
									"life_count"				: lifeCount};
			
			_nc.send(_gateway + "level/save", onResult, onFault , params); 
			function onResult(result:Object):void 
			{
				fun.call(target, result); 
			}
		}
		
		/**СДЕЛАТЬ ПОКУПКУ ЗА СОФТ*/
		public function softPurchase(target:*, fun:Function, playerID:String, purchase_id:String):void
		{
			var param:Object = {	"player_id" 			:	playerID,
									"purchase_id" 			:	purchase_id
			};
			
			_nc.send(_gateway + "purchase/MakePurchaseSoft", onResult, onFault , param); 
			function onResult(result:Object):void { fun.call(target, result); }
		}
		
//		http://app-v2.greemlins.com/zombietown/index.php?r=purchase/MakePurchaseSoft&player_id=532fef01cd9619951d8b456a&purchase_id=53203578387b67c668a8fd42
		
		/**TOP PAGE*/
		public function topPage(target:*, fun:Function, socialID:String, limit:int, offSet:int):void
		{
			var param:Object = { "social_id" 		:	socialID,
								 "limit" 			:	limit,
								 "offset"			:	offSet
			};
			
			_nc.send(_gateway + "player/TopPage", onResult, onFault , param); 
			
			function onResult(result:Object):void { fun.call(target, result); }
		}
		
		/**MY PLACE*/
		public function myPlace(target:*, fun:Function, playerID:String):void
		{
			var param:Object = {	"player_id" 			:	playerID }
			_nc.send(_gateway + "player/PositionTotal", onResult, onFault , param); 
			function onResult(result:Object):void { fun.call(target, result); }
		}
		
		/**SET STATUS*/
		public function setPublishStatus(target:*, fun:Function, playerID:String)
		{
			var param:Object = {	"player_id" 			:	playerID }
			_nc.send(_gateway + "player/SetStatusPost", onResult, onFault , param); 
			function onResult(result:Object):void { fun.call(target, result); }
		}
		
		/**SEND PRIZE*/
		public function sendPrize(target:*, fun:Function, playerID:String, friends_ids:String):void
		{
			var giftArr:Array = new Array();
			giftArr.push(friends_ids);
			var param:Object = {	"player_id" 			:	playerID,
									"friends_ids" 			:	Connect.Jsons.JSON.encode(giftArr)
			};
			
			_nc.send(_gateway + "gift/send", onResult, onFault , param); 
			function onResult(result:Object):void { fun.call(target, result); }
		}
		
		/**SEND LIFE*/
		public function sendLife(target:*, fun:Function, playerID:String, friends_ids:String, counts:int):void
		{
			var giftArr:Array = new Array();
			giftArr.push(friends_ids);
			var param:Object = {	"player_id" 			:	playerID,
									"friends_ids" 			:	Connect.Jsons.JSON.encode(giftArr),
									"life_count"			:	counts
			};
			
			_nc.send(_gateway + "life/send", onResult, onFault , param); 
			function onResult(result:Object):void { fun.call(target, result); }
		}
		
//		http://app-v2.greemlins.com/zombietown/index.php?r=gift/send&player_id=532fdca3d09619ba308b4567&friends_ids=["182749952"]
		
		protected function onFault(fault:Object):void { trace(String(fault.description));	}
	}
}