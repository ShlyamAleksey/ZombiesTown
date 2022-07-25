package Game.UI
{
	import flash.events.Event;
	import flash.geom.Point;

	public class NinjaItem extends Ninja_GUI
	{
		private var __position:Point;
		
		public function NinjaItem()
		{
			super();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		public function get position():Point
		{
			return this.__position;
		}
		
		public function set position(val:Point):void
		{
			this.__position = val.clone();
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function destroy(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);	
		}
	}
}