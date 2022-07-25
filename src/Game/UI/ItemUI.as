package Game.UI
{
	import flash.events.Event;
	import flash.geom.Point;

	public class ItemUI extends item_GUI
	{
		private var __position:Point;
		private var __type:int; //это для отрисовки нужного кадра
		private var __id:int; //это для проверки ( одинаковый для кустов и супер-кустов)
		
		
		public function ItemUI()
		{
			super();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function get position():Point
		{
			return this.__position;
		}
		
		public function set position(val:Point):void
		{			
			this.x = val.x*80 + 55;
			this.y = val.y*80 + 145;
			
			this.__position = val;
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
		}
		
		public function get type():int 
		{
			return this.__type;
		}
		
		public function get id():int 
		{
			return this.__id;
		}
		
		private function destroy(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);	
		}
	}
}