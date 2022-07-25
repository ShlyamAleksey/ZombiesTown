package GUI.Windows
{
	import Connect.OK.ApiCallbackEvent;
	import Connect.OK.ForticomAPI;
	
	import GUI.Screens.GameScreen;
	
	import GlobalLogic.TimeConverter;
	
	import Services.Service;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Weekend extends Weekend_GUI
	{
		static public var SHOW_ONCE_FLAG:Boolean = false;
		static public const START_ACTION_TIME:int = 1397247884;
		//		static public const START_ACTION_TIME:int = 1395414000;
		static public const ACTION_TIME:int = 86400*2;
		private var _lifeLine:int = 10;
		private var _leafLine:int = 0;
		
		private var _count:int = 0;
		private var _timer:Timer = new Timer(1000);
		private var _tc:TimeConverter;
		
		private var _unlimit:Boolean = false;
		
		public function Weekend()
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
			buyBtn.addEventListener(MouseEvent.CLICK, paymentCall);
			
			this._tc = new TimeConverter(ACTION_TIME + START_ACTION_TIME - ServerTime.TIME);
			
			timeLeftTF.text = _tc.hour2 + ":" + _tc.minute + ":" + _tc.second;
			
			this._timer.addEventListener(TimerEvent.TIMER, onTimer);
			
			this._timer.start();
		}
		
		protected function onTimerComplete(event:TimerEvent):void
		{
			close(null);
		}
		
		protected function onTimer(event:TimerEvent):void
		{
			if(this._tc.value <= 1)
			{
				close(null);
				return;
			}
			_tc.value = ACTION_TIME + START_ACTION_TIME - ServerTime.TIME;
			timeLeftTF.text = _tc.hour2 + ":" + _tc.minute + ":" + _tc.second;
			
		}		
		
		private  var __purchaseName:String;
		private function paymentCall(e:MouseEvent):void
		{
			switch(e.currentTarget.name)
			{
				case "buyBtn":
					_count = Service.instance.purchaseModel[4].content_count;
					_unlimit = true;
					makePurchaseHard(4);
					break;
			}
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
		
		private function setUnlimitLife():void
		{
			Service.instance.userModel.life.is_unlimit = true;
		}
		
		protected function close(event:MouseEvent):void
		{
			WindowsManager.instance.hide(null);
		}
		
		private function destroy(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);	
			closeBtn.removeEventListener(MouseEvent.CLICK, close);
			_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			
			buyBtn.removeEventListener(MouseEvent.CLICK, paymentCall);	
		}
	}
}