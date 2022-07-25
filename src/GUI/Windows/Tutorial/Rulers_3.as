package GUI.Windows.Tutorial
{
	import GUI.Windows.WindowsManager;
	
	import Game.Logic.Pause;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Rulers_3 extends Tutorial_3
	{
		public function Rulers_3()
		{
			super();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
						
			Pause.stop = true;
		}
		
		protected function closeWindow(event:MouseEvent):void
		{
			WindowsManager.instance.hide();
		}
		
		protected function onClick(event:MouseEvent):void
		{
			WindowsManager.instance.hide(openNext);
			
		}
		
		private function openNext():void
		{
			WindowsManager.instance.show( Rulers_4 );
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			closeBtn.addEventListener(MouseEvent.CLICK, closeWindow);
			nextBtn.addEventListener(MouseEvent.CLICK, onClick);

		}
		
		private function destroy(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);	
			closeBtn.removeEventListener(MouseEvent.CLICK, closeWindow);
			nextBtn.removeEventListener(MouseEvent.CLICK, onClick);
		}
	}
}