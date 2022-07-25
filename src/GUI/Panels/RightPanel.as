package GUI.Panels
{
	import Connect.OK.ApiCallbackEvent;
	import Connect.OK.ForticomAPI;
	import Connect.ServiceHandler;
	
	import Events.GameEvent;
	import Events.ServiceEvent;
	
	import GUI.InteractiveTutorial.Tutorial;
	import GUI.Screens.GameScreen;
	import GUI.Screens.MapScreen;
	import GUI.Windows.ItemsShop;
	import GUI.Windows.Victory;
	import GUI.Windows.WindowsManager;
	
	import Game.Constants.Statics;
	import Game.Logic.Undo;
	import Game.Model.FieldModel;
	import Game.Model.ItemsModel;
	import Game.UI.DropItemUI;
	import Game.UI.EmerPoint;
	
	import GlobalLogic.FriendOnMap;
	import GlobalLogic.LevelManager;
	
	import Services.FriendModel;
	import Services.Service;
	import Services.User.UserModel;
	
	import Sounds.GameMusic;
	import Sounds.boxSoundType;
	
	import api.com.odnoklassniki.Odnoklassniki;
	
	import com.greensock.TweenMax;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class RightPanel extends RightPanel_GUI
	{
		private var __um:UserModel;
		public var __fieldModel:FieldModel;
		private var _reguirement:int; 
		static public var FIELD_NAME = "";
		
		static private var _init:RightPanel;
		static public function get instance():RightPanel { return _init; }
		
		private var __randID:FriendModel;
		var _fm:Vector.<FriendModel>;
		
		public function RightPanel(model:FieldModel)
		{
			super();
			_init = this;
			_fm = Service.instance.friendsModel; 
			
			this.__fieldModel = model;
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			this.__um = Service.instance.userModel;
			this.__um.addEventListener( ServiceEvent.USER_SERVICE, updateUser);
			
			if( __um.currentLevelsProgress.hasOwnProperty("points") )
			{
				loadPoints();
			}
			
			updateItem(null);
			
			showFriendItem();
		}
		
		private function showFriendItem():void
		{
			getFreeFriend();	
		}

		private function getFreeFriend():void
		{
			for (var i:int = 0; i < _fm.length; i++) 
			{
				__randID = _fm[i];
				if(__randID.canGiftLife == 1) 
				{
					new ImageLoader(__randID.picture, this.friendMC.img, 50);
					SimpleButton(this.friendMC.notifBtn).addEventListener(MouseEvent.CLICK, sendNotify);
					return;
				}
			}
			
			this.friendMC.img.visible = false;
			SimpleButton(this.friendMC.notifBtn).mouseEnabled = false;
			TweenMax.to(this.friendMC.notifBtn, 0.25, {colorMatrixFilter:{colorize:0xffffff, amount:1}});			
		}
		
		protected function sendNotify(e:MouseEvent):void
		{
			ForticomAPI.addEventListener(ApiCallbackEvent.CALL_BACK, handleApiEvent);
			ForticomAPI.showNotification("Отлично, теперь ты можешь получить подарок за то, что играешь вместе со мной!", null);
		}
		
		protected function handleApiEvent(event:*):void
		{
			if (event)
			{
				ServiceHandler.instance.sendLife(this, onSend, Service.instance.userModel.playerId,
					__randID.playerId.toString(), GameScreen.instance.lifeOnstart - Service.instance.userModel.life.count );		
			}
			
			ForticomAPI.removeEventListener(ApiCallbackEvent.CALL_BACK, handleApiEvent);
		}
		
		private function onSend(res:*):void
		{
			__randID.canGiftLife = 0;
			getFreeFriend();
			Service.instance.userModel.life.count +=3;
			Service.instance.userModel.life = Service.instance.userModel.life;
		}
		
		private function loadPoints():void
		{
			__um.points = __um.currentLevelsProgress.points;
		}
		
		protected function updateItem(e:Event):void
		{
			this.currentItem.gotoAndStop( DropItemUI.TYPE + 1);
			TweenMax.to(this.currentItem, 0, {glowFilter:{color:0x000000, alpha:1, blurX:2, blurY:2, strength:5}});
		}
		
		protected function updateUser(e:Event):void
		{	
			if(Tutorial.STATUS) 
			{
				_reguirement = 0;
				this.pointsTF.text = this.__um.points.toString();
			}
			else
			{
				if(Statics.CURRENT_LEVEL == 0 ) Statics.CURRENT_LEVEL = 1; // Заглушка
				_reguirement = Service.instance.levelModel[Statics.CURRENT_LEVEL - 1].reguiredPoints;	
				this.pointsTF.text = this.__um.points.toString();
				checkEndLevel();
			}
			
		}
		
		private function checkEndLevel():void
		{
			if(this.__um.points >= _reguirement && !Victory.ONCE)
			{
				LevelManager.instance.onEndLevel(1);
				Victory.ONCE = true;
			}
			
			if(this.__um.points >= _reguirement && this.__um.points < 10000)
			{			
				//this.levelTargetTF.text = (10000).toString();
				FIELD_NAME = "поселок";
			}
			else if(this.__um.points >= 10000 && this.__um.points < 10000*2)
			{
				//this.levelTargetTF.text = (10000 * 2).toString();
				FIELD_NAME = "село";
			}
			else if(this.__um.points >= 10000*2 && this.__um.points < 10000*5)
			{
				//this.levelTargetTF.text = (10000 * 5).toString();
				FIELD_NAME = "город";
			}
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			if(Tutorial.STATUS)
			{
				this.levelTargetTF.text = _reguirement.toString();
				shopBtn.addEventListener(MouseEvent.CLICK, openItemShop);
			}
			else
			{
				this.levelTargetTF.text = Service.instance.levelModel[Statics.CURRENT_LEVEL - 1].reguiredPoints.toString();
				stage.addEventListener( GameEvent.DROP_ITEM,  updateItem);
				shopBtn.addEventListener(MouseEvent.CLICK, openItemShop);
				undoBtn.addEventListener(MouseEvent.CLICK, undo);
				createBottomPanel();
			}
			
			freeze();
		}
		
		private function createBottomPanel():void
		{
			setupButton(undoBtn, 1, Service.instance.purchaseModel[9].price_hard.toString());	
		}
		
		private function setupButton(btn:SimpleButton, pos:int, text:String):void
		{
			((btn.downState as Sprite).getChildAt(pos) as TextField).text = text + " ok";
			((btn.overState as Sprite).getChildAt(pos) as TextField).text = text + " ok";
			((btn.upState as Sprite).getChildAt(pos) as TextField).text = text + " ok";
		}
		
		protected function undo(event:MouseEvent):void
		{
			GameMusic.music.playSound( boxSoundType.SUndo );
			makePurchase(9);
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
				
				ItemsModel.BUY__ITEM = true;
				ItemsShop.BOUGHT_ITEM = Undo.last_drop;
				DropItemUI.TYPE = ItemsShop.BOUGHT_ITEM;
				Undo.execute();
				ItemsShop.FREEZE = true;
				FieldModel.instance.dispatchGameEvent(GameEvent.CHANGE_FIELD);
				//WindowsManager.instance.hide();
				
				//Service.instance.userModel.currencySoft -= Service.instance.purchaseModel[bonusOrder].price_soft;
				ForticomAPI.removeEventListener(ApiCallbackEvent.CALL_BACK, handleApiEvent);
			}
			
//			ServiceHandler.instance.softPurchase(this, function (res:*):void
//			{
//				if(res.response.message != "Not enough currency soft")
//				{
//							ItemsModel.BUY__ITEM = true;
//							ItemsShop.BOUGHT_ITEM = Undo.last_drop;
//							DropItemUI.TYPE = ItemsShop.BOUGHT_ITEM;
//							Undo.execute();
//							ItemsShop.FREEZE = true;
//							
//					FieldModel.instance.dispatchGameEvent(GameEvent.CHANGE_FIELD);
//					Service.instance.userModel.currencySoft -= Service.instance.purchaseModel[bonusOrder].price_soft;
//					freeze();
//				}
//			}
//				, Service.instance.userModel.playerId, Service.instance.purchaseModel[bonusOrder].purchase_id);		
		}

		public function freeze():void
		{
			if(!ItemsShop.FREEZE)
			{
				undoBtn.mouseEnabled = true;
				TweenMax.to(undoBtn, 0.25, {colorMatrixFilter:{amount:0}});
			}
			else
			{
				undoBtn.mouseEnabled = false;
				TweenMax.to(undoBtn, 0.25, {colorMatrixFilter:{colorize:0xffffff, amount:1}});
			}	
		}
		
		
	
		protected function openItemShop(e:MouseEvent):void
		{
			WindowsManager.instance.show( ItemsShop );
			if(Tutorial.STATUS && Tutorial.STEP == 15) 
			{
				//Tutorial.main.step_16();
			}
		}
		
		private function destroy(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);	
			stage.removeEventListener( GameEvent.DROP_ITEM,  updateItem);
			shopBtn.removeEventListener(MouseEvent.CLICK, openItemShop);
			undoBtn.removeEventListener(MouseEvent.CLICK, undo);
			SimpleButton(this.friendMC.notifBtn).removeEventListener(MouseEvent.CLICK, sendNotify);
		}
	}
}