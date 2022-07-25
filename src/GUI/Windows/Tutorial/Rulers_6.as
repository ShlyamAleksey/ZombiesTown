package GUI.Windows.Tutorial
{
	import GUI.Windows.WindowsManager;
	
	import Game.Logic.Pause;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Rulers_6 extends Tutorial_6
	{
		public function Rulers_6()
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
			
			Pause.stop = true;
		}
		
		protected function closeWindow(event:MouseEvent):void
		{
			WindowsManager.instance.hide();
		}
		
		private function destroy(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);	
			closeBtn.removeEventListener(MouseEvent.CLICK, closeWindow);
		}
	}
}