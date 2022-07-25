package Game.UI
{
	import Connect.OK.ApiCallbackEvent;
	import Connect.OK.ForticomAPI;
	import Connect.ServiceHandler;
	
	import Events.GameEvent;
	import Events.ItemsEvent;
	
	import GUI.InteractiveTutorial.Tutorial;
	import GUI.Panels.RightPanel;
	import GUI.Screens.GameScreen;
	import GUI.Windows.ItemsShop;
	
	import Game.Command.BuildItemCommand;
	import Game.Command.StartUpCommand;
	import Game.Command.StorageCommand;
	import Game.Constants.ItemsConstant;
	import Game.Logic.ComboHelper;
	import Game.Logic.ComboHelperCristal;
	import Game.Logic.FieldChecker;
	import Game.Logic.Pause;
	import Game.Model.FieldModel;
	import Game.Model.ItemsModel;
	import Game.Utils;
	
	import GlobalLogic.LevelManager;
	
	import Services.Service;
	
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class DropItemUI extends ItemUI
	{
		static public var TYPE:int;
		static public var POSITION:Point // нужно для бота, хранит место куда поставили бота
		
		static public var PAID_RUN:Boolean = false;
		
		private var __model:ItemsModel;
		private var __field__model:FieldModel;
		
		private var __build__command:BuildItemCommand;
		private var __startup__command:StartUpCommand;
		private var __storage__command:StorageCommand;
		
		private var hX:helperX = new helperX();
		private var hY:helperY = new helperY();
		
		static private var ioa:int = 0;
		public function DropItemUI(model:ItemsModel, fieldModel:FieldModel)
		{
			this.__model = model;
			this.__field__model = fieldModel;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			this.__model.addEventListener(ItemsEvent.CHANGE, onItemReady);
			ForticomAPI.addEventListener(ApiCallbackEvent.CALL_BACK, handleApiEvent);
			
			addListener();
			
			this.__build__command = new BuildItemCommand(this.__field__model);
			
			this.__startup__command = new StartUpCommand(this.__model);
			this.__startup__command.setTarget(this.__field__model, POSITION);
			
			this.__storage__command = new StorageCommand(this.__model);
			
			prev_x = 0;
			prev_y = 0;
			
			stage.dispatchEvent( new Event ( GameEvent.DROP_ITEM ) ); 
			
			stage.addChild(hX);
			stage.addChild(hY);
			hX.mouseEnabled = false;
			hY.mouseEnabled = false;
			
			hX.visible = false;
			hY.visible = false;
			
			hX.y = 145;
			hY.x = 55;
		}
		
		private function addListener():void
		{
			if(!Tutorial.STATUS)
			{
				this.addEventListener(MouseEvent.MOUSE_DOWN, onDragItem);
			}
			else
			{
				if(Tutorial.STEP == 1 || Tutorial.STEP == 4 || Tutorial.STEP == 11 || Tutorial.STEP == 15 || Tutorial.STEP == 17  || Tutorial.STEP == 19) 
				{
					stage.mouseChildren = true;
				}
				else
				{
					stage.mouseChildren = false;
				}
				
				trace("STEP", Tutorial.STEP)
				if(Tutorial.STEP == 11 || Tutorial.STEP == 17)
				{
					trace("ALLOW DOWN")
					this.addEventListener(MouseEvent.MOUSE_DOWN, onDragItem);
				}
			}
			
			
			stage.addEventListener(MouseEvent.CLICK, onClickField);	
			
		}
		
		//Захват
		protected function onDragItem(e:MouseEvent):void
		{
			hX.visible = true;
			hY.visible = true;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMoveItem);
			stage.addEventListener(MouseEvent.MOUSE_UP, onDropItem);
			
			var pt:Point = Utils.Poss2Arr( new Point(stage.mouseX, stage.mouseY) );
			var pt2:Point =  Utils.Arr2Poss(pt.clone());

			TweenMax.to(this, 0.25, { scaleX:1, scaleY:1, x:pt2.x, y:pt2.y});
			
			hX.x = pt2.x;
			hY.y = pt2.y;
		}
		
		//Движение
		protected function onMoveItem(e:MouseEvent):void
		{
			var pt:Point = Utils.Poss2Arr( new Point(stage.mouseX, stage.mouseY) );
			var pt2:Point =  Utils.Arr2Poss( pt.clone() );

			if(condition__1)
			{
				TweenMax.to(this, 0.25, { scaleX:1, scaleY:1, x:pt2.x, y:pt2.y});
			}				
			else if( condition__2(this.__field__model.field[pt.x][pt.y].type) )
			{
				TweenMax.to(this, 0.25, { scaleX:1, scaleY:1, x:pt2.x, y:pt2.y});
				checkItemsChangePos(pt);
			}
			
			hX.x = pt2.x;
			hY.y = pt2.y;
		}
		
		/*Функция которая проверяет сменила ли свое положение фигурка*/
		private var prev_x:Number;
		private var prev_y:Number;
		private function checkItemsChangePos(pt:Point):void
		{
			if( prev_x != pt.x || prev_y != pt.y)
			{
				if(TYPE != ItemsConstant.TYPE_CRISTAL) ComboHelper.instance.getParams(pt, TYPE);
				if(TYPE == ItemsConstant.TYPE_CRISTAL) ComboHelperCristal.instance.getParams(pt, TYPE);
				prev_x = pt.x;
				prev_y = pt.y;
			}
		}
		
		//Бросок
		protected function onDropItem(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMoveItem);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onDropItem);

			if(PAID_RUN)
			{
				//handleApiEvent();
				//buyOneRun();
				TweenMax.to(this, 0.5, { scaleX:1.2, scaleY:1.2, x:this.x - 8, y:this.y - 8, repeat: -1, yoyo:true});
				hX.visible = false;
				hY.visible = false;
				return;
			}
			
			if(!condition__3) return;
			if(Pause.stop) return;
			
				var pt:Point = Utils.Poss2Arr( new Point(stage.mouseX, stage.mouseY) );
				var pt2:Point =  Utils.Arr2Poss(pt.clone());

				if(this.__field__model.field[pt.x][pt.y].type == ItemsConstant.TYPE_STORAGE)
				{
					this.__storage__command.execute(this.type);
					ItemsModel.PUT__STORAGE = true;
				}
				
				if( condition__1 || condition__2( this.__field__model.field[pt.x][pt.y].type) )
				{
					TweenMax.to(this, 0.25, { scaleX:1, scaleY:1, x:pt2.x, y:pt2.y});
					this.__build__command.execute(pt, this.__model.type);
				}				
				else
				{
					TweenMax.to(this, 0.5, { scaleX:1.2, scaleY:1.2, x:this.x - 8, y:this.y - 8, repeat: -1, yoyo:true});
					return;
				}
				
