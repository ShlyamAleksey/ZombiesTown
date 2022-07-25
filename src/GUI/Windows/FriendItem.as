package GUI.Windows
{
	import Connect.OK.ForticomAPI;
	import Connect.ServiceHandler;
	
	import Services.Service;
	
	import com.greensock.TweenMax;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class FriendItem extends FriendItem_GUI
	{
		private var __name:String;
		private var __image__url:String;
		public var canGift:int;
		private var _currentChooseUID:String;
		private var uid:String;
		//private var uid:int;
		private var __level:int;
		
		public function FriendItem(name:String, imageUrl:String, _uid:String, level:int)
		{
			super();
			this.__image__url = imageUrl;
			this.__name = name;
			this.uid = _uid;
			this.__level = level;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}

		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var item:ImageLoader = new ImageLoader(this.__image__url, this.img);
			this.nameTF.text = this.__name;
			this.levelTF.text = this.__level.toString();
			onAddedToPanel();
			
			for (var i:int = 0; i < Service.instance.friendsModel.length; i++) 
			{
				if(uid.toString() == Service.instance.friendsModel[i].playerId)
				{
					if(Service.instance.friendsModel[i].canGift == 0) 
					{
						sendBtn.mouseEnabled = false;
						TweenMax.to(sendBtn, 0.25, {colorMatrixFilter:{colorize:0xffffff, amount:1}});
					}
				}
			}
		}
		
		private function destroy(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);	
		}
		
		private function onAddedToPanel():void
		{
				addEventListener(MouseEvent.MOUSE_OVER, showTool);
				addEventListener(MouseEvent.MOUSE_OUT, hideTool);
				
				getBtn.visible = false;
				sendBtn.visible = false;
		}
		
		private function sendPrize(e:Event):void
		{
			for (var i:int = 0; i < Service.instance.friendsModel.length; i++) 
			{
				if(uid.toString() == Service.instance.friendsModel[i].playerId)
				{
					Service.instance.friendsModel[i].canGift = 0;
				}
			}
			
			
			sendBtn.mouseEnabled = false;
			TweenMax.to(sendBtn, 0.25, {colorMatrixFilter:{colorize:0xffffff, amount:1}});
			
			ServiceHandler.instance.sendPrize(this, onSend, Service.instance.userModel.playerId, _currentChooseUID );
		}
		
		private function onSend(res:*):void{}
		
		private function getPrize(e:Event):void
		{
			ForticomAPI.showNotification("Будь другом! Подари мне, пожалуйста, монет в игре!", null); 
		}
		
		protected function showTool(event:MouseEvent):void
		{
			getBtn.addEventListener(MouseEvent.CLICK, getPrize);
			sendBtn.addEventListener(MouseEvent.CLICK, sendPrize);
			
			getBtn.visible = true;
			sendBtn.visible = true;
			
			_currentChooseUID = uid.toString();
		}
		
		protected function hideTool(event:MouseEvent):void
		{
			getBtn.visible = false;
			sendBtn.visible = false;
			
			getBtn.removeEventListener(MouseEvent.CLICK, getPrize);
			sendBtn.removeEventListener(MouseEvent.CLICK, sendPrize);			
		}
	}
}