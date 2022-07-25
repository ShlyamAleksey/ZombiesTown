package Game.UI
{
	import Events.GameEvent;
	
	import Game.Constants.ItemsConstant;
	import Game.Model.FieldModel;
	
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class RoadUI extends Sprite
	{
		private var __model:FieldModel;
		private var __items__sprite:Sprite;
		
		public function RoadUI(model:FieldModel)
		{
			this.__model = model;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			this.__items__sprite = new Sprite();
			addChild(this.__items__sprite);
			
			this.__model.addEventListener(GameEvent.CHANGE_FIELD, update);
		}
		
		protected function update(e:GameEvent):void
		{
			clearField();
			
			for (var i:int = 0; i < this.__model.width; i++) 
			{
				for (var j:int = 0; j < this.__model.height; j++) 
				{
					if(this.__model.field[i][j].type == ItemsConstant.TYPE_ROAD ||
							this.__model.field[i][j].type == ItemsConstant.TYPE_ZOMBIE ||
							this.__model.field[i][j].type == ItemsConstant.TYPE_NINJA)
					{
						var item:Road_GUI = new Road_GUI();
						this.__items__sprite.addChild(item);
						
						item.x = this.__model.field[i][j].position.x*80 + 55;
						item.y = this.__model.field[i][j].position.y*80 + 145;
						
						var _mask:Sprite = checkPosition(i, j);
						item.addChild(_mask);
						item.mask = _mask;
							
						//item.gotoAndStop( 20 );
					}
				}
			}
			TweenMax.to(this, 0, {glowFilter:{color:0x39620C, alpha:1, blurX:5, blurY:5, strength:50}});
			
		}
		
		private function clearField():void
		{
			removeChild(this.__items__sprite);
			this.__items__sprite = new Sprite();
			addChild(this.__items__sprite);	
		}
		
		private function checkPosition(x:int, y:int):Sprite
		{
			var arr:Array = new Array();
			
			if( this.__model.field[x - 1] && this.__model.field[x - 1][y - 1] && condition(x - 1, y - 1) ) arr.push(1);
			else arr.push(0);
				
			if( this.__model.field[x][y - 1] && condition(x, y - 1) ) arr.push(1);
			else arr.push(0);
				
			if( this.__model.field[x + 1] && this.__model.field[x + 1][y - 1] && condition(x + 1, y - 1) ) arr.push(1);
			else arr.push(0);

			if( this.__model.field[x - 1] && condition(x - 1, y) ) arr.push(1);
			else arr.push(0);
				
			if( condition(x, y) ) arr.push(1);
			else arr.push(0);
				
			if( this.__model.field[x + 1] && condition(x + 1, y) ) arr.push(1);
			else arr.push(0);

			if( this.__model.field[x - 1] && this.__model.field[x - 1][y + 1] && condition(x - 1, y + 1) ) arr.push(1);
			else arr.push(0);
				
			if( this.__model.field[x][y + 1] && condition(x, y + 1) ) arr.push(1);
			else arr.push(0);
				
			if( this.__model.field[x + 1] && this.__model.field[x + 1][y + 1] && condition(x + 1, y + 1) ) arr.push(1);
			else arr.push(0);
			
//				trace( arr[0], arr[1], arr[2] )
//				trace( arr[3], arr[4], arr[5] )
//				trace( arr[6], arr[6], arr[8] )
//				trace("-----------");
			return getFrame(arr);	
		}	
		
		
		private var _prt1:MovieClip;
		private var _prt2:MovieClip;
		private var _prt3:MovieClip;
		private var _prt4:MovieClip;
		private var _prt5:MovieClip;
		private var _prt6:MovieClip;
		private var _prt7:MovieClip; 
		private var _prt8:MovieClip;
		private var _prt9:MovieClip;
			
		private function getFrame(arr:Array):Sprite
		{
			var str:String = "";
			for (var i:int = 0; i < arr.length; i++) 
			{
				str = str + arr[i];
			}
			
			var _msk:Sprite = new Sprite();
			
			
			/*part 1*/
				_prt1 = new maskType_1();
				
				if( arr[0] == 0 && arr[1] == 1 && arr[3] == 1) _prt1 = new maskType_4();
				if( arr[0] == 0 && arr[1] == 0 && arr[3] == 0) { _prt1 = new maskType_3(); _prt1.gotoAndStop(3); }
				if( arr[1] == 0 && arr[3] == 0) { _prt1 = new maskType_3(); _prt1.gotoAndStop(3); }
				if( arr[1] == 1 && arr[3] == 0) { _prt1 = new maskType_2(); _prt1.gotoAndStop(4); }
				if( arr[1] == 0 && arr[3] == 1) { _prt1 = new maskType_2(); }
			
			/*part 2*/
				if(arr[1] == 1) _prt2 = new maskType_1();
				if(arr[1] == 0) _prt2 = new maskType_2();
				_prt2.x = 27;
				
			/*part 3*/	
				_prt3 = new maskType_1();
				
				if( arr[2] == 0 && arr[1] == 1 && arr[5] == 1) { _prt3 = new maskType_4(); _prt3.gotoAndStop(2);}
				if( arr[2] == 0 && arr[1] == 0 && arr[5] == 0) { _prt3 = new maskType_3(); _prt3.gotoAndStop(4); }
				if( arr[1] == 0 && arr[5] == 0) { _prt3 = new maskType_3(); _prt3.gotoAndStop(4); }
				if( arr[1] == 1 && arr[5] == 0) { _prt3 = new maskType_2(); _prt3.gotoAndStop(3); }
				if( arr[1] == 0 && arr[5] == 1) { _prt3 = new maskType_2(); }
				_prt3.x = 54;
			
				
			/*part 4*/	
				if(arr[3] == 1) _prt4 = new maskType_1();
				if(arr[3] == 0) 
				{
					_prt4 = new maskType_2();
					_prt4.gotoAndStop(4);
				}
				_prt4.y = 27;
			
			/*part 5*/
				_prt5 = new maskType_1();
				_prt5.x = 27;
				_prt5.y = 27;
			
			/*part 6*/
				if(arr[5] == 1) _prt6 = new maskType_1();
				if(arr[5] == 0) 
				{
					_prt6 = new maskType_2();
					_prt6.gotoAndStop(3);
				}
				_prt6.x = 54;
				_prt6.y = 27;
			
			/*part 7*/
				_prt7 = new maskType_1();
				if( arr[6] == 0 && arr[7] == 1 && arr[3] == 1) { _prt7 = new maskType_4(); _prt7.gotoAndStop(4);}
				if( arr[6] == 0 && arr[7] == 0 && arr[3] == 0) { _prt7 = new maskType_3(); _prt7.gotoAndStop(2); }
				if( arr[7] == 0 && arr[3] == 0) { _prt7 = new maskType_3(); _prt7.gotoAndStop(2); }
				if( arr[7] == 1 && arr[3] == 0) { _prt7 = new maskType_2(); _prt7.gotoAndStop(4); }
				if( arr[7] == 0 && arr[3] == 1) { _prt7 = new maskType_2(); _prt7.gotoAndStop(2);}
				_prt7.y = 54;
				
			/*part 8*/
				_prt8 = new maskType_1();
				if(arr[7] == 1) _prt8 = new maskType_1();
				if(arr[7] == 0) 
				{
					_prt8 = new maskType_2();
					_prt8.gotoAndStop(2);
				}
				_prt8.x = 27;
				_prt8.y = 54;
			
			/*part 9*/
				_prt9 = new maskType_1();
				if( arr[8] == 0 && arr[7] == 1 && arr[5] == 1) { _prt9 = new maskType_4(); _prt9.gotoAndStop(3);}
				if( arr[8] == 0 && arr[7] == 0 && arr[5] == 0) { _prt9 = new maskType_3();}
				if( arr[7] == 0 && arr[5] == 0) { _prt9 = new maskType_3();}
				if( arr[7] == 1 && arr[5] == 0) { _prt9 = new maskType_2(); _prt9.gotoAndStop(3); }
				if( arr[7] == 0 && arr[5] == 1) { _prt9 = new maskType_2(); _prt9.gotoAndStop(2);}
				_prt9.x = 54;
				_prt9.y = 54;

			_msk.addChild(_prt1);
			_msk.addChild(_prt2);
			_msk.addChild(_prt3);
			_msk.addChild(_prt4);
			_msk.addChild(_prt5);
			_msk.addChild(_prt6);
			_msk.addChild(_prt7);
			_msk.addChild(_prt8);
			_msk.addChild(_prt9);
			 return _msk;	
		}
		
		private function condition(i:int, j:int):Boolean
		{
			if( this.__model.field[i][j].type == ItemsConstant.TYPE_ROAD ||
				this.__model.field[i][j].type == ItemsConstant.TYPE_ZOMBIE ||
				this.__model.field[i][j].type == ItemsConstant.TYPE_NINJA ) { return true; }
			return false;
		}
		
		private function destroy(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);	
			this.__model.removeEventListener(GameEvent.CHANGE_FIELD, update);
			
			_prt1 = null;
			_prt2 = null;
			_prt3 = null;
			_prt4 = null;
			_prt5 = null;
			_prt6 = null;
			_prt7 = null;
			_prt8 = null;
			_prt9 = null;
		}
	}
}