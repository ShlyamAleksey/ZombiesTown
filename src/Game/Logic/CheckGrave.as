package Game.Logic
{
	import Game.Constants.ItemsConstant;
	import Game.UI.DropItemUI;
	
	import Sounds.GameMusic;
	import Sounds.boxSoundType;
	
	import flash.geom.Point;

	public class CheckGrave
	{
		private var __field:Array;
		private var __alreadyCheckArr:Array = new Array() //массив уже провереных
		public var __turnsItem:Array = new Array();
		public var target:int = 0;
			
		public function CheckGrave()
		{
			
		}
		
		public function startup(field:Array):void
		{
			this.__field = field;
			this.__turnsItem = new Array();
			
			startCheck(ItemsConstant.TYPE_GRAVE, ItemsConstant.TYPE_CHERCH);
			if(DropItemUI.TYPE != ItemsConstant.TYPE_CRISTAL)
			{
				startCheck(ItemsConstant.TYPE_CHERCH, ItemsConstant.TYPE_HOSTEL);
				startCheck(ItemsConstant.TYPE_HOSTEL, ItemsConstant.TYPE_ROAD);
			}
		}
		
		private function startCheck(currentType:int, nextType:int):void
		{
			for(var i:int = 0; i < this.__field.length; i++)	
			{
				for(var j:int = 0; j < this.__field.length; j++)
				{
					if(this.__field[i][j].id == currentType)
					{
						this.__alreadyCheckArr.push(this.__field[i][j]);
						checkNeighbour(i, j);
					} 
					setupNewItem(nextType);
				}
			}
		}
		
		private function setupNewItem(nextType:int):void
		{
			if(this.__alreadyCheckArr.length < 3)
			{
				this.__alreadyCheckArr = new Array();
				
				return;	
			}
			
			for(var i:int = 0; i < this.__alreadyCheckArr.length; i++)
			{
				this.__alreadyCheckArr[i].type = ItemsConstant.TYPE_ROAD;
			}
			
			this.__turnsItem.push( this.__alreadyCheckArr );
			this.target = lastID;
			var pt:Point = this.__alreadyCheckArr[lastID].position.clone();
			
			if(this.__alreadyCheckArr.length >= 3) 
			{
				GameMusic.music.playSound( boxSoundType.SCombo );
				this.__field[pt.x][pt.y].type = nextType;
			}
			
			this.__alreadyCheckArr = new Array();
		}
		
		/**Проверка на уже проверенных*/
		private function checkForDelate(x:int, y:int):Boolean
		{
			for(var d:int; d < this.__alreadyCheckArr.length; d++)
			{
				if(this.__field[x][y].position == this.__alreadyCheckArr[d].position) return true;
			}	
			return false;
		}
		
		/**Находим последнего поставленого зомби*/
		private function get lastID():int
		{
			var _id:int = 0;
			for (var i:int = 0; i < this.__alreadyCheckArr.length; i++) 
			{
				if( this.__alreadyCheckArr[_id].zombieID < this.__alreadyCheckArr[i].zombieID ) _id = i;
			}
	
			return _id;
		}
		
		/**Проверяем соседей*/
		private function checkNeighbour(x:int, y:int):void
		{					
			//left
			if(this.__field[x-1] && this.__field[x-1][y] && (this.__field[x][y].type == this.__field[x-1][y].type))
			{
				if(!checkForDelate(x-1, y))
				{
					this.__alreadyCheckArr.push(this.__field[x-1][y]);
					checkNeighbour(x-1, y);
				}
			} 
			//right
			if(this.__field[x+1] && this.__field[x+1][y] && (this.__field[x][y].type == this.__field[x+1][y].type))
			{
				if(!checkForDelate(x+1, y))
				{
					this.__alreadyCheckArr.push(this.__field[x+1][y]);
					checkNeighbour(x+1, y);
				}
			} 
			//up
			if(this.__field[x][y-1] && (this.__field[x][y].type == this.__field[x][y-1].type))
			{
				if(!checkForDelate(x, y-1))
				{
					this.__alreadyCheckArr.push(this.__field[x][y-1]);
					checkNeighbour(x, y-1);
				}
			} 
			//down
			if(this.__field[x][y+1] && (this.__field[x][y].type == this.__field[x][y+1].type))
			{
				if(!checkForDelate(x, y+1))
				{
					this.__alreadyCheckArr.push(this.__field[x][y+1]);
					checkNeighbour(x, y+1);
				}
			} 
		}
	}
}