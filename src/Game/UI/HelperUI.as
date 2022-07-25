package Game.UI
{
	import GUI.InteractiveTutorial.Tutorial;
	
	import Game.Utils;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class HelperUI extends Helper
	{
		static private var _init:HelperUI;
		static public function get instance():HelperUI { return _init; }
		
		
		public function HelperUI()
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
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMoveMouse);
			
			HelperUI.instance.visible = true;
			HelperUI.instance.mouseEnabled = false;
		}
		
		protected function onMoveMouse(event:MouseEvent):void
		{
			var pt:Point = Utils.Poss2Arr( new Point(stage.mouseX, stage.mouseY) );
			var pt2:Point =  Utils.Arr2Poss( pt.clone() );
			
			this.x = pt2.x;
			this.y = pt2.y;
			
			if(Tutorial.STATUS) this.visible = false;
		}
		
		private function destroy(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);	
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMoveMouse);
		}
	}
}