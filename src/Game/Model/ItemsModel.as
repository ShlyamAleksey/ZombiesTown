package Game.Model
{
	import Events.ItemsEvent;
	
	import GUI.InteractiveTutorial.Tutorial;
	import GUI.Windows.ItemsShop;
	
	import Game.Constants.ItemsConstant;
	import Game.Logic.FieldChecker;
	import Game.Logic.ItemsRandomCreater;
	import Game.Types.IGameItems;
	import Game.UI.DropItemUI;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	
	import flashx.textLayout.utils.CharacterUtil;
	
	public class ItemsModel extends EventDispatcher implements IGameItems
	{		
		
		
		private var __type					:int;
		private var __id					:int;
		private var __name					:String;
		private var __position				:Point;
		private var __zombie_moved			:Boolean = false;
		private var __zombieID = 0; //это для записи порядкового номера зомби
		
		private var __target				:Array;
		private var __items__creater		:ItemsRandomCreater;
		
		static public var __put__type		:int = 0;
		static public var STORAGE			:int = 0;
		static public var PUT__STORAGE		:Boolean = false;
		static public var BUY__ITEM			:Boolean = false;
		
		
		public function ItemsModel(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function setMainField(model:FieldModel):void
		{
			this.__target = model.field;	
		}
		
		public function startup(target:Point = null):void
		{		
			this.__items__creater = new ItemsRandomCreater(this.__target);
			addToField(target);
		}
		
		private function addToField(target:Point = null):void
		{
			if(PUT__STORAGE)
			{
				if(STORAGE == 0) this.type = this.__items__creater.getRandomType();
				else this.type = STORAGE;
				
				STORAGE = __put__type;
				PUT__STORAGE = false;
			}
			else if(BUY__ITEM)
			{
				this.type = ItemsShop.BOUGHT_ITEM;
				
				BUY__ITEM = false;
			}
			else if(FieldChecker.MUST_GIVE_CRISTAL)
			{
				this.type = ItemsConstant.TYPE_CRISTAL;
				FieldChecker.MUST_GIVE_CRISTAL = false;
			}
			else
			{
				this.type = this.__items__creater.getRandomType();
			}

			if(target) this.position = target.clone();
			else this.position = this.__items__creater.getRandomEmptyPlace();
			
			if(Tutorial.STATUS && Tutorial.STEP == 1) 
			{
				this.__type = ItemsConstant.TYPE_HERBS;
				this.position = new Point(3, 2);
			}
			if(Tutorial.STATUS && Tutorial.STEP == 3) 
			{
				this.__type = ItemsConstant.TYPE_HERBS;
				this.position = new Point(4, 2);
			}
			if(Tutorial.STATUS && Tutorial.STEP == 4) 
			{
				this.__type = ItemsConstant.TYPE_HERBS;
				this.position = new Point(5, 3);
			}
			if(Tutorial.STATUS && Tutorial.STEP == 7) 
			{
				this.__type = ItemsConstant.TYPE_HERBS;
				this.position = new Point(0, 5);
			}
			if(Tutorial.STATUS && Tutorial.STEP == 8) 
			{
				this.__type = ItemsConstant.TYPE_ZOMBIE;
				this.position = new Point(1, 1);
			}
			if(Tutorial.STATUS && Tutorial.STEP == 9) 
			{
				this.__type = ItemsConstant.TYPE_HERBS;
				this.position = new Point(1, 1);
			}
			if(Tutorial.STATUS && Tutorial.STEP == 10) 
			{
				this.__type = ItemsConstant.TYPE_ZOMBIE;
				this.position = new Point(1, 5);
			}
			
			if(Tutorial.STATUS && Tutorial.STEP == 11) 
			{
				this.__type = ItemsConstant.TYPE_HERBS;
				this.position = new Point(2, 4);
			}
			if(Tutorial.STATUS && Tutorial.STEP == 13) 
			{
				this.__type = ItemsConstant.TYPE_CRISTAL;
				if(FieldModel.instance.field[5][4].type == ItemsConstant.TYPE_ROAD)
				{
					this.position = new Point(5, 4);
				}
				else
				{
					this.position = new Point(4, 4);
				}
			}
			if(Tutorial.STATUS && Tutorial.STEP == 14) 
			{
				this.__type = ItemsConstant.TYPE_HUT;
				this.position = new Point(0, 0);
			}
			if(Tutorial.STATUS && Tutorial.STEP == 18) 
			{
				this.__type = ItemsConstant.TYPE_BOT;
				this.position = new Point(0, 3);
			}

			DropItemUI.TYPE = this.__type;
			dispatchEvent(new Event( ItemsEvent.CHANGE ));
		}
		
		public function putToStorage(putType:int):void
		{
			__put__type = putType;			
		}
		
		public function get type():int
		{
			return this.__type;
		}
		
		public function get zombie__moved():Boolean
		{
			return this.__zombie_moved;
		}
		
		public function set zombie__moved(val:Boolean):void 
		{
			this.__zombie_moved = val;
		}
		
		public function set type(val:int):void
		{
			this.__type = val;
			if(this.__type == 3 || this.__type == 5 || this.__type == 8)
			{
				this.__id = this.__type - 1;
			}
			else
			{
				this.__id = val;
			}
			
			
			dispatchEvent(new Event( ItemsEvent.CHANGE_TYPE ));
		}
		
		public function get id():int 
		{
			return this.__id;
		}
		
		public function set id(val:int):void 
		{
			this.__id = val;
		}
		
		public function get name():String
		{
			return this.__name;
		}
		
		public function set name(val:String):void
		{
			this.__name = val;
			dispatchEvent(new Event( ItemsEvent.CHANGE_NAME ));
		}
		
		public function get position():Point
		{
			return this.__position;
		}
		
		public function set position(val:Point):void
		{
			this.__position = val;
			dispatchEvent(new Event( ItemsEvent.CHANGE_POSITION ));
		}
		
		public function set zombieID(val:int):void
		{
			this.__zombieID = val;
		}
		
		public function get zombieID():int
		{
			return this.__zombieID;
		}
	}
}