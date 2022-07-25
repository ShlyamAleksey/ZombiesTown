package GUI.Windows
{
	import Services.FriendModel;
	import Services.FriendsController;
	import Services.Service;
	
	import Sounds.GameMusic;
	import Sounds.boxSoundType;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class Friend extends Friend_GUI
	{
		private var _fl:Vector.<FriendModel> = Service.instance.friendsModel;
		private var _current__page:int = 0;
		private var _possArr:Vector.<Point> = new Vector.<Point>();
		
		public function Friend()
		{
			super();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			_possArr.push( new Point( -185, -270 ));
			_possArr.push( new Point( -57, -270 ));
			_possArr.push( new Point( 67, -270 ));
			_possArr.push( new Point( -185, -140 ));
			_possArr.push( new Point( -57, -140 ));
			_possArr.push( new Point( 67, -140 ));
			
			this.leftArrow.addEventListener(MouseEvent.CLICK, moveLeft);
			this.rightArrow.addEventListener(MouseEvent.CLICK, moveRight);
			this.closeBtn.addEventListener(MouseEvent.CLICK, closeWindow);
			
			pullItem();
			checkArrow();
			
			life.text = FriendsController.life_reward.toString();
			soft.text = FriendsController.soft_reward.toString();
			
			GameMusic.music.playSound( boxSoundType.SWindowOpen);
		}
		
		protected function moveRight(e:MouseEvent):void
		{
			_current__page++;
			clear();
			pullItem();
			checkArrow();
			
		}
		
		protected function moveLeft(e:MouseEvent):void
		{
			_current__page--;
			clear();
			pullItem();	
			checkArrow();
		}
		
		private function checkArrow():void
		{
			if( (_current__page + 1)*6 > _fl.length) 
			{
				rightArrow.visible = false;
			}else
			{
				rightArrow.visible = true;
			}
			
			if(_current__page == 0) leftArrow.visible = false;
			else leftArrow.visible = true;
		}
		
		private function pullItem():void
		{
			var length:int;
			if( (_current__page + 1)*6 <= _fl.length) length = 6;
			if( (_current__page + 1)*6 > _fl.length) 
			{
				length = _fl.length - _current__page*6;
			}
			
			for (var i:int = 0; i < length; i++) 
			{
				var fi:FriendItem = new FriendItem( _fl[i + _current__page*6].firstName,
													_fl[i + _current__page*6].picture,
													_fl[i + _current__page*6].playerId,
													_fl[i + _current__page*6].points + 1);
					fi.x = _possArr[i].x;
					fi.y = _possArr[i].y;
					this.addChild(fi); 	
			}
			
			if(length < 6)
			{
				for (var j:int = length; j < 6; j++) 
				{
					var ai:AddFriend_GUI = new AddFriend_GUI();
						ai.x = _possArr[j].x;
						ai.y = _possArr[j].y;
						addChild(ai);
						ai.addEventListener(MouseEvent.CLICK, openInvite);
				}
				
			}
		}
		
		protected function openInvite(event:MouseEvent):void
		{
			WindowsManager.instance.show( InviteFriend );
		}
		
		private function clear():void
		{
			for (var i:int = 0; i < numChildren; i++) 
			{
				if( this.getChildAt(i) is AddFriend_GUI ) this.getChildAt(i).removeEventListener(MouseEvent.CLICK, openInvite);
				
				if( this.getChildAt(i) is FriendItem ||
					this.getChildAt(i) is AddFriend_GUI ) removeChild( this.getChildAt(i) );
				
			}
		}

		protected function closeWindow(event:MouseEvent):void
		{					
			WindowsManager.instance.hide();
		}
		
		private function destroy(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);	
			this.leftArrow.removeEventListener(MouseEvent.CLICK, moveLeft);
			this.rightArrow.removeEventListener(MouseEvent.CLICK, moveRight);
			this.closeBtn.removeEventListener(MouseEvent.CLICK, closeWindow);
		}
	}
}