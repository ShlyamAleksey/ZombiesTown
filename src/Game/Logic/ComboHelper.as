package Game.Logic
{
	import Events.GameEvent;
	
	import Game.Constants.ItemsConstant;
	import Game.Model.FieldModel;
	
	import flash.events.Event;
	import flash.geom.Point;
	import Game.Utils;

	public class ComboHelper
	{
		static private var __init:ComboHelper
		private var __model:FieldModel;
		
		private var __field:Array;
		private var __turnsItem:Array = new Array();
		private var __target:Point;
		private var __type:int;
		private var __typesSaver:Array;
		
		private var __delateArr:Array = new Array()//массив отобранных для удаления фигур
		
		static public function get instance():ComboHelper
		{
			if(!__init) __init = new ComboHelper();
			return __init;		
		}
		
		public function ComboHelper()
		{
			
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
		
		public function getParams(pt:Point, type:int):void
		{
			
			if(type == ItemsConstant.TYPE_CRISTAL) return;
			__target = pt.clone();
			__type = type;
			checkField();
			
			this.__model.dispatchGameEvent( GameEvent.SHOW_HELP, {"turns" : this.__turnsItem, "target" : this.__target} );
			this.__turnsItem = new Array();
		}
		
		private function cloneTypes():void
		{
			for (var i:int = 0; i < this.__field.length; i++) 
			{
				for (var j:int = 0; j < this.__field.length; j++) 
				{
					this.__field[i][j].type = __typesSaver[i][j]
				}	
			}		
		}
		
		private function checkField():void
		{
			__typesSaver = Utils.cloneArray(this.__field);
			
			var pt:Point = this.__target.clone();
			this.__field[pt.x][pt.y].type = this.__type;
			
			startCheck(ItemsConstant.TYPE_HERBS, ItemsConstant.TYPE_BUSH, ItemsConstant.TYPE_SUPER_BUSH);
			startCheck(ItemsConstant.TYPE_BUSH, ItemsConstant.TYPE_TREE, ItemsConstant.TYPE_SUPER_TREE);
			startCheck(ItemsConstant.TYPE_TREE, ItemsConstant.TYPE_HUT, ItemsConstant.TYPE_HUT);
			startCheck(ItemsConstant.TYPE_HUT, ItemsConstant.TYPE_HOUSE, ItemsConstant.TYPE_SUPER_HOUSE);
			startCheck(ItemsConstant.TYPE_HOUSE, ItemsConstant.TYPE_CASTLE, ItemsConstant.TYPE_CASTLE);
			startCheck(ItemsConstant.TYPE_CASTLE, ItemsConstant.TYPE_ROAD, ItemsConstant.TYPE_ROAD);	
			
			cloneTypes()
		}
		
		private function startCheck(currentType:int, nextType:int, superType:int):void
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
		}
		
		private function setupNewItem(nextType:int, superType:int):void
		{
			if(this.__delateArr.length < 3)
			{
				this.__delateArr = new Array();	
				return;	
			}
			
			var pt:Point = this.__target;
			
			if(pt.x == 0 && pt.y == 0) pt = this.__delateArr[0].position.clone();
			
			for(var i:int = 0; i < this.__delateArr.length; i++)
			{
				this.__turnsItem.push( this.__delateArr[i].position );
				this.__delateArr[i].type = ItemsConstant.TYPE_ROAD;
			}
			
			if(this.__delateArr.length == 3) this.__field[pt.x][pt.y].type = nextType;
			if(this.__delateArr.length > 3) this.__field[pt.x][pt.y].type = superType;
			
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