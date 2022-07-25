package GlobalLogic
{
	import GUI.Panels.TopPanel;
	
	import Services.Service;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class LifeResp
	{
		public var timeLeft:String;
		
		private var _timer:Timer = new Timer(1000);
		private var _tc:TimeConverter;
		
		private var _callBack:Function;
		
		static public var START_ACTION_TIME:int;
		static public const ACTION_TIME:int = 60;
		
		static private var __init:LifeResp
		
		static public function get instance():LifeResp
		{
			if(!__init) __init = new LifeResp();
			return __init;
		}
		
		public function LifeResp()
		{
			
		}
		
		public function start(fun:Function):void
		{
			_callBack = fun;
			START_ACTION_TIME = Service.instance.userModel.life.time.sec;
			this._tc = new TimeConverter(ACTION_TIME + START_ACTION_TIME - ServerTime.TIME);
			timeLeft = _tc.minute + ":" + _tc.second;
			
			this._timer.addEventListener(TimerEvent.TIMER, onTimer);		
			this._timer.start();
		}
		
		protected function onTimer(event:TimerEvent):void
		{
			if(this._tc.value == 0)
			{
				Service.instance.userModel.life.count++;
				Service.instance.userModel.life = Service.instance.userModel.life;
				
				if(Service.instance.userModel.life.count >= TopPanel.LIFE_RESP_START_COUNT )
				{
					close(null);
					return;
				}
			}
			_tc.value = ACTION_TIME + START_ACTION_TIME - ServerTime.TIME;
			if( int(_tc.second) < 0 ) 
			{
				START_ACTION_TIME = ServerTime.TIME;
				_tc.value = ACTION_TIME + START_ACTION_TIME - ServerTime.TIME;
			}
			timeLeft = _tc.minute + ":" + _tc.second;
			//trace(timeLeft);
			_callBack.call();
			//trace(timeLeft);
		}
		
		protected function onTimerComplete(event:TimerEvent):void
		{
			close(null);
		}
		
		protected function close(event:MouseEvent):void
		{
			this._timer.removeEventListener(TimerEvent.TIMER, onTimer);	
			Service.instance.userModel.life = Service.instance.userModel.life;
		}
	}
}