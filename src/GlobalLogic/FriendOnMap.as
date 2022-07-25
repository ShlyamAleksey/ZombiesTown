package GlobalLogic
{
	import GUI.Screens.MapScreen;
	
	import Services.FriendModel;
	import Services.Levels.LevelModel;
	import Services.Service;
	
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class FriendOnMap
	{
		private var __allLevelCount:int;
		private var __parent:MapScreen;
		private var items:Object = new Object();
		
		public function FriendOnMap(parent:MapScreen)
		{
			super();
			__parent = parent;
			__allLevelCount = Service.instance.levelModel.length;
			
			var friendArr:Vector.<LevelModel> = Service.instance.levelModel;
			
			items["overSprites"] = new Array();
			items["fomList"] = new Array();
			
			for (var i:int = 0; i < friendArr.length; i++) 
			{
				setupIcons(i);
			}	
			
		}
		
		private function setupIcons(level:int):void
		{
			var _overSprite:Sprite = new Sprite();
				_overSprite.graphics.beginFill(0x000000, 0);
				_overSprite.graphics.drawRect(0,0,62,62);
				_overSprite.name = level.toString();
				items["overSprites"].push(_overSprite); 
				
			var fomList:Array = new Array();
			for (var i:int = 0; i < Service.instance.friendsModel.length; i++) 
			{
				
				if(Service.instance.friendsModel[i].points == level)
				{
					var _fom:FriendOnMap_GUI = new FriendOnMap_GUI();
						__parent.backGround.mapList.addChild(_fom);
						fomList.push( _fom );
						
					new ImageLoader(Service.instance.friendsModel[i].picture, _fom.img);
					
					if(level < 9) 
					{
						_fom.x = __parent.backGround.mapList["lvl_0" + int(level + 1)].x + 20;
						_fom.y = __parent.backGround.mapList["lvl_0" + int(level + 1)].y - 140;					
					}
					
					if(level >= 9)
					{
						_fom.x = __parent.backGround.mapList["lvl_" + int(level + 1)].x + 20;
						_fom.y = __parent.backGround.mapList["lvl_" + int(level + 1)].y - 140;
					}
					
					_fom.scaleX = _fom.scaleY = 1.5;
					_overSprite.scaleX = _overSprite.scaleY = 1.5;
					
					_overSprite.x = _fom.x;
					_overSprite.y = _fom.y;
				}
				
					_overSprite.addEventListener(MouseEvent.MOUSE_OVER, onOver);
					_overSprite.addEventListener(MouseEvent.MOUSE_OUT, onOut);
					
					__parent.backGround.mapList.addChild( _overSprite );
			}
			items["fomList"].push(fomList);
		}
		
		protected function onOut(event:MouseEvent):void
		{
			for (var i:int = 0; i < items["fomList"][int(event.currentTarget.name)].length; i++) 
			{
				TweenMax.to( items["fomList"][int(event.currentTarget.name)][i], 0.5, 
					{ x: items["fomList"][int(event.currentTarget.name)][0].x } );
			}
		}
		
		protected function onOver(event:MouseEvent):void
		{
			var minus:int = -1;
			for (var i:int = 0; i < items["fomList"][int(event.currentTarget.name)].length; i++) 
			{
				TweenMax.to( items["fomList"][int(event.currentTarget.name)][i], 0.5, 
					{ x: items["fomList"][int(event.currentTarget.name)][0].x + 95*int((i + 1)/2)*minus } );
					minus *= -1
			}
		}
		
		public function destroy():void
		{
			for (var i:int = 0; i < items["overSprites"].length; i++) 
			{
				items["overSprites"][i].removeEventListener(MouseEvent.MOUSE_OVER, onOver);
				items["overSprites"][i].removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			}
			
		}
	}
}