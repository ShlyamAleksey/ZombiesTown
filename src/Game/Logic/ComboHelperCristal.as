package Game.Logic
{
	import Events.GameEvent;
	
	import Game.Constants.ItemsConstant;
	import Game.Model.FieldModel;
	
	import flash.events.Event;
	import flash.geom.Point;
	import Game.Utils;

	public class ComboHelperCristal
	{
		static private var __init:ComboHelperCristal;
		
		
		private var __type:int;
		private var __model:FieldModel;
		private var __typesSaver:Array;
		//private var __typeCounter:int = 0; // Счетчик для масива типов 
		
		protected var __field:Array;
		protected var __target:Point; //текущее положение кристала
		protected var __delateArr:Array = new Array()//массив отобранных для удаления фигур
		protected var __turnTypes:Array; //типы в которые может превращатся кристал
		public var  lastType:int = ItemsConstant.TYPE_STONE;	//последний нужный тип
		protected var __typeCounter:int = 0; // Счетчик для масива типов 
		public var __turnsItem:Array = new Array();
		
		static public function get instance():ComboHelperCristal
		{
			if(!__init) __init = new ComboHelperCristal();
			return __init;		
		}
		
		public function ComboHelperCristal()
		{
			this.__turnTypes = [ItemsConstant.TYPE_HERBS, 
				ItemsConstant.TYPE_BUSH,
				ItemsConstant.TYPE_TREE,
				ItemsConstant.TYPE_HUT,
				ItemsConstant.TYPE_HOUSE,
				ItemsConstant.TYPE_CASTLE,
				ItemsConstant.TYPE_GRAVE,
				ItemsConstant.TYPE_CHERCH, 
				ItemsConstant.TYPE_HOSTEL ]
		}
		
		public function getParams(pt:Point, type:int):void
		{
			__typeCounter = 0;
			__target = pt.clone();
			__type = type;
			turnCristal();
			
			
			this.__model.dispatchGameEvent( GameEvent.SHOW_HELP_CRISTAL, {"turns" : this.__turnsItem, "target" : this.__target} );
			this.__turnsItem = new Array();
			
		}
		
		public function setModel(model:FieldModel):void
		{
			this.__model = model;
			this.__model.addEventListener(GameEvent.CHANGE_FIELD, update);	
		}
		
		protected function update(event:Event):void
		{
			this.__field = this.__model.field;	
		}
		
		private function cloneTypes():void
		{
			for (var i:int = 0; i < this.__field.length; i++) 
			{
				for (var j:int = 0; j < this.__field.length; j++) 
				{
					this.__field[i][j].type = __typesSaver[i][j];
				}	
			}		
		}
		
		protected function startCheck(currentType:int, nextType:int, superType:int):void
		{
			for(var i:int = 0; i < this.__field.length; i++)	
			{
				for(var j:int = 0; j < this.__field.length; j++)
				{
					if(this.__field[i][j].id == currentType)
					{
						this.__delateArr.push(this.__field[i][j]);
						checkNeighbour(i, j);
					} 
					setupNewItem(nextType, superType);
				}
			}
			this.__typeCounter++;
		}
		
		protected function setupNewItem(nextType:int, superType:int):void
		{
			if(this.__delateArr.length >= 3)
			{
				this.__turnsItem = new Array();
				for(var i:int = 0; i < this.__delateArr.length; i++)
				{
					this.__turnsItem.push( this.__delateArr[i].position );
					this.__delateArr[i].type = ItemsConstant.TYPE_ROAD;
				}
				
//				if(lastType != ItemsConstant.TYPE_STONE) //это,чтоб для первой комбинации собирал, если убрать, то будет по самой лучшей
//				{
//					
//					this.__delateArr = new Array();		
//					return;
//				}
				var pt:Point = this.__target;
				lastType = this.__field[pt.x][pt.y].type;
				
			}
			this.__delateArr = new Array();
			
			
			//			turnCristal();
		}
		
		protected function turnCristal():void
		{
			__typesSaver = Utils.cloneArray(this.__field);
			
			if(this.__typeCounter == this.__turnTypes.length - 1 )	return;
			
			var pt:Point = this.__target.clone();
			
			this.__field[pt.x][pt.y].type = this.__turnTypes[ this.__typeCounter ];
			startCheck(ItemsConstant.TYPE_HERBS, ItemsConstant.TYPE_BUSH, ItemsConstant.TYPE_SUPER_BUSH);
			
			
			this.__field[pt.x][pt.y].type = this.__turnTypes[ this.__typeCounter ];
			startCheck(ItemsConstant.TYPE_BUSH, ItemsConstant.TYPE_TREE, ItemsConstant.TYPE_SUPER_TREE);
			
			this.__field[pt.x][pt.y].type = this.__turnTypes[ this.__typeCounter ];
			startCheck(ItemsConstant.TYPE_TREE, ItemsConstant.TYPE_HUT, ItemsConstant.TYPE_HUT);
			
			this.__field[pt.x][pt.y].type = this.__turnTypes[ this.__typeCounter ];
			startCheck(ItemsConstant.TYPE_HUT, ItemsConstant.TYPE_HOUSE, ItemsConstant.TYPE_SUPER_HOUSE);
			
			this.__field[pt.x][pt.y].type = this.__turnTypes[ this.__typeCounter ];
			startCheck(ItemsConstant.TYPE_HOUSE, ItemsConstant.TYPE_CASTLE, ItemsConstant.TYPE_CASTLE);
			
			this.__field[pt.x][pt.y].type = this.__turnTypes[ this.__typeCounter ];
			startCheck(ItemsConstant.TYPE_CASTLE, ItemsConstant.TYPE_ROAD, ItemsConstant.TYPE_ROAD);
			
			this.__field[pt.x][pt.y].type = this.__turnTypes[ this.__typeCounter ];
			startCheck(ItemsConstant.TYPE_GRAVE, ItemsConstant.TYPE_CHERCH, ItemsConstant.TYPE_CHERCH);
			
			this.__field[pt.x][pt.y].type = this.__turnTypes[ this.__typeCounter ];
			startCheck(ItemsConstant.TYPE_CHERCH, ItemsConstant.TYPE_HOSTEL, ItemsConstant.TYPE_HOSTEL);
			
			this.__field[pt.x][pt.y].type = this.__turnTypes[ this.__typeCounter ];
			startCheck(ItemsConstant.TYPE_HOSTEL, ItemsConstant.TYPE_ROAD, ItemsConstant.TYPE_ROAD);
			
			
			cloneTypes();		
		}
		
		/**Проверка на уже удаленных*/
		private function checkForDelate(x:int, y:int):Boolean
		{
			for(var d:int; d < this.__delateArr.length; d++)
			{
				if(this.__field[x][y].position == this.__delateArr[d].position) return true;
			}	
			return false;
		}
		
		/**Проверяем соседей*/
		private function checkNeighbour(x:int, y:int):void
		{					
			//left
			if(this.__field[x-1] && this.__field[x-1][y] && (this.__field[x][y].id == this.__field[x-1][y].id))
			{
				if(!checkForDelate(x-1, y))
				{
					this.__delateArr.push(this.__field[x-1][y]);
					checkNeighbour(x-1, y);
				}
			} 
			//right
			if(this.__field[x+1] && this.__field[x+1][y] && (this.__field[x][y].id == this.__field[x+1][y].id))
			{
				if(!checkForDelate(x+1, y))
				{
					this.__delateArr.push(this.__field[x+1][y]);
					checkNeighbour(x+1, y);
				}
			} 
			//up
			if(this.__field[x][y-1] && (this.__field[x][y].id == this.__field[x][y-1].id))
			{
				if(!checkForDelate(x, y-1))
				{
					this.__delateArr.push(this.__field[x][y-1]);
					checkNeighbour(x, y-1);
				}
			} 
			//down
			if(this.__field[x][y+1] && (this.__field[x][y].id == this.__field[x][y+1].id))
			{
				if(!checkForDelate(x, y+1))
				{
					this.__delateArr.push(this.__field[x][y+1]);
					checkNeighbour(x, y+1);
				}
			} 
		}
	}
}