package Game.UI
{
	import com.greensock.TweenMax;
	
	import flash.events.Event;
	import flash.geom.Point;

	
	public function boxAnim(pt:Point):void
	{
			var __box:Box_GUI = new Box_GUI();
		var __elmer:EmerPoint_GUI = new EmerPoint_GUI();
		
			zombietown.instance.addChild( __box );
			__box.x = pt.x*80 + 85;
			__box.y = pt.y*80 + 185;
			
			__box.width = 80;
			__box.height = 80;
			
			__elmer.countTF.text = "+" + 3000;
			zombietown.instance.addChild( __elmer );
			__elmer.x = pt.x*80 + 55;
			__elmer.y = pt.y*80 + 145;
			__elmer.alpha = 0;
			__elmer.gotoAndStop(1);
			__box.addEventListener(Event.ENTER_FRAME, update);
			
			function update():void
			{
				if(__box.currentFrame == 17)
				{
					__box.removeEventListener(Event.ENTER_FRAME, update);
					//__elmer.gotoAndStop(17);
					
					TweenMax.to(__elmer, 1, { y:__elmer.y - 40, alpha: 1, onComplete:
						function ():void
						{	
							zombietown.instance.removeChild( __box ); 
							zombietown.instance.removeChild( __elmer ); 
							
						} })
				}
				
			}
	}
	
	
}