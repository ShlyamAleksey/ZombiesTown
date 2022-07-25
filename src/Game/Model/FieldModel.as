package Game.Model
{
	import Events.GameDispatcher;
	import Events.GameEvent;
	
	import GUI.InteractiveTutorial.Tutorial;
	
	import Game.Logic.FieldChecker;
	import Game.Logic.SetupField;
	import Game.Logic.Undo;
	import Game.Types.IField;
	
	import Services.Service;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	
	public class FieldModel extends GameDispatcher implements IField
	{
		private var __width:int;
		private var __height:int;
		private var __field:Array;
		
		private var __setupField:SetupField;
		private var __field__checker:FieldChecker;
		
		static private var _init:FieldModel;
		static public function get instance():FieldModel { return _init; }
		
		public function FieldModel()
		{
			super();
			_init = this;
			if(!Service.instance.userModel.life.is_unlimit) Service.instance.userModel.life.count++;
		}
		
		public function startup():void
		{
			this.__setupField = new SetupField(this.__width, this.__height);
			this.field = this.__setupField.field;
			
			if(Tutorial.STATUS) Tutorial.main.start();
			
			this.__field__checker = new FieldChecker(this.field, new Point(), 16, this);
			this.field = this.__field__checker.field;
		}
		
		public function buildNewItem(target:Point, type:int):void
		{
			this.__field__checker = new FieldChecker(this.field, target, type, this);
			if(ItemsModel.PUT__STORAGE) this.field = this.__field__checker.field;
			if(ItemsModel.BUY__ITEM)
			{
				this.field = this.__field__checker.field;
				
			}
		}
		
		public function get width():int
		{
			return this.__width;
		}
		
		public function set width(val:int):void
		{
			this.__width = val;
		}
		
		public function get height():int
		{
			return this.__height;
		}
		
		public function set height(val:int):void
		{
			this.__height = val;
		}
		
		public function get field():Array
		{
			return this.__field;
		}
		
		public function set field(val:Array):void
		{
			this.__field = val;
			dispatchGameEvent(GameEvent.CHANGE_FIELD);
			Undo.save();
		}
	}
}