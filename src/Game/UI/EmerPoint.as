package Game.UI
{
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	public class EmerPoint extends EmerPoint_GUI
	{
		private var _parent:Sprite;
		static public var EMER_COUNT:int = 0;
		
		public function EmerPoint(parent:Sprite, posX:Number, posY:Number)
		{
			super();
			_parent = parent;
			this.x = posX;
			this.y = posY;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			this.alpha = 0;
			if(EMER_COUNT < 0) this.countTF.text = EMER_COUNT.toString();
			else this.countTF.text = "+" + EMER_COUNT.toString();
			if(EMER_COUNT != 0) tween();
		}
		
		private function tween():void
		{
			TweenMax.to(this, 0.75, { y:this.y - 40, alpha: 1, onComplete: hide })
		}
		
		private function hide():void
		{
			_parent.removeChild( this);
		}
		
		private function destroy(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);	
		}
	}
}