package GlobalLogic
{
	import Connect.ServiceHandler;
	
	import GUI.Screens.GameScreen;
	import GUI.Screens.MapScreen;
	import GUI.Screens.ScreenManager;
	import GUI.Windows.Defeat;
	import GUI.Windows.NotEnoughRun;
	import GUI.Windows.Victory;
	import GUI.Windows.WindowsManager;
	
	import Game.Constants.Statics;
	import Game.Model.FieldModel;
	
	import Services.Levels.LevelModel;
	import Services.Service;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class LevelManager
	{
		private var _target:Sprite;
		private var __enter__level:int;
		private var __lifeOnStart:int;
		
		static public var lifeToSave:int = 0;
		
		static public var PLAY_ONE_LEVEL:Boolean = false;
		
		static private var _init:LevelManager;
		static public function get instance():LevelManager { return _init; }
		
		public function LevelManager(target:MovieClip)
		{
			_init = this;
			_target = target;
			for (var i:int = 0; i < _target.numChildren; i++) 
			{
				if( _target.getChildAt(i) is levelPoints) _target.getChildAt(i).addEventListener(MouseEvent.CLICK, onClickLvl);
			}
		}
		
		protected function onClickLvl(e:MouseEvent):void
		{
			if(Service.instance.userModel.life.count < 1)
			{
				WindowsManager.instance.show( NotEnoughRun );
				return;
			}
			var lvl:* = int((e.currentTarget.name as String).slice(4, 6));
				enterGame(lvl);
		}
		
		public function enterGame(level:int):void
		{
			
			for each (var i:LevelModel in Service.instance.levelModel) 
			{
				if(i.name == level.toString())
				{
					ServiceHandler.instance.startLevel(this, onStartLevel, Service.instance.userModel.playerId, i.levelId);
					Statics.CURRENT_LEVEL = level;
					Statics.CURRENT_LEVEL_MODEL = i;
					break;
				}
			}
		}
		
		private function onStartLevel(res:*):void
		{
			if(res.status == "ok")
			{
				zombietown.instance.tracker.trackEvent("Начали " + Statics.CURRENT_LEVEL + " уровень", "Уровни");
				ScreenManager.instance.show( GameScreen );
				__lifeOnStart = Service.instance.userModel.life.count;
			}			
		}
		
		public function onEndLevel(isWin:int, back:Boolean = false):void
		{
 			ServiceHandler.instance.endLevel(	this, 
												function (res:*):void
												{ 
													zombietown.instance.tracker.trackEvent("Закончили " + Statics.CURRENT_LEVEL + " уровень", "Уровни");
													if(isWin == 1)
													{
														Service.instance.userModel.levelProgress.push( { points : Service.instance.userModel.points })
														
														WindowsManager.instance.show( Victory );
														Service.instance.userModel.points = 0;
//														cleanSavedProgress();
													}
													if(isWin == 0 && !back)
													{
														WindowsManager.instance.show( Defeat );
														Service.instance.userModel.points = 0;
														Service.instance.userModel.life.time.sec = res.response.player.life.time.sec;
//														cleanSavedProgress();
													}
													if(isWin == 0 && back)
													{
														ScreenManager.instance.show( MapScreen );															
													}
												},
												Service.instance.userModel.playerId,
												Service.instance.levelModel[Statics.CURRENT_LEVEL - 1].levelId,
												__lifeOnStart - Service.instance.userModel.life.count, Service.instance.userModel.points, isWin);
			trace("count ",  __lifeOnStart - Service.instance.userModel.life.count);
			
			PLAY_ONE_LEVEL = true;
		}
		
		private function cleanSavedProgress():void
		{
			ServiceHandler.instance.saveLevel(	this, onSaveComplete,
												Service.instance.userModel.playerId, true, null, 0);
		}
		
		private function onSaveComplete(res:*):void
		{
			Service.instance.userModel.currentLevelsProgress = [];
			
		}
		
		public function destroy():void
		{
			for (var i:int = 0; i < _target.numChildren; i++) 
			{
				if( _target.getChildAt(i) is levelPoints) _target.getChildAt(i).removeEventListener(MouseEvent.CLICK, onClickLvl);
			}
		}
	}
}