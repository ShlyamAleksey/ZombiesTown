package GUI.Windows.Tutorial
{
	import GUI.Windows.WindowsManager;
	
	import Game.Logic.Pause;
	
	import Services.Service;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Rulers_1 extends Tutorial_1
	{
		static public var TUTORIAL:Boolean = true;
		
		public function Rulers_1()
		{
			super();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			closeBtn.addEventListener(MouseEvent.CLICK, closeWindow);
			nextBtn.addEventListener(MouseEvent.CLICK, onClick);
			
			Pause.stop = true;
			TUTORIAL = false;
			
			zombietown.instance.tracker.trackEvent("Открыли помощь","Обучение");
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
			if(Service.instance.userModel.entryCount == 1) WindowsManager.instance.show( Rulers_2 );
			if(Service.instance.userModel.entryCount != 1) WindowsManager.instance.show( Rulers_23 );
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function destroy(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);	
			closeBtn.removeEventListener(MouseEvent.CLICK, closeWindow);
			nextBtn.removeEventListener(MouseEvent.CLICK, onClick);
		}
	}
}