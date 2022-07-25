package GUI.Windows
{
	import GUI.Screens.MapScreen;
	import GUI.Screens.ScreenManager;
	
	import Game.Logic.Pause;
	
	import Sounds.GameMusic;
	import Sounds.boxSoundType;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class NotEnoughRun extends NotEnoughRuns_GUI
	{
		public function NotEnoughRun()
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
			runShopBtn.addEventListener(MouseEvent.CLICK, onRun);
			Pause.stop = true;
			
			GameMusic.music.playSound( boxSoundType.SWindowOpen);
		}
		
		protected function onRun(e:MouseEvent):void
		{
			WindowsManager.instance.hide(toShop);
			
		}
		
		private function toShop():void
		{
			ScreenManager.instance.show( MapScreen );
			WindowsManager.instance.show(RunShop_Win);
		}
		
		protected function onClose(e:MouseEvent):void
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
			runShopBtn.removeEventListener(MouseEvent.CLICK, onRun);
		}	
	}
}