package GUI.Screens
{
	import Connect.Connection;
	import Connect.OK.ForticomAPI;
	import Connect.ServerConnect;
	import Connect.ServiceHandler;
	
	import GUI.Panels.TopPanel;
	import GUI.Windows.Friend;
	import GUI.Windows.FriendGift;
	import GUI.Windows.InviteFriend;
	import GUI.Windows.Publish;
	import GUI.Windows.TopPlayer;
	import GUI.Windows.Tutorial.Rulers_1;
	import GUI.Windows.Victory;
	import GUI.Windows.Weekend;
	import GUI.Windows.WindowsManager;
	
	import Game.Constants.Statics;
	import Game.Logic.Pause;
	import Game.Model.ItemsModel;
	
	import GlobalLogic.FriendOnMap;
	import GlobalLogic.LevelManager;
	
	import Services.Service;
	import Services.User.UserModel;
	
	import Sounds.GameMusic;
	import Sounds.boxSoundType;
	
	import api.com.odnoklassniki.Odnoklassniki;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.sensors.Accelerometer;
	import flash.ui.Keyboard;
	import flash.utils.flash_proxy;

	public class MapScreen extends MapScreen_GUI
	{
		static private var _init:MapScreen;
		static public function get instance():MapScreen { return _init; }
		
		private var __level__manager:LevelManager;
		private var __um:UserModel;
		
		private var __randID:String;
		
		private var notInviteFriends:Array = new Array();
		private var __friendOnMap:FriendOnMap;
		
		public function MapScreen()
		{
			super();
			_init = this;
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addChild(new TopPanel());
			this.topBtn.addEventListener(MouseEvent.CLICK, onTop);
			this.friendBtn.addEventListener(MouseEvent.CLICK, openFriend);
			this.groupBtn.addEventListener(MouseEvent.CLICK, gotoGroup);
			
			Pause.stop = false;
			this.__level__manager = new LevelManager(backGround.mapList);
			
			setupBuilds();
			showInvite();
			showFriendItem();

			if (GUI.Windows.Info.NEED_SHOW) 
			{
				WindowsManager.instance.show(GUI.Windows.Info);
				GUI.Windows.Info.NEED_SHOW = false;
			}
			
			if(FriendGift.NEED_SHOW)
			{ 
				WindowsManager.instance.show( FriendGift );
			}	
			
			GameMusic.music.playMusic( boxSoundType.MMapBackGround );
			Victory.ONCE = false; //жесткий костыль
			ItemsModel.STORAGE = 0; //Чтоб склад чистился в новом уровне	
			
			__friendOnMap = new FriendOnMap(this);
			
			if(!Weekend.SHOW_ONCE_FLAG &&
				ServerTime.TIME > Weekend.START_ACTION_TIME &&
				ServerTime.TIME < Weekend.START_ACTION_TIME + Weekend.ACTION_TIME)
			{
				WindowsManager.instance.show( Weekend );
				Weekend.SHOW_ONCE_FLAG = true;
			}
		}
		
		private function showFriendItem():void
		{
			Odnoklassniki.callRestApi( "friends.get" , _getFriends, { uids:Odnoklassniki.session.uid}, "JSON", "POST" );
		}
		
		private function _getFriends(res:*):void
		{
			var fields:String = "uid, first_name, last_name, pic_1";
			
			getRandomUID(res);
			
			Odnoklassniki.callRestApi( "users.getInfo" , _getUsersInfo, { uids:__randID , fields:fields }, "JSON", "POST" );
		}
		
		private function getRandomUID(res:*):void
		{
			__randID = res[ int(Math.random()*res.length) ];
			
			for (var i:int = 0; i < Service.instance.friendsModel.length; i++) 
			{
				if(Service.instance.friendsModel[i].uid.toString() == __randID)
				{
					getRandomUID(res);
					break;
				}
			}
		}
		
		private function _getUsersInfo(res:*):void
		{
			if(res)
			{
				if(res[0].pic_1)
				{
					var _avatar:String = res[0].pic_1;
					var _il:ImageLoader = new ImageLoader(_avatar, this.frienItem.img);
				}
				
				if(res[0].first_name) var _firstName:String = res[0].first_name;
				if(res[0].last_name) var _lastName:String = res[0].last_name;
				
				 
				this.frienItem.sendBtn.addEventListener(MouseEvent.CLICK, showInviteOK)
			}
		}
		
		private function showInviteOK(e:MouseEvent):void
		{
			
			ForticomAPI.showInvite("Очень увлекательная игра! Заходи, будем играть вместе!"); 		
		}
		
		private function showInvite():void
		{
			if(LevelManager.PLAY_ONE_LEVEL && InviteFriend.ONCE) WindowsManager.instance.show( InviteFriend );
		}
		
		private function setupBuilds():void
		{
			 
			__um = Service.instance.userModel;
			for (var i:int = 0; i < __um.levelProgress.length; i++) 
			{
				if(i < 9) backGround.mapList["lvl_0" + int(i + 1)].gotoAndStop(getPointsType(i) + 1);
				if(i >= 9) backGround.mapList["lvl_" + int(i + 1)].gotoAndStop(getPointsType(i) + 1);	
			}
		
			if(__um.levelProgress.length < 9) backGround.mapList["lvl_0" + int(__um.levelProgress.length + 1)].gotoAndStop(5);
			if(__um.levelProgress.length >= 9) backGround.mapList["lvl_" + int(__um.levelProgress.length + 1)].gotoAndStop(5);
		}
		
		
		private function gotoGroup(arg1:flash.events.Event):void
		{
			var loc1:*=new URLRequest("http://www.odnoklassniki.ru/group/56926107795488");
			flash.net.navigateToURL(loc1);
			return;
		}
		
		
		private function getPointsType(level:int):int
		{
			var reg:int = Service.instance.levelModel[level].reguiredPoints;

				if(__um.levelProgress[level].points >= reg && __um.levelProgress[level].points < 10000)
				{
					return 1;
				}
				else if(__um.levelProgress[level].points >= 10000 && __um.levelProgress[level].points < 20000)
				{
					return 2;
				}
				else if(__um.levelProgress[level].points >= 20000 && __um.levelProgress[level].points < 50000)
				{
					return 3;
				}
			
			return 0;
		}
		
		protected function openFriend(event:MouseEvent):void
		{
			WindowsManager.instance.show( Friend );
		}
		
		private function getResult(res:*):void
		{
			TopPlayer.resp = res;			
			WindowsManager.instance.show( TopPlayer )
		}
		
		protected function onTop(event:MouseEvent):void
		{
			ServiceHandler.instance.topPage(this, getResult, ServerConnect.SOCIAL_ID, 7, 0);
		}
		
		private function destroy(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);	
			this.topBtn.removeEventListener(MouseEvent.CLICK, onTop);
			this.friendBtn.removeEventListener(MouseEvent.CLICK, openFriend);
			this.groupBtn.removeEventListener(MouseEvent.CLICK, gotoGroup);
			this.frienItem.sendBtn.removeEventListener(MouseEvent.CLICK, showInviteOK)
			this.__level__manager.destroy();
			__friendOnMap.destroy();
		}
	}
}