//				toSaveProgress();
				this.visible = false;
				ItemsShop.FREEZE = false;
				RightPanel.instance.freeze();
				
				hX.visible = false;
				hY.visible = false;
				
				if(!(pt.x == 0 && pt.y == 0)) zombietown.instance.addChild( new EmerPoint(zombietown.instance, pt2.x, pt2.y) );
		}
		
		private function buyOneRun():void
		{
			var bonusOrder:int = 18;
				ForticomAPI.showPayment(Service.instance.purchaseModel[bonusOrder].name,
										Service.instance.purchaseModel[bonusOrder].description,
										Service.instance.purchaseModel[bonusOrder].purchase_id,
										Service.instance.purchaseModel[bonusOrder].price_hard, null, null, null, 'true');	
		}
		
		protected function handleApiEvent(event:Event = null):void
		{
			Service.instance.userModel.life.count = 1;
			Service.instance.userModel.life = Service.instance.userModel.life;
			HelperUI.instance.gotoAndStop(1);
			PAID_RUN = false;
		}
		
		private function onClickField(e:MouseEvent):void
		{
			if(PAID_RUN)
			{
				buyOneRun();
				return;
			}
			
			if(Pause.stop) return;
			if(!condition__3) return;
			
			var pt:Point = Utils.Poss2Arr( new Point(stage.mouseX, stage.mouseY) );
			var pt2:Point =  Utils.Arr2Poss(pt.clone());
			
			if(FieldChecker.FULL_FIELD) 
			{
				TweenMax.to(this, 0.25, { scaleX:1, scaleY:1, x:pt2.x, y:pt2.y});
				this.__build__command.execute(pt, this.__model.type);
				return;
			}
			
			if(Tutorial.STATUS)
			{
				if( Tutorial.STEP == 1 || Tutorial.STEP == 4 || Tutorial.STEP == 11 || Tutorial.STEP == 15  || Tutorial.STEP == 17)
				{
					return;
				}
			}
			
			if(Tutorial.STATUS && !(pt.x == Tutorial.main.setupPlace.x && pt.y == Tutorial.main.setupPlace.y))
			{
				return;
			}
			else 
			{
				if(Tutorial.STATUS) 
				{
					if(Tutorial.STEP == 14) Tutorial.STEP = 19;
					else Tutorial.STEP++;
				}
			}

			
			if(this.__field__model.field[pt.x][pt.y].type == ItemsConstant.TYPE_STORAGE)
			{
				this.__storage__command.execute(this.type);
				ItemsModel.PUT__STORAGE = true;
			}
			
			if( condition__1 || condition__2( this.__field__model.field[pt.x][pt.y].type) )
			{
				TweenMax.to(this, 0.25, { scaleX:1, scaleY:1, x:pt2.x, y:pt2.y});
				this.__build__command.execute(pt, this.__model.type);
			}				
			else
			{
				return;
			} 
			
			
//			toSaveProgress();
			this.visible = false;
			ItemsShop.FREEZE = false;
			RightPanel.instance.freeze();
			
			if(!(pt.x == 0 && pt.y == 0)) zombietown.instance.addChild( new EmerPoint(zombietown.instance, pt2.x, pt2.y) );
		}
		
		private function toSaveProgress():void
		{
			LevelManager.lifeToSave ++;
			if(LevelManager.lifeToSave > 30)
			{
				LevelManager.lifeToSave = 0;
				ServiceHandler.instance.saveLevel(	this, onSaveComplete,
													Service.instance.userModel.playerId, false,
													FieldModel.instance.field,
													GameScreen.instance.lifeOnstart - Service.instance.userModel.life.count,
													Service.instance.userModel.points);
				GameScreen.instance.lifeOnstart = Service.instance.userModel.life.count;
			}
		}
		
		private function onSaveComplete(res:*):void
		{
			// TODO Auto Generated method stub
			
		}
		
		//Условие_1 : если попался БОТ 
		private function get condition__1():Boolean
		{
			return (this.type == ItemsConstant.TYPE_BOT) ? true : false;
		}
		
		//Условие_2 : если ячейка места для фишки является дорогой или складом 
		private function condition__2(type:int):Boolean
		{
			return (type == ItemsConstant.TYPE_ROAD || 
					type == ItemsConstant.TYPE_STORAGE) ? true : false;
		}
		
		//Условие_3 : если мышка за пределами поля
		private function get condition__3():Boolean
		{
			if(stage.mouseX > 535 || stage.mouseX < 55 || stage.mouseY > 625 || stage.mouseY < 145) return false;
			else return true;
		}
	
		protected function onItemReady(e:Event):void
		{
				if(this.__model.position == null) return;
				this.position = this.__model.position;
				this.type = this.__model.type;
				this.gotoAndStop(this.type + 1);
				
				TweenMax.to(this, 0, {glowFilter:{color:0xffffff, alpha:1, blurX:4, blurY:4, strength:15, quality:2}});
				TweenMax.to(this, 0.5, { scaleX:1.2, scaleY:1.2, x:this.x - 8, y:this.y - 8, repeat: -1, yoyo:true});
				
		}
		
		private function destroy(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);	
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onDragItem);
			stage.removeEventListener(MouseEvent.CLICK, onClickField);
			this.__model.removeEventListener(ItemsEvent.CHANGE, onItemReady);
			ForticomAPI.removeEventListener(ApiCallbackEvent.CALL_BACK, handleApiEvent);
			
			stage.removeChild(hX);
			stage.removeChild(hY);
		}
	}
}