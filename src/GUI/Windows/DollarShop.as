package GUI.Windows
{
	import Connect.OK.ApiCallbackEvent;
	import Connect.OK.ForticomAPI;
	
	import Game.Logic.Pause;
	
	import Services.Service;
	
	import Sounds.GameMusic;
	import Sounds.boxSoundType;
	
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class DollarShop extends BuyDollars_GUI
	{
		private var _count:int = 0;
		private var __bonusArr:Array = [ 200, 100, 20, 10 ];
		
		public function DollarShop()
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
			
			Pause.stop = true;
			
			zombietown.instance.tracker.trackEvent("Зашли в банк","Банк");
			
			for (var i:int = 0; i < 4; i++) 
			{
				var pos:int = Service.instance.purchaseModel[i].description.indexOf("|");
				var _count:String = Service.instance.purchaseModel[i].description.slice(0, pos);
				var _bonus:String = Service.instance.purchaseModel[i].description.slice( pos + 1 );	
				
				(this["item_" + i] as MovieClip).addEventListener(MouseEvent.CLICK, paymentCall);
				
				(this["item_" + i] as MovieClip).addEventListener(MouseEvent.MOUSE_OVER, onOver);
				(this["item_" + i] as MovieClip).addEventListener(MouseEvent.MOUSE_OUT, onOut);
				(this["item_" + i] as MovieClip).addEventListener(MouseEvent.MOUSE_DOWN, onDown);
				(this["item_" + i] as MovieClip).addEventListener(MouseEvent.MOUSE_UP, onUp);
				
				this["item_" + i].softTF.text = _count;
				this["item_" + i].bonusTF.text = "Бонус +" + _bonus; 
				this["item_" + i].hardTF.text = "Купить       " + Service.instance.purchaseModel[i].price_hard + " Ок"; 
				
				this["item_" + i].mouseChildren = false;				
			}
			
			var sb:SimpleButton = new SimpleButton();
				sb.downState = new Sprite();
				//trace(sb.downState);
				GameMusic.music.playSound( boxSoundType.SWindowOpen);
				
		}
		
		protected function onUp(e:MouseEvent):void
		{
			TweenMax.to( e.currentTarget, 0.1, { scaleX: 1.02, scaleY: 1.02, glowFilter:{color:0x33ccff, alpha:1, blurX:5, blurY:5, strength:5}});
			(e.currentTarget.hardTF as TextField).textColor = 0xFF0133;
		}
		
		protected function onDown(e:MouseEvent):void
		{
			TweenMax.to( e.currentTarget, 0.1, { scaleX: 0.98, scaleY: 0.98, glowFilter:{color:0x33ccff, alpha:1, blurX:5, blurY:5, strength:5}});
			(e.currentTarget.hardTF as TextField).textColor = 0xFF0133;
		}
		
		protected function onOut(e:MouseEvent):void
		{
			TweenMax.to( e.currentTarget, 0.1, { scaleX: 1, scaleY: 1, glowFilter:{color:0x33ccff, alpha:1, blurX:0, blurY:0, strength:0}});
			(e.currentTarget.hardTF as TextField).textColor = 0x9F3F03;
		}
		
		protected function onOver(e:MouseEvent):void
		{
			TweenMax.to( e.currentTarget, 0.1, { scaleX: 1.02, scaleY: 1.02, glowFilter:{color:0x33ccff, alpha:1, blurX:5, blurY:5, strength:5}});
			(e.currentTarget.hardTF as TextField).textColor = 0xFF0133;		
		}	

		
		protected function paymentCall(e:MouseEvent):void
		{
			GameMusic.music.playSound( boxSoundType.SPurchaise );
			switch(e.currentTarget.name)
			{
				case "item_0":
					_count = Service.instance.purchaseModel[0].content_count;
					makePurchase(0);
					break;
				case "item_1":
					_count = Service.instance.purchaseModel[1].content_count;
					makePurchase(1);
					break;
				case "item_2":
					_count = Service.instance.purchaseModel[2].content_count;
					makePurchase(2);
					break;
				case "item_3":
					_count = Service.instance.purchaseModel[3].content_count;
					makePurchase(3);
					break;
			}
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
			Service.instance.userModel.currencySoft += _count;
			ForticomAPI.removeEventListener(ApiCallbackEvent.CALL_BACK, handleApiEvent);
		}
		
		protected function close(e:MouseEvent):void
		{
			WindowsManager.instance.hide();
		}
		
		private function destroy(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);	
			closeBtn.removeEventListener(MouseEvent.CLICK, close);
			
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