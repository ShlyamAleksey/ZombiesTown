package GUI.Screens
{
	import flash.display.Sprite;
	import flash.events.Event;

	public class PreloaderScreen extends Preloader_GUI
	{
		private var _currentPercent:int = 0;
		private var _progress:int;
		
		static private var __init:PreloaderScreen;
		
		static public function get instance():PreloaderScreen
		{
			if(!__init) __init = new PreloaderScreen();
			return __init;
		}
		
		public function PreloaderScreen()
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
		
		public function show(per:int, msg:String):void
		{		
//			addEventListener(Event.ENTER_FRAME, showPercent);
//			_progress = per;	
//			loadingPanel.gotoAndStop(_progress);
//			infoTF.text = msg;
//			trace(infoTF.text);
		}
		
		private function showPercent(event:Event):void
		{
			if(_currentPercent == _progress)
			{
				removeEventListener(Event.ENTER_FRAME, showPercent);
				//if(_currentPercent == 100) ScreenManager.instance.show(MapScreen);
			}
			_currentPercent++;
//			loadingPanel.gotoAndStop(_currentPercent);
//			infoTF.text = "1sa";
		}
		
		private function destroy(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);	
			removeEventListener(Event.ENTER_FRAME, showPercent);
		}
	}
}