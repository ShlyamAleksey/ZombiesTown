package GUI.Windows
{
	import Connect.OK.ApiCallbackEvent;
	import Connect.OK.ForticomAPI;
	import Connect.ServiceHandler;
	
	import Events.GameEvent;
	
	import Game.Constants.ItemsConstant;
	import Game.Logic.Pause;
	import Game.Model.FieldModel;
	import Game.Model.ItemsModel;
	import Game.UI.DropItemUI;
	import Game.UI.HelperUI;
	
	import GlobalLogic.LevelManager;
	
	import Services.Service;
	
	import Sounds.GameMusic;
	import Sounds.boxSoundType;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class BotShop extends BotWin_GUI
	{
		public function BotShop()
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
			buyBot.addEventListener(MouseEvent.CLICK, paymentCall);	
			
			Pause.stop = true;
			
			this.priceTF.text = Service.instance.purchaseModel[17].price_hard.toString();;
		}
		
		protected function paymentCall(e:MouseEvent):void
		{
			GameMusic.music.playSound( boxSoundType.SPurchaise );
			makePurchaseHard(17);
		}
		
		private function makePurchaseHard(bonusOrder:int):void
		{
			ForticomAPI.showPayment(Service.instance.purchaseModel[bonusOrder].name,
				Service.instance.purchaseModel[bonusOrder].description,
				Service.instance.purchaseModel[bonusOrder].purchase_id,
				Service.instance.purchaseModel[bonusOrder].price_hard, null, null, null, 'true');
			
			ForticomAPI.addEventListener(ApiCallbackEvent.CALL_BACK, handleApiEvent);	
			
//			ServiceHandler.instance.softPurchase(this, function (res:*):void
//			{
//				if(res.response.message != "Not enough currency soft")
//				{
//					handleApiEvent();
//					Service.instance.userModel.currencySoft -= Service.instance.purchaseModel[17].price_soft;
//				}
//				else
//				{
//					WindowsManager.instance.show( NotMoney );
//				}
//			}, Service.instance.userModel.playerId, Service.instance.purchaseModel[bonusOrder].purchase_id);			
		}
		
		protected function handleApiEvent():void
		{
			ItemsModel.BUY__ITEM = true;
			ItemsShop.BOUGHT_ITEM = ItemsConstant.TYPE_BOT;
			DropItemUI.TYPE = ItemsShop.BOUGHT_ITEM;
			FieldModel.instance.dispatchGameEvent(GameEvent.CHANGE_FIELD);
			
			WindowsManager.instance.hide();
			HelperUI.instance.gotoAndStop(2);
			
			ForticomAPI.removeEventListener(ApiCallbackEvent.CALL_BACK, handleApiEvent);
		}
		
		protected function closeWindow(event:MouseEvent):void
		{					
			WindowsManager.instance.hide(function ():void{ LevelManager.instance.onEndLevel(0); });
		}
		
		private function destroy(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);	
			closeBtn.removeEventListener(MouseEvent.CLICK, closeWindow);
			buyBot.removeEventListener(MouseEvent.CLICK, paymentCall);
		}
	}
}