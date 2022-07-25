package GUI.Windows
{
	import Services.Service;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class FriendGift extends FriendGift_GUI
	{
		static public var NEED_SHOW:Boolean = false;
		
		public function FriendGift()
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
			getBtn.addEventListener(MouseEvent.CLICK, closeWindow);
			
			countTF.text = Service.instance.bonusModel.received_gifts.toString() + " монет";
			
			NEED_SHOW = false;
		}
		
		protected function closeWindow(event:MouseEvent):void
		{
			WindowsManager.instance.hide();
		}
		
		private function destroy(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);	
			closeBtn.removeEventListener(MouseEvent.CLICK, closeWindow);
			getBtn.removeEventListener(MouseEvent.CLICK, closeWindow);
		}
	}
}