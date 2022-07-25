package GUI.Windows
{
	import GUI.InteractiveTutorial.Tutorial;
	import GUI.Panels.RightPanel;
	import GUI.Screens.GameScreen;
	import GUI.Screens.MapScreen;
	import GUI.Screens.ScreenManager;
	
	import GlobalLogic.LevelManager;
	
	import Services.Service;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;

	public class Loader extends Preloader_GUI
	{
		static private var __init:Loader;
		//public var levelTargetTF:TextField = new TextField();
		
		private var _currentPercent:int = 0;
		private var _progress:int;
		
		static public function get instance():Loader
		{
			if(!__init) __init = new Loader();
			return __init;
		}
		
		public function Loader()
		{
			super();
			__init = this;
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			loadingPanel.gotoAndStop(1);
		}
		
		private function destroy(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);	
			removeEventListener(Event.ENTER_FRAME, showPercent);
		}
		
		public function show(per:int, msg:String):void
		{
			addEventListener(Event.ENTER_FRAME, showPercent);
			infoTF.text = msg;
			_progress = per;
		}
		
		private function showPercent(event:Event):void
		{
			if(_currentPercent == _progress)
			{
				removeEventListener(Event.ENTER_FRAME, showPercent);
				if(_currentPercent == 100) 
				{
					if(Service.instance.userModel.entryCount == 1)
					{
						Tutorial.STATUS = true;
						ScreenManager.instance.show( GameScreen );
					}
					else
					{
						ScreenManager.instance.show(MapScreen);
					}
					
				}
			}
			_currentPercent++;
			loadingPanel.gotoAndStop(_currentPercent);
		}
	}
}