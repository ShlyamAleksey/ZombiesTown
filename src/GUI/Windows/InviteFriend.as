package GUI.Windows
{
	import Connect.OK.ForticomAPI;
	
	import Sounds.GameMusic;
	import Sounds.boxSoundType;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class InviteFriend extends InviteFriend_GUI
	{
		static public var ONCE:Boolean = true;
		
		public function InviteFriend()
		{
			super();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			sendInviteBtn.addEventListener(MouseEvent.CLICK, sendInvite);
			closeBtn.addEventListener(MouseEvent.CLICK, closeWindow);	
			
			ONCE = false;
			
			GameMusic.music.playSound( boxSoundType.SWindowOpen);
		}
		
		protected function sendInvite(e:MouseEvent):void
		{
			ForticomAPI.showInvite("Очень увлекательная игра! Заходи, будем играть вместе!"); 
		}
		
		protected function closeWindow(event:MouseEvent):void
		{
			WindowsManager.instance.hide();
		}
		
		private function destroy(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);	
			sendInviteBtn.removeEventListener(MouseEvent.CLICK, sendInvite);
			closeBtn.removeEventListener(MouseEvent.CLICK, closeWindow);	
		}
	}
}