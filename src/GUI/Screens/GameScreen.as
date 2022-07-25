package GUI.Screens
{
	import Connect.Connection;
	import Connect.OK.ApiCallbackEvent;
	import Connect.OK.ForticomAPI;
	import Connect.OK.OKposter;
	import Connect.ServiceHandler;
	
	import Events.GameEvent;
	import Events.ServiceEvent;
	
	import GUI.InteractiveTutorial.Tutorial;
	import GUI.Panels.RightPanel;
	import GUI.Panels.TopPanel;
	import GUI.Windows.Chance;
	import GUI.Windows.ItemsShop;
	import GUI.Windows.NotMoney;
	import GUI.Windows.TargetWindow;
	import GUI.Windows.WindowsManager;
	
	import Game.Constants.ItemsConstant;
	import Game.Logic.ComboHelper;
	import Game.Logic.ComboHelperCristal;
	import Game.Logic.FieldChecker;
	import Game.Logic.Pause;
	import Game.Logic.Undo;
	import Game.Model.FieldModel;
	import Game.Model.ItemsModel;
	import Game.UI.DropItemUI;
	import Game.UI.FieldUI;
	import Game.UI.HelperUI;
	import Game.UI.NinjaUI;
	import Game.UI.RoadUI;
	import Game.UI.ZombieUI;
	import Game.Utils;
	
	import GlobalLogic.LevelManager;
	
	import Services.Service;
	import Services.User.UserModel;
	
	import Sounds.GameMusic;
	import Sounds.boxSoundType;
	
	import api.com.odnoklassniki.Odnoklassniki;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.ui.Keyboard;

	public class GameScreen extends MainField_GUI
	{
		static private var _init:GameScreen;
		static public function get instance():GameScreen { return _init; }
		
		private var __field:FieldModel = new FieldModel();
		private var __um:UserModel;
		
		public var screenShot:Bitmap;
		private var purchase_name:String;
		
		public var lifeOnstart:int;
		
		
		static public var DEFEAT:Boolean = false;
		
		public function GameScreen()
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
			__um = Service.instance.userModel;
			__um.addEventListener(ServiceEvent.USER_SERVICE, onUpdateUser);
			
			stage.addEventListener( MouseEvent.CLICK, onFieldClick);
			
			GameScreen.instance.helper.visible = false;
			initField();
			addChild( new TopPanel() );
			createRightPanel();
			createBottomPanel();
			
			GameMusic.music.playMusic( boxSoundType.MPlayBackground );
			
			if(!Tutorial.STATUS) WindowsManager.instance.show( TargetWindow );
			
			lifeOnstart = __um.life.count;
		}
		
		private function createBottomPanel():void
		{
			setupButton(buy_item_1, 1, Service.instance.purchaseModel[13].price_hard.toString());
			setupButton(buy_item_2, 1, Service.instance.purchaseModel[12].price_hard.toString());
			setupButton(buy_item_3, 1, Service.instance.purchaseModel[11].price_hard.toString());
			setupButton(buy_item_4, 1, Service.instance.purchaseModel[10].price_hard.toString());
			
			for (var i:int = 0; i < 4; i++) 
			{
				this["buy_item_" + int(i + 1) ].addEventListener(MouseEvent.CLICK, paymentCall);
			}	
		}
		
		protected function paymentCall(e:MouseEvent):void
		{
			GameMusic.music.playSound( boxSoundType.SPurchaise );
			switch(e.currentTarget.name)
			{ 
				case "buy_item_4":
					makePurchase(10);
					break;
				case "buy_item_2":
					makePurchase(12);
					break;
				case "buy_item_3":
					makePurchase(11);
					break;
				case "buy_item_1":
//					if(Tutorial.STATUS) Tutorial.main.step_17();
//					else makePurchase(13);
					makePurchase(13);
					break;
			}
			
			purchase_name = e.currentTarget.name;
		}
		
		private function makePurchase(bonusOrder:int):void
		{
			
			ForticomAPI.showPayment(Service.instance.purchaseModel[bonusOrder].name,
				Service.instance.purchaseModel[bonusOrder].description,
				Service.instance.purchaseModel[bonusOrder].purchase_id,
				Service.instance.purchaseModel[bonusOrder].price_hard, null, null, null, 'true');
			
			ForticomAPI.addEventListener(ApiCallbackEvent.CALL_BACK, handleApiEvent);
			
			function handleApiEvent(event:Event):void
			{
				onItemBuy(purchase_name);
				FieldModel.instance.dispatchGameEvent(GameEvent.CHANGE_FIELD);
				//WindowsManager.instance.hide();
				
				//Service.instance.userModel.currencySoft -= Service.instance.purchaseModel[bonusOrder].price_soft;
				ForticomAPI.removeEventListener(ApiCallbackEvent.CALL_BACK, handleApiEvent);
			}
			
			function onItemBuy(purchase_name:String):void
			{
				switch(purchase_name)
				{
					case "buy_item_4":
						ItemsModel.BUY__ITEM = true;
						ItemsShop.BOUGHT_ITEM = ItemsConstant.TYPE_CRISTAL;
						DropItemUI.TYPE = ItemsShop.BOUGHT_ITEM;
						break;
					case "buy_item_2":
						ItemsModel.BUY__ITEM = true;
						ItemsShop.BOUGHT_ITEM = ItemsConstant.TYPE_TREE;
						DropItemUI.TYPE = ItemsShop.BOUGHT_ITEM;
						break;
					case "buy_item_3":
						ItemsModel.BUY__ITEM = true;
						ItemsShop.BOUGHT_ITEM = ItemsConstant.TYPE_BOT;
						DropItemUI.TYPE = ItemsShop.BOUGHT_ITEM;
						break;
					case "buy_item_1":
						ItemsModel.BUY__ITEM = true;
						ItemsShop.BOUGHT_ITEM = ItemsConstant.TYPE_BUSH;
						DropItemUI.TYPE = ItemsShop.BOUGHT_ITEM;
						break;
				}
			}
			
//			ServiceHandler.instance.softPurchase(this, function (res:*):void
//			{
//				if(res.response.message != "Not enough currency soft")
//				{
//					switch(purchase_name)
//					{
//						case "buy_item_4":
//							ItemsModel.BUY__ITEM = true;
//							ItemsShop.BOUGHT_ITEM = ItemsConstant.TYPE_CRISTAL;
//							DropItemUI.TYPE = ItemsShop.BOUGHT_ITEM;
//							break;
//						case "buy_item_2":
//							ItemsModel.BUY__ITEM = true;
//							ItemsShop.BOUGHT_ITEM = ItemsConstant.TYPE_TREE;
//							DropItemUI.TYPE = ItemsShop.BOUGHT_ITEM;
//							break;
//						case "buy_item_3":
//							ItemsModel.BUY__ITEM = true;
//							ItemsShop.BOUGHT_ITEM = ItemsConstant.TYPE_BOT;
//							DropItemUI.TYPE = ItemsShop.BOUGHT_ITEM;
//							break;
//						case "buy_item_1":
//							ItemsModel.BUY__ITEM = true;
//							ItemsShop.BOUGHT_ITEM = ItemsConstant.TYPE_BUSH;
//							DropItemUI.TYPE = ItemsShop.BOUGHT_ITEM;
//							break;
//					}
//					FieldModel.instance.dispatchGameEvent(GameEvent.CHANGE_FIELD);
//					
//					Service.instance.userModel.currencySoft -= Service.instance.purchaseModel[bonusOrder].price_soft;
//				}
//				else
//				{
//					WindowsManager.instance.show( NotMoney );
//				}
//			}
//				, Service.instance.userModel.playerId, Service.instance.purchaseModel[bonusOrder].purchase_id);		
		}
		
		private function setupButton(btn:SimpleButton, pos:int, text:String):void
		{
			((btn.downState as Sprite).getChildAt(pos) as TextField).text = text + " ok";
			((btn.overState as Sprite).getChildAt(pos) as TextField).text = text + " ok";
			((btn.upState as Sprite).getChildAt(pos) as TextField).text = text + " ok";
		}
		
		protected function onFieldClick(event:MouseEvent):void
		{
			if(Pause.stop) return;
			
			if(FieldChecker.FULL_FIELD) 
			{
				
				FieldModel.instance.dispatchGameEvent(GameEvent.CHANGE_FIELD);
				
				HelperUI.instance.gotoAndStop(1);
			}
		}
		
		protected function onUpdateUser(e:Event):void
		{
			if(__um.life.count == 0)
			{
				DropItemUI.PAID_RUN = true;
				HelperUI.instance.gotoAndStop(3);
				//if(!Chance.ONCE && !DEFEAT) WindowsManager.instance.show( Chance );
			}	
		}
		
		private function createRightPanel():void
		{
			var _rp:RightPanel = new RightPanel(__field);
			addChild( _rp );
		}
		
		public function snapScreenShot():void
		{
			var _bd:BitmapData = new BitmapData(560, 560);
			var _matrix:Matrix = new Matrix();
			_matrix.tx = -18;
			_matrix.ty = -104;
			_bd.draw(this, _matrix);
			screenShot = new Bitmap(_bd);
		}
		
		
		/**Создаем игровое поле*/
		private function initField():void
		{	
			__field.height = 6;
			__field.width = 6;
			
			var __fieldUI:FieldUI = new FieldUI(__field);
			var __roadUI:RoadUI = new RoadUI(__field);
			var __zombieUI:ZombieUI = new ZombieUI(__field);
			var __ninjaUI:NinjaUI = new NinjaUI(__field);
			var __helper:HelperUI = new HelperUI();
			
			ComboHelper.instance.setModel( __field );
			ComboHelperCristal.instance.setModel( __field );
			
			addChild(__roadUI);
			addChild(__zombieUI);
			addChild(__fieldUI);
			addChild(__ninjaUI);
			addChild(HelperUI.instance);
		}
		
		private function destroy(event:Event):void
		{
			var delArr:Array = new Array();
			
			for (var i:int = 0; i < numChildren; i++) 
			{
				delArr.push(getChildAt( i ));
			}
			
			for (var j:int = 0; j < delArr.length; j++) 
			{
				removeChild(delArr[j]);
			}
	
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);	
			__um.removeEventListener(ServiceEvent.USER_SERVICE, onUpdateUser);
			DEFEAT = false;
		}
	}
}