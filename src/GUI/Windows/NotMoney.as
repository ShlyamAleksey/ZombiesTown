package GUI.Windows
{
	import Sounds.GameMusic;
	import Sounds.boxSoundType;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class NotMoney extends NotMoney_GUI
	{
		public function NotMoney()
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
			shopBtn.addEventListener(MouseEvent.CLICK, openShop);
			
			GameMusic.music.playSound( boxSoundType.SWindowOpen);
		}
		
		protected function openShop(event:MouseEvent):void
		{
			WindowsManager.instance.hide(shop);
		}
		
		protected function shop():void
		{
			WindowsManager.instance.show( DollarShop );	
		}
		
		protected function closeWindow(event:MouseEvent):void
		{	
			WindowsManager.instance.hide();
		}
		
		private function destroy(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);	
			closeBtn.removeEventListener(MouseEvent.CLICK, closeWindow);
			shopBtn.removeEventListener(MouseEvent.CLICK, openShop);
		}
	}
}