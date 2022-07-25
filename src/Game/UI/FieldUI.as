package Game.UI
{
	import Events.GameEvent;
	
	import GUI.InteractiveTutorial.Tutorial;
	
	import Game.Command.BuildItemCommand;
	import Game.Command.StartUpCommand;
	import Game.Constants.ItemsConstant;
	import Game.Model.FieldModel;
	import Game.Model.ItemsModel;
	import Game.Types.IField;
	import Game.Types.IMouseHandler;
	import Game.Utils;
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class FieldUI extends Sprite
	{
		private var __model:FieldModel;
		private var __item__model:ItemsModel;
		private var __controller:StartUpCommand;
		
		private var __drop__item:DropItemUI;
		private var __items__sprite:Sprite;
		private var __storage__sprite:MovieClip;
		
		private var __itemsSprites:Array; // здесь хранятся все спрайты итемов
		
		
		public function FieldUI(model:FieldModel)
		{
			this.__model = model;
			this.__controller = new StartUpCommand(this.__model);
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
				
			this.__items__sprite = new Sprite();
			addChild(this.__items__sprite);
			
			this.__model.addEventListener(GameEvent.CHANGE_FIELD, saveData);	
			this.__model.addEventListener(GameEvent.ITEMS_CHECK, itemTurnAnimation);
			this.__model.addEventListener(GameEvent.SHOW_HELP, showTurnHelper);
			this.__model.addEventListener(GameEvent.SHOW_HELP_CRISTAL, showTurnHelper);
		
			this.__controller.execute();
		}
		
		/**Анимация превращения*/
		protected function itemTurnAnimation(e:GameEvent):void
		{
			if( e.object.turns.length)
			{
				var pt:Point = e.object.target.clone();
				TweenLite.to(this, 0.5, { alpha:1 , onComplete: update});

				for(var i:int = 0; i < e.object.turns.length; i++)
				{
					var pt2:Point = e.object.turns[i].clone();
					if( this.__itemsSprites )
					{
						TweenLite.to(this.__itemsSprites[pt2.x][pt2.y], 0.5, {alpha:0,  x: this.__itemsSprites[pt.x][pt.y].x,
																		y: this.__itemsSprites[pt.x][pt.y].y});						
					}
				}	
			}
			else
			{
				update();
			}
		}
	
		private function saveData(e:GameEvent):void
		{
			if(ItemsModel.PUT__STORAGE) update();
			if(ItemsModel.BUY__ITEM) update();
		}
		
		/**Заменяем старые фишки на новые и обновляем полу*/
		private function update():void
		{
			clearField();
			for (var i:int = 0; i < this.__model.width; i++) 
			{
				this.__itemsSprites.push( new Array() );
				
				for (var j:int = 0; j < this.__model.height; j++) 
				{
					var item:ItemUI = new ItemUI();
					this.__items__sprite.addChild(item);

					item.position = new Point( this.__model.field[i][j].position.x,
											   this.__model.field[i][j].position.y );
					
					item.gotoAndStop(this.__model.field[i][j].type + 1);
					
					if(	this.__model.field[i][j].type == ItemsConstant.TYPE_ZOMBIE) item.visible = false;
					if(	this.__model.field[i][j].type == ItemsConstant.TYPE_NINJA) item.visible = false;
					if(	this.__model.field[i][j].position.x == 0 && this.__model.field[i][j].position.y == 0 ) __storage__sprite = item.storage;
					
					this.__itemsSprites[i].push( item );
					TweenMax.to(item, 0, {glowFilter:{color:0x000000, alpha:1, blurX:2, blurY:2, strength:5}});
					
				}
			}
			addNewDropItem();
			__storage__sprite.gotoAndStop(Utils.nameByType(ItemsModel.STORAGE));
			
			if(Tutorial.STATUS && Tutorial.STEP == 3) Tutorial.main.step_3();
			if(Tutorial.STATUS && Tutorial.STEP == 4) Tutorial.main.step_4();
			if(Tutorial.STATUS && Tutorial.STEP == 7) Tutorial.main.step_7();
			if(Tutorial.STATUS && Tutorial.STEP == 8) Tutorial.main.step_8();
			if(Tutorial.STATUS && Tutorial.STEP == 9) Tutorial.main.step_9();
			if(Tutorial.STATUS && Tutorial.STEP == 10) Tutorial.main.step_10();
			if(Tutorial.STATUS && Tutorial.STEP == 11) Tutorial.main.step_11();
			if(Tutorial.STATUS && Tutorial.STEP == 13) Tutorial.main.step_13();
			if(Tutorial.STATUS && Tutorial.STEP == 14) Tutorial.main.step_14();
			//if(Tutorial.STATUS && Tutorial.STEP == 15) Tutorial.main.step_15();
			//if(Tutorial.STATUS && Tutorial.STEP == 18) Tutorial.main.step_18();
			if(Tutorial.STATUS && Tutorial.STEP == 19) Tutorial.main.step_19();
			
		}
		
		private function showTurnHelper(e:GameEvent):void
		{
			for (var j:int = 0; j < __itemsSprites.length; j++) 
			{
				for (var k:int = 0; k < __itemsSprites.length; k++) 
				{
					TweenMax.to(this.__itemsSprites[j][k], 0, {	x: j*80 + 55,
																y: k*80 + 145});	
				}
			}
			
			if( e.object.turns.length)
			{
				var pt:Point = e.object.target.clone();
				
				for(var i:int = 0; i < e.object.turns.length; i++)
				{
					var pt2:Point = e.object.turns[i].clone();
					if( this.__itemsSprites )
					{
						var dx:Number;
						var dy:Number;
						
						if( pt.x < pt2.x )
						{
							dx = - 4;
						}
						else if( pt.x > pt2.x )
						{
							dx = 4;
						}
						else dx = 0;
						
						if( pt.y < pt2.y )
						{
							dy = - 4;
						}
						else if( pt.y > pt2.y )
						{
							dy = 4;
						}
						else dy = 0;
						
						TweenMax.to(this.__itemsSprites[pt2.x][pt2.y], 0.25, {	x: this.__itemsSprites[pt2.x][pt2.y].x + dx,
																				y: this.__itemsSprites[pt2.x][pt2.y].y + dy, repeat: -1, yoyo:true});						
					}
				}	
			}
		}		
		
		/**Добавляем выпадаемый предмет*/
		private function addNewDropItem():void
		{
			this.__item__model = new ItemsModel(); 
			this.__drop__item = new DropItemUI(this.__item__model, this.__model);	
			addChild(this.__drop__item);		
		}		
		
		/**Очищаем поле*/
		private function clearField():void
		{
			removeChild(this.__items__sprite);
			this.__items__sprite = new Sprite();
			this.__itemsSprites = new Array();
			addChild(this.__items__sprite);	
			
			if(this.__drop__item) removeChild(this.__drop__item);
		}
		
		private function destroy(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);		
			this.__model.removeEventListener(GameEvent.ITEMS_CHECK, itemTurnAnimation);
			this.__model.removeEventListener(GameEvent.CHANGE_FIELD, saveData);
			this.__model.removeEventListener(GameEvent.SHOW_HELP, showTurnHelper);
			this.__model.removeEventListener(GameEvent.SHOW_HELP_CRISTAL, showTurnHelper);
		}
	}
}