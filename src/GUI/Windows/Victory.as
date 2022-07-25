package GUI.Windows
{
	import Connect.Connection;
	import Connect.OK.ApiCallbackEvent;
	import Connect.OK.ForticomAPI;
	import Connect.OK.OKposter;
	import Connect.OK.SignUtil;
	
	import GUI.Panels.RightPanel;
	import GUI.Screens.GameScreen;
	import GUI.Screens.MapScreen;
	import GUI.Screens.ScreenManager;
	
	import Game.Constants.Statics;
	import Game.Logic.Pause;
	
	import Services.Service;
	import Services.User.UserModel;
	
	import Sounds.GameMusic;
	import Sounds.boxSoundType;
	
	import api.com.odnoklassniki.Odnoklassniki;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Victory extends Victory_GUI
	{
		private var tellFriends:Boolean = true;
		private var __um:UserModel;
		
		static public var ONCE:Boolean = false;
		
		public function Victory()
		{
			super();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			toMapBtn.addEventListener(MouseEvent.CLICK, gotoMap);
			closeBtn.addEventListener(MouseEvent.CLICK, gotoMap);
			
			rewardTF.text = Statics.CURRENT_LEVEL_MODEL.rewardCurrencySoft.toString();
			
			Service.instance.userModel.currencySoft += Statics.CURRENT_LEVEL_MODEL.rewardCurrencySoft;
			
			checkBox.addEventListener(MouseEvent.CLICK, setFlag);
			
			Pause.stop = true;
			
			this.fieldNameTF.text = "Вы построили " + RightPanel.FIELD_NAME;
			
			GameMusic.music.playMusic( boxSoundType.MVictory );
			
		//	ONCE = true;
		}
		
		public function getPermission():void 
		{
			Odnoklassniki.callRestApi("users.hasAppPermission" , requestStatusPermission, { ext_perm:'SET STATUS' }, "JSON", "POST" )
		}
		
		private function requestStatusPermission(response:*):void 
		{
			if (response) 
			{
				postPhoto();
			}
			else 
			{
				Odnoklassniki.showPermissions("SET PHOTO_CONTENT");
				ForticomAPI.addEventListener(ApiCallbackEvent.CALL_BACK, onStatusPermissionGranted);
			}
		}
		
		private function onStatusPermissionGranted(response:*):void 
		{
			if (response.result=="ok" && response.method == "showPermissions") 
			{
				postPhoto();
			}
		}
		
		private function postPhoto():void 
		{			
			var _okPoste:OKposter = new OKposter( GameScreen.instance.screenShot, Connection.USER_ID, "" );
		}
		
		protected function setFlag(e:MouseEvent):void
		{
			if( tellFriends )
			{
				checkBox.gotoAndStop( 2 );
				tellFriends = false;
			}
			else
			{
				checkBox.gotoAndStop( 1 );
				tellFriends = true;
			}
			
		}
		
		public function wallPost():void
		{
			ForticomAPI.addEventListener(ApiCallbackEvent.CALL_BACK, handleApiCallback);
			
			var request : Object = {method : "stream.publish", uid : 0, message : "Чудесно! Пройден " + String(Statics.CURRENT_LEVEL) + " уровень в игре ЗомбиTown"};
			request = SignUtil.signRequest(request, true);
			
			ForticomAPI.showConfirmation("stream.publish", "Чудесно! Пройден " + String(Statics.CURRENT_LEVEL) + " уровень в игре ЗомбиTown", request["sig"]);
			
			function handleApiCallback(event : ApiCallbackEvent):void
			{
				GameScreen.instance.snapScreenShot();
				getPermission();
				
				ForticomAPI.removeEventListener(ApiCallbackEvent.CALL_BACK, handleApiCallback);
				WindowsManager.instance.hide(showMap);
			}
		}
		
		protected function gotoMap(e:MouseEvent):void
		{
			if(tellFriends)
			{
				wallPost();
			}
			else
			{
				WindowsManager.instance.hide(showMap);
			
			}
		}
		
		private function showMap():void
		{
			ScreenManager.instance.show( MapScreen );
		}
		
		private function destroy(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);	
			toMapBtn.removeEventListener(MouseEvent.CLICK, gotoMap);
			closeBtn.removeEventListener(MouseEvent.CLICK, gotoMap);
			checkBox.removeEventListener(MouseEvent.CLICK, setFlag);
		}
	}
}