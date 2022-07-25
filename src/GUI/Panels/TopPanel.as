package GUI.Panels
{
	import Connect.ServiceHandler;
	
	import Events.GameEvent;
	import Events.ServiceEvent;
	
	import GUI.Screens.GameScreen;
	import GUI.Screens.MapScreen;
	import GUI.Screens.ScreenManager;
	import GUI.Windows.DollarShop;
	import GUI.Windows.LittleRuns;
	import GUI.Windows.RunShop_Win;
	import GUI.Windows.Tutorial.Rulers_1;
	import GUI.Windows.WindowsManager;
	
	import Game.Constants.Statics;
	import Game.Model.FieldModel;
	
	import GlobalLogic.LevelManager;
	import GlobalLogic.LifeResp;
	
	import Services.Service;
	import Services.User.UserModel;
	
	import Sounds.GameMusic;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Timer;

	public class TopPanel extends TopPanel_GUI
	{
		private var __um:UserModel;
		static private var _unlimit_timer:Timer = new Timer(1000);
		
		static public var LIFE_RESP_START_COUNT:int = 150;
		
		private var __lifeResp:LifeResp;
		private var __lifeOnStart:int;
		private var __lifeLast:int;
		
		
		public function TopPanel()
		{
			super();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			this.buyRunBtn.addEventListener(MouseEvent.CLICK, showRunsShop);
			this.buySoftBtn.addEventListener(MouseEvent.CLICK, showSoftShop);
			this.backBtn.addEventListener(MouseEvent.CLICK, backToMap);
			this.soundBtn.addEventListener(MouseEvent.CLICK, mute);
			this.helpBtn.addEventListener(MouseEvent.CLICK, openHelp);
			
			this.__um = Service.instance.userModel;
			this.__um.addEventListener( ServiceEvent.USER_SERVICE, update);
			ServerTime.instance.addEventListener(GameEvent.SERVER_TIME, getUnlimitTime);
			this.unlimit.visible = false;
			
			__lifeLast = this.__um.life.count;
			
			if(Service.instance.userModel.life.is_unlimit) 
			{
				this.lifeTF.visible = false;
				this.unlimit.visible = true;
			}
			else this.lifeTF.text = __um.life.count;
			
			this.softTF.text = Service.instance.userModel.currencySoft.toString();
			this.soundBtn.visible = true;
			
			if(ScreenManager.instance.screenName == MapScreen) backBtn.visible = false;
			if(ScreenManager.instance.screenName == GameScreen) levelMC.visible = false;
			
			if(Service.instance.userModel.life.count < LIFE_RESP_START_COUNT) LifeResp.instance.start( updateTimer );
			
			respMc.visible = false;
			
			if(!GameMusic.music.mute) soundBtn.gotoAndStop(2);
			
			__lifeOnStart = Service.instance.userModel.life.count;
			
			
			if(Statics.CURRENT_LEVEL == 0) levelMC.levelTF.text = this.__um.completedLevelIds.length + 1;
			else levelMC.levelTF.text = Statics.CURRENT_LEVEL;
			
//			levelMC.levelTF.text = Statics.CURRENT_LEVEL;
		}
		
		private function updateTimer():void
		{
			respMc.visible = true;
			respMc.timeTF.text = LifeResp.instance.timeLeft;
		}
		
		protected function openHelp(event:MouseEvent):void
		{
			WindowsManager.instance.show( Rulers_1 ); 
		}
		
		private function mute(e:MouseEvent):void
		{
			
			if(GameMusic.music.mute)
			{
				GameMusic.music.allOff();
				soundBtn.gotoAndStop(2);
			}
			else
			{
				GameMusic.music.allOn();
				soundBtn.gotoAndStop(1);
			}
		}
		
		protected function backToMap(event:MouseEvent):void
		{
			LevelManager.instance.onEndLevel(0, true);
//			ServiceHandler.instance.saveLevel(	this, onSaveComplete,
//												Service.instance.userModel.playerId, false,
//												FieldModel.instance.field,
//												/*__lifeOnStart - Service.instance.userModel.life.count*/0,
//												Service.instance.userModel.points);
		}
		
		private function onSaveComplete(res:*):void
		{
			this.__um.currentLevelsProgress.points = res.response.player.current_level_progress.points;
			this.__um.currentLevelsProgress.life_count = res.response.player.current_level_progress.life_count;
			this.__um.currentLevelsProgress.field = res.response.player.current_level_progress.field;
		}	
		
		protected function showSoftShop(event:MouseEvent):void
		{
			WindowsManager.instance.show(DollarShop);
		}
		
		protected function update(event:Event):void
		{
			if(__um.life.count == 20 && !LittleRuns.IS_OPEN)
			{
				if(ScreenManager.instance.screenName == GameScreen) WindowsManager.instance.show( LittleRuns );		
			}
			
			if(__lifeLast != this.__um.life.count)
			{
				if(__lifeLast > this.__um.life.count && this.__um.life.count == (LIFE_RESP_START_COUNT - 1))
				{
					LifeResp.instance.start( updateTimer );
				}
				
				if(this.__um.life.count == LIFE_RESP_START_COUNT) respMc.visible = false;
				LifeResp.START_ACTION_TIME = ServerTime.TIME;
				Service.instance.userModel.life.time.sec = ServerTime.TIME;
				__lifeLast = this.__um.life.count;
			}

			if(Service.instance.userModel.life.is_unlimit) 
			{
				this.lifeTF.visible = false;
				this.unlimit.visible = true;
			}
			else this.lifeTF.text = __um.life.count;
			
			this.softTF.text = Service.instance.userModel.currencySoft.toString();
		}
		
		private function getUnlimitTime(e:Event):void
		{
			if(ServerTime.TIME > Service.instance.userModel.life.unlimit_time.sec)
			{
				Service.instance.userModel.life.is_unlimit = false;
				ServerTime.instance.removeEventListener(GameEvent.SERVER_TIME, getUnlimitTime);
				update(null);
			}
		}
		
		protected function showRunsShop(e:MouseEvent):void
		{
			WindowsManager.instance.show(RunShop_Win);
		}
		
		private function destroy(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);	
			
			ServerTime.instance.removeEventListener(GameEvent.SERVER_TIME, getUnlimitTime);
			this.__um.removeEventListener( ServiceEvent.USER_SERVICE, update);
			this.buyRunBtn.removeEventListener(MouseEvent.CLICK, showRunsShop);
			this.buySoftBtn.removeEventListener(MouseEvent.CLICK, showSoftShop);
			this.backBtn.removeEventListener(MouseEvent.CLICK, backToMap);
			this.helpBtn.removeEventListener(MouseEvent.CLICK, openHelp);
		}
	}
}