package
{
	import Connect.Local.URLConnector;
	import Connect.ServerConnect;
	
	import GUI.Screens.GameScreen;
	import GUI.Screens.MapScreen;
	import GUI.Screens.PreloaderScreen;
	import GUI.Screens.ScreenManager;
	import GUI.Windows.Loader;
	
	import Game.Logic.ComboHelper;
	import Game.Logic.ComboHelperCristal;
	import Game.Model.FieldModel;
	import Game.UI.FieldUI;
	import Game.UI.HelperUI;
	import Game.UI.NinjaUI;
	import Game.UI.RoadUI;
	import Game.UI.ZombieUI;
	
	import Sounds.GameMusic;
	
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	import com.google.analytics.v4.GoogleAnalyticsAPI;
	import com.google.analytics.v4.Tracker;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.getTimer;
	
	[SWF(frameRate="30", width="760", height="700")]
	
	public class zombietown extends Sprite
	{
		static private var __init:zombietown
		static public function get instance():zombietown{ return __init; }
		
		private var __server__connect:ServerConnect;
		private var cursor:GameCursor;
		
		public var tracker:AnalyticsTracker;
		
		public function zombietown()
		{

//			MonsterDebugger.initialize(this);
			__init = this;

			ScreenManager.instance.show(Loader);
			Loader.instance.show(5, "Инициализация");
			
			this.__server__connect = new ServerConnect();

			tracker = new GATracker(this, "UA-49778704-1", "AS3", false); 
			loadMusic();	
		}
		
		private function createCursor():void
		{
			Mouse.hide();
		
			cursor = new GameCursor();
			cursor.mouseChildren = false;
			cursor.mouseEnable = false;
			
			stage.addChild( cursor );
			stage.addEventListener(MouseEvent.MOUSE_MOVE, redrawCursor);
		}
		
		private function redrawCursor(event:MouseEvent):void
		{
			cursor.x = event.stageX + 3;//координата по оси x
			cursor.y = event.stageY + 3; //координата по оси y
		}
		
		private function loadMusic():void
		{		
			tracker.trackEvent("Enter in Game", "утеук"); // Функция, которая отравит данные в Google Analytics
			
			GameMusic.music.loadMusic();
			GameMusic.music.addLoadComplete( musicLoaded );
		}
		
		private function musicLoaded():void
		{
			GameMusic.music.mute = true;
		}
	}
}