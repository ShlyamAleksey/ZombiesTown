package GUI.Windows
{
	
	import Connect.OK.ApiCallbackEvent;
	import Connect.OK.ForticomAPI;
	import Connect.ServiceHandler;
	
	import Services.Service;
	
	import Sounds.GameMusic;
	import Sounds.boxSoundType;
	
	import api.com.odnoklassniki.Odnoklassniki;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	

	public class Publish extends Publish_win
	{
		static public var POST_IN_SEANCE:Boolean = false;;
		
		public function Publish()
		{
			super();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			closeBtn.addEventListener(MouseEvent.CLICK, closeWindow);
			publishBtn.addEventListener(MouseEvent.CLICK, publish);
			
			rewardTF.text = "Награда " + Service.instance.statusPostModel.rewardCurrency;
			GameMusic.music.playSound( boxSoundType.SWindowOpen);
		}
		
		protected function publish(e:MouseEvent):void
		{	
			setStatus();				
		}
		
		public function setStatus():void 
		{
			Odnoklassniki.callRestApi("users.hasAppPermission" , requestStatusPermission, { ext_perm:'SET STATUS' }, "JSON", "POST" )
		}
		
		private function requestStatusPermission(response:*):void 
		{
			if (response) 
			{
				changeStatus();
			}
			else 
			{
				Odnoklassniki.showPermissions("SET STATUS");
				ForticomAPI.addEventListener(ApiCallbackEvent.CALL_BACK, onStatusPermissionGranted);
			}
		}
		private function onStatusPermissionGranted(response:*):void 
		{
			if (response.result=="ok" && response.method == "showPermissions") 
			{
				changeStatus();
			}
		}
		
		private function changeStatus():void 
		{			
			var stat:String = "Друзья! Есть отличная игра ЗомбиТаун, вам она понравиться! http://www.odnoklassniki.ru/game/220416256";
			
			Odnoklassniki.callRestApi("users.setStatus", onStatusAdded, {status: stat}, "JSON", "POST")
			ForticomAPI.removeEventListener(ApiCallbackEvent.CALL_BACK, onStatusPermissionGranted);
		}
		
		private function onStatusAdded(event : Boolean):void
		{
			if (event)
			{
				ServiceHandler.instance.setPublishStatus(this, function (res:*):void{}, Service.instance.userModel.playerId);
				Service.instance.userModel.currencySoft = Service.instance.userModel.currencySoft + Service.instance.statusPostModel.rewardCurrency;
				closeWindow(null);
			}
		}
		
		protected function closeWindow(event:MouseEvent):void
		{
			WindowsManager.instance.hide();
		}
		
		private function destroy(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);	
			closeBtn.removeEventListener(MouseEvent.CLICK, closeWindow);
			publishBtn.removeEventListener(MouseEvent.CLICK, publish);
		}
	}
}