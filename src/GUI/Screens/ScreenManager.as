package GUI.Screens
{
	import flash.display.Sprite;
	import flash.net.LocalConnection;
	
	public class ScreenManager extends Sprite
	{
		private var _screenClass:Class;
		private var _currentScreen:Sprite;
		
		static private var __init:ScreenManager
		
		static public function get instance():ScreenManager
		{
			if(__init)
			{
				return __init;
			}
			else
			{
				__init = new ScreenManager();
				return __init;
			}
		}
		
		public function ScreenManager()
		{
			super();
		}
		
		public function show(screenClass:Class):void
		{
			_screenClass = screenClass;
			
			if(_currentScreen)
			{
				zombietown.instance.removeChild(_currentScreen); 
				_currentScreen = null;
			}
			_currentScreen = new _screenClass();
			zombietown.instance.addChild(_currentScreen);
		}
		
		public function destroy():void
		{
			if(_currentScreen) zombietown.instance.removeChild(_currentScreen);
			_currentScreen = null;
		}
		
		public function get screenName():Class
		{
			return _screenClass;
		}
		
	}
}