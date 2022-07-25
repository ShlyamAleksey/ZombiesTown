package GUI.Windows
{
	import GUI.Screens.GameScreen;
	import GUI.Screens.MapScreen;
	import GUI.Screens.ScreenManager;
	
	import Game.Constants.Statics;
	import Game.Logic.Pause;
	
	import GlobalLogic.LevelManager;
	
	import Services.Service;
	
	import Sounds.GameMusic;
	import Sounds.boxSoundType;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Defeat extends Defeat_GUI
	{
		public function Defeat()
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
			toMapBtn.addEventListener(MouseEvent.CLICK, onClose);
			restartBtn.addEventListener(MouseEvent.CLICK, onRestart);
			Pause.stop = true;
			
			GameMusic.music.playMusic( boxSoundType.MDefeat );
			
			GameScreen.DEFEAT = true;
		}
		
		protected function onRestart(event:MouseEvent):void
		{
			WindowsManager.instance.hide(restart);
		}
		
		private function restart():void
		{
			if( Service.instance.userModel.life.count < 1 ) WindowsManager.instance.show( NotEnoughRun );
			else LevelManager.instance.enterGame( Statics.CURRENT_LEVEL );
		}
		
		protected function onClose(event:MouseEvent):void
		{
			WindowsManager.instance.hide(toMap);
		}
		
		private function toMap():void
		{
			ScreenManager.instance.show( MapScreen );
		}
		
		
		private function destroy(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);	
			closeBtn.removeEventListener(MouseEvent.CLICK, onClose);
			toMapBtn.removeEventListener(MouseEvent.CLICK, onClose);
		}	
	}
}