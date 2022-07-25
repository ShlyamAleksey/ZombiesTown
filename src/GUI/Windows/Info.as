package GUI.Windows
{	
	import Services.Service;
	
	import Sounds.GameMusic;
	import Sounds.boxSoundType;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Info extends Info_win
	{
		static public var NEED_SHOW:Boolean = true;
		
		public function Info()
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
			
			//this.messageTF.text = Service.instance().bonusModel.message;
			this.friendRunsTF.text = String( Service.instance.bonusModel.currentRewardLifeCount );
			this.friendSoftTF.text = String( Service.instance.bonusModel.currentRewardCurrencySoft );
			this.bonusTF.text = String( Service.instance.bonusModel.dailyBonus );	
			GameMusic.music.playSound( boxSoundType.SWindowOpen);
		}
		
		protected function closeWindow(event:MouseEvent):void
		{					
			WindowsManager.instance.hide(showGift);
		}
		
		private function showGift():void
		{
			if(FriendGift.NEED_SHOW) WindowsManager.instance.show( FriendGift );
		}
		
		private function destroy(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);	
			closeBtn.removeEventListener(MouseEvent.CLICK, closeWindow);
			getBtn.removeEventListener(MouseEvent.CLICK, closeWindow);
		}
	}
}