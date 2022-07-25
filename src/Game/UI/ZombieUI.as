package Game.UI
{
	import Events.GameEvent;
	
	import Game.Constants.ItemsConstant;
	import Game.Model.FieldModel;
	import Game.Model.ItemsModel;
	
	import Sounds.GameMusic;
	import Sounds.boxSoundType;
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class ZombieUI extends Sprite
	{
		protected var __model:FieldModel;
		protected var __items__sprite:Sprite;
		protected var __itemsSprites:Array; // здесь хранятся все спрайты итемов
		protected var __type:int; 
		protected var __class:Class;
		
		public function ZombieUI(model:FieldModel)
		{
			this.__model = model;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			this.__type = ItemsConstant.TYPE_ZOMBIE;
			this.__class = ZombieItem;
			this.__items__sprite = new Sprite()
			this.__itemsSprites = new Array();
			addChild(this.__items__sprite);

			addListener();
		}
		
		protected function addListener():void
		{
			this.__model.addEventListener(GameEvent.ZOMBIE_MOVE, zombieMoveAnim);
			this.__model.addEventListener(GameEvent.GRAVE_CHECK, graveAnimate);
			this.__model.addEventListener(GameEvent.COMPLETE_ANIM, completeAnim);
			this.__model.addEventListener(GameEvent.CHANGE_FIELD, saveData);	
		}
		
		protected function saveData(e:Event):void
		{
			if(ItemsModel.BUY__ITEM) update();
		}
		
		protected function zombieMoveAnim(e:GameEvent):void
		{
			
			if(DropItemUI.TYPE == this.__type)
			{
				var item:* = new this.__class();
				this.__items__sprite.addChild(item);
				
				item.x = e.object.target.x*80 + 55;
				item.y = e.object.target.y*80 + 145;
				
				item.width = item.height = 80;
				item.position = e.object.target.clone();
				this.__itemsSprites.push( item );	
			}
			changeToGrave();
			for (var i:int = 0; i < e.object.oldPosition.length; i++) 
			{
				var pt:Point = e.object.oldPosition[i].clone();
				var pt2:Point = e.object.newPosition[i].clone();
				
				if(this.__itemsSprites.length)
				{
					if( getSprite( pt ) )
					{
						getSprite( pt ).gotoAndStop(2);
						TweenLite.to( getSprite( pt ), 1,  { x: pt2.x*80 + 55, y: pt2.y*80 + 145} );
						//GameMusic.music.playSound( boxSoundType.SJump );
					} 		
				}
			}
			
		} 
		
		private function changeToGrave():void
		{
			for (var i:int = 0; i < this.__itemsSprites.length; i++) 
			{
				var pt:Point = this.__itemsSprites[i].position.clone();
				if( this.__model.field[pt.x][pt.y].type == ItemsConstant.TYPE_GRAVE ) this.__itemsSprites[i].visible = false;
			}
		}
		
		protected function graveAnimate(e:GameEvent):void
		{
			if( e.object.turns.length)
			{
				for (var j:int = 0; j < e.object.turns.length; j++) 
				{
					var lastID:int = e.object.target;
					var pt:Point = e.object.turns[j][lastID].position.clone();
					for(var i:int = 0; i < e.object.turns[j].length; i++)
					{
						var pt2:Point = e.object.turns[j][i].position.clone();
						if(this.__itemsSprites.length)
						{
							if(getSprite( pt2 )) TweenLite.to( getSprite( pt2 ), 0.5, {alpha:0, x: pt.x*80 + 55, y: pt.y*80 + 145});
						}
					}	
				}	
				TweenLite.to(this, 0.5, { alpha:1 , onComplete: update});
			}
		}
		
		protected function completeAnim(event:GameEvent):void
		{
			TweenLite.to(this, 0.75, { alpha:1 , onComplete: update});
		}
		
		protected function update():void
		{
			clearField();
			
			for (var i:int = 0; i < this.__model.width; i++) 
			{
				for (var j:int = 0; j < this.__model.height; j++) 
				{
					if(	this.__model.field[i][j].type == this.__type)
					{
						var item:* = new this.__class();
						this.__items__sprite.addChild(item);
						
						item.x = this.__model.field[i][j].position.x*80 + 55;
						item.y = this.__model.field[i][j].position.y*80 + 145;
						
						item.width = item.height = 80;
						item.position = new Point( i, j );
						this.__itemsSprites.push( item );
						TweenMax.to(item, 0, {glowFilter:{color:0x000000, alpha:1, blurX:2, blurY:2, strength:5}});
					}
				}
			}
		}
		
		private function clearField():void
		{
			removeChild(this.__items__sprite);
			this.__items__sprite = new Sprite();
			this.__itemsSprites = new Array();
			addChild(this.__items__sprite);	
		}
		
		protected function getSprite(p:Point):MovieClip
		{
			for (var j:int = 0; j < this.__itemsSprites.length; j++) 
			{
				if( p.x == this.__itemsSprites[j].position.x && p.y == this.__itemsSprites[j].position.y ) return this.__itemsSprites[j];
			}
			return null;
		}
		
		protected function destroy(event:Event):void
		{
			this.__model.removeEventListener(GameEvent.ZOMBIE_MOVE, zombieMoveAnim);
			this.__model.removeEventListener(GameEvent.GRAVE_CHECK, graveAnimate);
			this.__model.removeEventListener(GameEvent.COMPLETE_ANIM, completeAnim);
			this.__model.removeEventListener(GameEvent.CHANGE_FIELD, saveData);
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);	
		}
	}
}