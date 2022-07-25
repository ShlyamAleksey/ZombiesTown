package GUI.Windows
{
	import Connect.OK.ApiCallbackEvent;
	import Connect.OK.ForticomAPI;
	import Connect.ServiceHandler;
	
	import Game.Logic.Pause;
	
	import Services.Service;
	
	import Sounds.GameMusic;
	import Sounds.boxSoundType;
	
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class RunShop_Win extends BuyRuns_GUI
	{
		private var _count:int = 0;
		private var _unlimit:Boolean = false;
		
		public function RunShop_Win()
		{
			super();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			closeBtn.addEventListener(MouseEvent.CLICK, close);
			zombietown.instance.tracker.trackEvent("Зашли в банк ходов","Банк");
			
			for (var i:int = 0; i < 4; i++) 
			{
				(this["item_" + i] as MovieClip).addEventListener(MouseEvent.CLICK, paymentCall);
				this["item_" + i].softTF.text = Service.instance.purchaseModel[i + 5].content_count;
				this["item_" + i].hardTF.text = "=  " + Service.instance.purchaseModel[i + 5].price_soft; 
			
				(this["item_" + i] as MovieClip).addEventListener(MouseEvent.MOUSE_OVER, onOver);
				(this["item_" + i] as MovieClip).addEventListener(MouseEvent.MOUSE_OUT, onOut);
				(this["item_" + i] as MovieClip).addEventListener(MouseEvent.MOUSE_DOWN, onDown);
				(this["item_" + i] as MovieClip).addEventListener(MouseEvent.MOUSE_UP, onUp);
			
			}
			
			item_unlim.addEventListener(MouseEvent.CLICK, paymentCall);
			item_unlim.hardTF.text = "=  " + Service.instance.purchaseModel[4].price_hard; 
			item_unlim.desc.text = "Безлимит на 3 дня";
			
			Pause.stop = true;
			
			item_unlim.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			item_unlim.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			item_unlim.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			item_unlim.addEventListener(MouseEvent.MOUSE_UP, onUp);
			
			GameMusic.music.playSound( boxSoundType.SWindowOpen);
		}
		
		protected function onUp(e:MouseEvent):void
		{
			TweenMax.to( e.currentTarget, 0.1, { scaleX: 1.02, scaleY: 1.02, glowFilter:{color:0x33ccff, alpha:1, blurX:5, blurY:5, strength:5}});
			(e.currentTarget.buy as TextField).textColor = 0xFF0133;
		}
		
		protected function onDown(e:MouseEvent):void
		{
			TweenMax.to( e.currentTarget, 0.1, { scaleX: 0.98, scaleY: 0.98, glowFilter:{color:0x33ccff, alpha:1, blurX:5, blurY:5, strength:5}});
			(e.currentTarget.buy as TextField).textColor = 0xFF0133;
		}
		
		protected function onOut(e:MouseEvent):void
		{
			TweenMax.to( e.currentTarget, 0.1, { scaleX: 1, scaleY: 1, glowFilter:{color:0x33ccff, alpha:1, blurX:0, blurY:0, strength:0}});
			(e.currentTarget.buy as TextField).textColor = 0x9F3F03;
		}
		
		protected function onOver(e:MouseEvent):void
		{
			TweenMax.to( e.currentTarget, 0.1, { scaleX: 1.02, scaleY: 1.02, glowFilter:{color:0x33ccff, alpha:1, blurX:5, blurY:5, strength:5}});
			(e.currentTarget.buy as TextField).textColor = 0xFF0133;		
		}
		
		protected function paymentCall(e:MouseEvent):void
		{
			GameMusic.music.playSound( boxSoundType.SPurchaise );
			switch(e.currentTarget.name)
			{
				case "item_0":
					_count = Service.instance.purchaseModel[5].content_count;
					makePurchase(5);
					_unlimit = false;
					break;
				case "item_1":
					_count = Service.instance.purchaseModel[6].content_count;
					makePurchase(6);
					_unlimit = false;
					break;
				case "item_2":
					_count = Service.instance.purchaseModel[7].content_count;
					makePurchase(7);
					_unlimit = false;
					break;
				case "item_3":
					_count = Service.instance.purchaseModel[8].content_count;
					makePurchase(8);
					_unlimit = false;
					break;
				case "item_unlim":
					_count = Service.instance.purchaseModel[4].content_count;
					_unlimit = true;
					makePurchaseHard(4);
					break;
			}
		}
		
		private function makePurchase(bonusOrder:int):void
		{
			ServiceHandler.instance.softPurchase(this, function (res:*):void
			{
				if(res.response.message != "Not enough currency soft")
				{
					Service.instance.userModel.currencySoft -= Service.instance.purchaseModel[bonusOrder].price_soft;
					Service.instance.userModel.life.count += _count;
					Service.instance.userModel.life = Service.instance.userModel.life;
				}
				else
				{
					WindowsManager.instance.show( NotMoney );
				}
			}
				, Service.instance.userModel.playerId, Service.instance.purchaseModel[bonusOrder].purchase_id);		
		}
		
		private function makePurchaseHard(bonusOrder:int):void
		{
			ForticomAPI.showPayment(Service.instance.purchaseModel[bonusOrder].name,
						Service.instance.purchaseModel[bonusOrder].description,
						Service.instance.purchaseModel[bonusOrder].purchase_id,
						Service.instance.purchaseModel[bonusOrder].price_hard, null, null, null, 'true');
			
			ForticomAPI.addEventListener(ApiCallbackEvent.CALL_BACK, handleApiEvent);			
		}
		
		protected function handleApiEvent(event:ApiCallbackEvent):void
		{
			if(_unlimit) setUnlimitLife();
			else Service.instance.userModel.life.count += _count;
			
			ForticomAPI.removeEventListener(ApiCallbackEvent.CALL_BACK, handleApiEvent);
		}
		
		protected function close(event:MouseEvent):void
		{
			WindowsManager.instance.hide(null);
		}
		
		private function setUnlimitLife():void
		{
			Service.instance.userModel.life.is_unlimit = true;
		}
		
		private function destroy(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);	
			
			item_unlim.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			item_unlim.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			item_unlim.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			item_unlim.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			
			for (var i:int = 0; i < 4; i++) 
			{
				(this["item_" + i] as MovieClip).removeEventListener(MouseEvent.CLICK, paymentCall);				
				(this["item_" + i] as MovieClip).removeEventListener(MouseEvent.MOUSE_OVER, onOver);
				(this["item_" + i] as MovieClip).removeEventListener(MouseEvent.MOUSE_OUT, onOut);
				(this["item_" + i] as MovieClip).removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
				(this["item_" + i] as MovieClip).removeEventListener(MouseEvent.MOUSE_UP, onUp);
			}
		}
	}
}