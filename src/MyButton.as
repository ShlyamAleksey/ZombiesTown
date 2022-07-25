package
{
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class MyButton extends Sprite
	{
		private var _sprite:Sprite;
		
		public function MyButton(sprt:Sprite)
		{
			_sprite = sprt;
			_sprite.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			_sprite.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			_sprite.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
		}
		
		public function destroy():void
		{	
			_sprite.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			_sprite.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			_sprite.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
		}
		
		private function onDown(event:MouseEvent):void
		{
			TweenMax.to(_sprite, 0.25, { scaleX: 0.8, scaleY:0.8 });
		}
		
		private function onOut(event:MouseEvent):void
		{
			TweenMax.to(_sprite, 0.25, { scaleX: 1, scaleY:1 });
			
		}
		
		private function onOver(event:MouseEvent):void
		{
			TweenMax.to(_sprite, 0.25, { scaleX: 1.05, scaleY:1.05 });
			
		}
	}
}