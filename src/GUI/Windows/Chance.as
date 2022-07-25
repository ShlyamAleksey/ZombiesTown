package GUI.Windows
{
	import Connect.OK.ApiCallbackEvent;
	import Connect.OK.ForticomAPI;
	import Connect.ServiceHandler;
	
	import Events.ServiceEvent;
	
	import GUI.Screens.MapScreen;
	import GUI.Screens.ScreenManager;
	
	import Game.Logic.Pause;
	
	import GlobalLogic.LevelManager;
	
	import Services.Service;
	
	import Sounds.GameMusic;
	import Sounds.boxSoundType;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Chance extends Chanse_GUI
	{
		static public var ONCE:Boolean = false;
		
		public function Chance()
		{
			super();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			closeBtn.addEventListener(MouseEvent.CLICK, onClose);
			buyRunBtn.addEventListener(MouseEvent.CLICK, buyRun);
			
			descriptionTF.text = "50 дополнительных ходов за " + Service.instance.purchaseModel[15].price_hard + "";
			Pause.stop = true;
			ONCE = true;
			GameMusic.music.playSound( boxSoundType.SWindowOpen);
		}
		
		protected function buyRun(event:MouseEvent):void
		{
			makePurchase(15);
		}
		
		private function makePurchase(bonusOrder:int):void
		{
			ForticomAPI.showPayment(Service.instance.purchaseModel[bonusOrder].name,
									Service.instance.purchaseModel[bonusOrder].description,
									Service.instance.purchaseModel[bonusOrder].purchase_id,
									Service.instance.purchaseModel[bonusOrder].price_hard, null, null, null, 'true');
			
			ForticomAPI.addEventListener(ApiCallbackEvent.CALL_BACK, handleApiEvent);			
		}
		
		protected function handleApiEvent(event:ApiCallbackEvent):void
		{
			Service.instance.userModel.life.count = 20;
			Service.instance.userModel.dispatchEvent( new Event( ServiceEvent.USER_SERVICE ) );
			ForticomAPI.removeEventListener(ApiCallbackEvent.CALL_BACK, handleApiEvent);
			WindowsManager.instance.hide();
		}
		
		protected function onClose(event:MouseEvent):void
		{	
			WindowsManager.instance.hide(showDefeat);
		}

		
		private function showDefeat():void
		{
			LevelManager.instance.onEndLevel(0);
		}
		
		private function destroy(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);	
			closeBtn.removeEventListener(MouseEvent.CLICK, onClose);
			buyRunBtn.removeEventListener(MouseEvent.CLICK, buyRun);
			ONCE = false;
		}
	}
}