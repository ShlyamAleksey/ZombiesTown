package GUI.Windows
{
	import Connect.OK.ApiCallbackEvent;
	import Connect.OK.ForticomAPI;
	import Connect.ServiceHandler;
	
	import Events.GameEvent;
	
	import GUI.InteractiveTutorial.Tutorial;
	
	import Game.Constants.ItemsConstant;
	import Game.Logic.Pause;
	import Game.Logic.Undo;
	import Game.Model.FieldModel;
	import Game.Model.ItemsModel;
	import Game.UI.DropItemUI;
	
	import Services.Service;
	
	import Sounds.GameMusic;
	import Sounds.boxSoundType;
	
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class ItemsShop extends ItemShop_GUI
	{
		static public var BOUGHT_ITEM:int;
		private var purchase_name:String;
		
		static public var FREEZE:Boolean = false;
		
		public function ItemsShop()
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
			cristalItem.addEventListener(MouseEvent.CLICK, paymentCall);
			price_1.text = "Кристалл    " + Service.instance.purchaseModel[10].price_hard;
			price_1.mouseEnabled = false;

			treeItem.addEventListener(MouseEvent.CLICK, paymentCall);
			price_2.text = "Дерево                " + Service.instance.purchaseModel[12].price_hard;
			price_2.mouseEnabled = false;
			
			botItem.addEventListener(MouseEvent.CLICK, paymentCall);
			price_3.text = "Бот              " + Service.instance.purchaseModel[11].price_hard;
			price_3.mouseEnabled = false;
			
			bushItem.addEventListener(MouseEvent.CLICK, paymentCall);
			price_4.text = "Куст           " + Service.instance.purchaseModel[13].price_hard;
			price_4.mouseEnabled = false;
			
			undoItem.addEventListener(MouseEvent.CLICK, paymentCall);
			price_5.text = "Отмена           " + Service.instance.purchaseModel[9].price_hard;
			price_5.mouseEnabled = false;
			
			hutItem.addEventListener(MouseEvent.CLICK, paymentCall);
			price_6.text = "Хижина           " + Service.instance.purchaseModel[16].price_hard;
			price_6.mouseEnabled = false;
			
			Pause.stop = true;
			freeze();
			
			GameMusic.music.playSound( boxSoundType.SWindowOpen);
		}
		
		protected function paymentCall(e:MouseEvent):void
		{
			GameMusic.music.playSound( boxSoundType.SPurchaise );
			switch(e.currentTarget.name)
			{ 
				case "cristalItem":
					makePurchase(10);
					break;
				case "treeItem":
					makePurchase(12);
					break;
				case "botItem":
					makePurchase(11);
					break;
				case "bushItem":
//					if(Tutorial.STATUS) Tutorial.main.step_17();
//					else makePurchase(13);
					makePurchase(13);
					break;
				case "hutItem":
					makePurchase(16);
					break;
				case "undoItem":
					makePurchase(9);
					break;
			}
			
			purchase_name = e.currentTarget.name;
		}
		
		private function makePurchase(bonusOrder:int):void
		{
			ForticomAPI.showPayment(Service.instance.purchaseModel[bonusOrder].name,
				Service.instance.purchaseModel[bonusOrder].description,
				Service.instance.purchaseModel[bonusOrder].purchase_id,
				Service.instance.purchaseModel[bonusOrder].price_hard, null, null, null, 'true');
			
			ForticomAPI.addEventListener(ApiCallbackEvent.CALL_BACK, handleApiEvent);
			
			function handleApiEvent(event:Event):void
			{
				onItemBuy(purchase_name);
				FieldModel.instance.dispatchGameEvent(GameEvent.CHANGE_FIELD);
				WindowsManager.instance.hide();
				
				Service.instance.userModel.currencySoft -= Service.instance.purchaseModel[bonusOrder].price_soft;
				ForticomAPI.removeEventListener(ApiCallbackEvent.CALL_BACK, handleApiEvent);
			}
			
//			ServiceHandler.instance.softPurchase(this, function (res:*):void
//			{
//				if(res.response.message != "Not enough currency soft")
//				{
//					onItemBuy(purchase_name);
//					FieldModel.instance.dispatchGameEvent(GameEvent.CHANGE_FIELD);
//					WindowsManager.instance.hide();
//					
//					Service.instance.userModel.currencySoft -= Service.instance.purchaseModel[bonusOrder].price_soft;
//				}
//				else
//				{
//					WindowsManager.instance.show( NotMoney );
//				}
//			}
//				, Service.instance.userModel.playerId, Service.instance.purchaseModel[bonusOrder].purchase_id);		
		}
		
		
		
		private function onItemBuy(purchase_name:String):void
		{
			switch(purchase_name)
			{
				case "cristalItem":
					ItemsModel.BUY__ITEM = true;
					BOUGHT_ITEM = ItemsConstant.TYPE_CRISTAL;
					DropItemUI.TYPE = BOUGHT_ITEM;
					break;
				case "treeItem":
					ItemsModel.BUY__ITEM = true;
					BOUGHT_ITEM = ItemsConstant.TYPE_TREE;
					DropItemUI.TYPE = BOUGHT_ITEM;
					break;
				case "botItem":
					ItemsModel.BUY__ITEM = true;
					BOUGHT_ITEM = ItemsConstant.TYPE_BOT;
					DropItemUI.TYPE = BOUGHT_ITEM;
					break;
				case "bushItem":
					ItemsModel.BUY__ITEM = true;
					BOUGHT_ITEM = ItemsConstant.TYPE_BUSH;
					DropItemUI.TYPE = BOUGHT_ITEM;
					break;
				case "hutItem":
					ItemsModel.BUY__ITEM = true;
					BOUGHT_ITEM = ItemsConstant.TYPE_HUT;
					DropItemUI.TYPE = BOUGHT_ITEM;
					break;
				case "undoItem":
					ItemsModel.BUY__ITEM = true;
					BOUGHT_ITEM = Undo.last_drop;
					DropItemUI.TYPE = BOUGHT_ITEM;
					Undo.execute();
					FREEZE = true;
					break;
			}
		}
		
		public function freeze():void
		{
			if(!FREEZE)
			{
				undoItem.mouseEnabled = true;
				TweenMax.from(undoItem, 0.25, {colorMatrixFilter:{colorize:0xffffff, amount:1}});
			}
			else
			{
				undoItem.mouseEnabled = false;
				TweenMax.to(undoItem, 0.25, {colorMatrixFilter:{colorize:0xffffff, amount:1}});
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
			cristalItem.removeEventListener(MouseEvent.CLICK, closeWindow);
			treeItem.removeEventListener(MouseEvent.CLICK, closeWindow);
			botItem.removeEventListener(MouseEvent.CLICK, closeWindow);
			bushItem.removeEventListener(MouseEvent.CLICK, closeWindow);
			undoItem.removeEventListener(MouseEvent.CLICK, closeWindow);
		}
	}
} 