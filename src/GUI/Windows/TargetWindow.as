package GUI.Windows
{
	import GUI.InteractiveTutorial.Tutorial;
	
	import Game.Constants.Statics;
	import Game.Logic.Pause;
	
	import Services.Service;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class TargetWindow extends Target_GUI
	{
		private var __timer:Timer = new Timer(1000, 2);
		
		public function TargetWindow()
		{
			super();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			this.__timer.addEventListener(TimerEvent.TIMER_COMPLETE, closeWindow);
			this.__timer.start();
			
			Pause.stop = true;
			
			this.targetTF.text = "Цель: набрать " + Service.instance.levelModel[Statics.CURRENT_LEVEL - 1].reguiredPoints.toString() + " очков";
			this.levelTF.text = "Уровень" + Statics.CURRENT_LEVEL;
		}
		
		protected function closeWindow(event:TimerEvent):void
		{					
			WindowsManager.instance.hide();
		}
		
		private function destroy(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);	
		}
	}
}