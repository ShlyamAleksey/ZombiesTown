package Game.Logic
{
	import Game.Constants.ItemsConstant;
	
	import flash.geom.Point;

	public class Cristal
	{
		protected var __field:Array;
		protected var __target:Point; //текущее положение кристала
		protected var __delateArr:Array = new Array()//массив отобранных для удаления фигур
		protected var __turnTypes:Array; //типы в которые может превращатся кристал
		public var  lastType:int = ItemsConstant.TYPE_STONE;	//последний нужный тип
		private var __typeCounter:int = 0; // Счетчик для масива типов 
		private var __turnsItem:Array = new Array();
			
		public function Cristal()
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
		
		public function startup(field:Array, target:Point):void
		{
			this.__field = field;
			this.__target = target.clone();
			
			turnCristal();		
		}
		
		protected function turnCristal():void
		{
			if(this.__typeCounter == this.__turnTypes.length - 1 )	return;
			var pt:Point = this.__target;
			
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
			
			//this.__typeCounter++;
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
		
		private function setupNewItem(nextType:int, superType:int):void
		{
			if(this.__delateArr.length >= 3)
			{
				
				
//				if(lastType != ItemsConstant.TYPE_STONE) //это,чтоб для первой комбинации собирал, если убрать, то будет по самой лучшей
//				{
//					this.__delateArr = new Array();
//					return;
//				}
				var pt:Point = this.__target;
				lastType = this.__field[pt.x][pt.y].type;
			}
			
			this.__delateArr = new Array();
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