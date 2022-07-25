package GUI.Windows
{
	import Game.Logic.Pause;
	
	import Sounds.GameMusic;
	import Sounds.boxSoundType;
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	import flash.display.Sprite;
	
	public class WindowsManager extends Sprite
	{
		private var _winStack:Vector.<Sprite>;
		private var _bgStack:Vector.<Sprite>;
		
		private var showCompleteFunction:Function;
		
		static private var __init:WindowsManager
		
		static public function get instance():WindowsManager
		{
			if(__init)
			{
				return __init;
			}
			else
			{
				__init = new WindowsManager();
				return __init;
			}
		}
		
		public function WindowsManager()
		{
			super();
			__init = this;
			_winStack = new Vector.<Sprite>();
			_bgStack = new Vector.<Sprite>();
		}
		
		
		public function show(winClass:Class, fun:Function = null):void
		{
			showCompleteFunction = fun;
			
			var _currentWin:* = new winClass();
			createBackGround();
			_bgStack[_bgStack.length - 1].addChild(_currentWin);
			_winStack.push(_currentWin);
			animate(_currentWin);
		}
		
		private function animate(spr:Sprite):void
		{		
			spr.scaleX = spr.scaleY = 0;
			
			spr.x = 380;
			spr.y = 350;
			
			if(showCompleteFunction != null) TweenLite.to(spr, 0.75, {scaleX:1, scaleY:1, ease:Back.easeOut, onComplete: showCompleteFunction});
			else TweenLite.to(spr, 0.75, {scaleX:1, scaleY:1, ease:Back.easeOut});
		}
		
		public function hide(fun:Function = null):void
		{
			TweenLite.to(_winStack[_winStack.length - 1] , 0.75, {scaleX:0, scaleY:0, ease:Back.easeOut, onComplete:complete});
			GameMusic.music.playSound( boxSoundType.SWindowLoss );
			function complete():void
			{
				_bgStack[_bgStack.length - 1].removeChild( _winStack[_winStack.length - 1] );
				_winStack.pop();
				zombietown.instance.removeChild(_bgStack[_bgStack.length - 1]);
				_bgStack.pop();
				if(_bgStack.length == 0) Pause.stop = false; //если в игре есть пауза
				
				if(fun != null) fun.call();
			}
			
			
		}
		
		private function createBackGround():void
		{
			var _bg:Sprite = new Sprite();
			_bg.graphics.beginFill(0x000000, 0.4);
			_bg.graphics.drawRect(0, 0, 760, 700);
			_bg.graphics.endFill();
			zombietown.instance.addChild(_bg);
			_bgStack.push(_bg);
		}
	}
}