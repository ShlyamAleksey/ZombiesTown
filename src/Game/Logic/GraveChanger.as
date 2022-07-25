package Game.Logic
{
	import Game.Constants.ItemsConstant;
	import Game.Model.ItemsModel;
	
	import flash.geom.Point;
	import Game.Utils;

	public class GraveChanger
	{
		private var __field:Array;
		private var __roadField:Array;
		
		private var __alreadyCheckArr:Array = new Array() //массив уже провереных
		private var __road__group:Array = new Array();	
		
		public function GraveChanger()
		{
		}
		
		public function startUp(field:Array):void
		{
			this.__field = field;
			this.__roadField = Utils.cloneArray( field );
			
			changeZombiesInRoad();
			checkRoadGroup();
			returnZombieFromRoad();
			comparisonZombieAndRoad();
			
		}
		
		/**Сравниваем дорогу с зомби*/
		private function comparisonZombieAndRoad():void
		{
			var emptyPlaceFlag:Boolean = false;
			
			for (var i:int = 0; i < this.__road__group.length; i++) 
			{
				emptyPlaceFlag = false;
				
				for (var j:int = 0; j < this.__road__group[i].length; j++) 
				{
					var pt:Point = this.__road__group[i][j].position
					if(FieldChecker.FULL_FIELD)
					{
						if( this.__field[pt.x][pt.y].type == ItemsConstant.TYPE_ROAD) emptyPlaceFlag = true;
					}
					else
					{
						if( this.__field[pt.x][pt.y].type == ItemsConstant.TYPE_ROAD || this.__field[pt.x][pt.y].type == ItemsConstant.TYPE_NINJA) emptyPlaceFlag = true;
					}
				}	
				
				if( !emptyPlaceFlag ) turnToGrave(i);
			}
		}
		
		/**Превращаем зомби в могилу*/
		private function turnToGrave(groupNum:int):void
		{
			for (var i:int = 0; i < this.__road__group[groupNum].length; i++) 
			{
				this.__road__group[groupNum][i].type = ItemsConstant.TYPE_GRAVE;
			}	
		}
		
		/**Возвращаем назад зомби в дорогу*/
		private function returnZombieFromRoad():void
		{
			for (var i:int = 0; i < this.__field.length; i++) 
			{
				for (var j:int = 0; j < this.__field.length; j++) 
				{
					if( this.__roadField[i][j] == ItemsConstant.TYPE_ZOMBIE ) this.__field[i][j].type = ItemsConstant.TYPE_ZOMBIE;
					if( this.__roadField[i][j] == ItemsConstant.TYPE_NINJA ) this.__field[i][j].type = ItemsConstant.TYPE_NINJA;
				}
			}
		}
		
		/**Ищем группы из дорог*/
		private function checkRoadGroup():void
		{
			for(var i:int = 0; i < this.__field.length; i++)	
			{
				for(var j:int = 0; j < this.__field.length; j++)
				{
					if(this.__field[i][j].type == ItemsConstant.TYPE_ROAD)
					{
						this.__alreadyCheckArr.push( this.__field[i][j] );
						checkNeighbour(i, j);
					} 
					recordRoadGroup();
				}
			}	
			fromSpecialTypeToZombie();
		}
		
		/**Записываем в масив группы из дорог*/
		private function recordRoadGroup():void
		{
			for(var i:int = 0; i < this.__alreadyCheckArr.length; i++)
			{
				this.__alreadyCheckArr[i].type = ItemsConstant.TYPE_SPECIAL_ROAD_GROUP; //меняем тип, чтоб снова не проверять уже проверенные
			}
			
			if(this.__alreadyCheckArr.length)
			{
				this.__road__group.push(this.__alreadyCheckArr);
				this.__alreadyCheckArr = new Array();
			}	
		}
		
		/**Возвращаем из специального типа назад в тип дорог*/
		private function fromSpecialTypeToZombie():void
		{
			for(var i:int = 0; i < this.__field.length; i++)	
			{
				for(var j:int = 0; j < this.__field.length; j++)
				{
					if(this.__field[i][j].type == ItemsConstant.TYPE_SPECIAL_ROAD_GROUP)
					{
						this.__field[i][j].type = ItemsConstant.TYPE_ROAD;
					}
				}
			}
		}
		
		/***Меняем в новом масиве зомби на дорогу*/
		private function changeZombiesInRoad():void
		{
			for (var i:int = 0; i < this.__field.length; i++) 
			{
				for (var j:int = 0; j < this.__field.length; j++) 
				{
					if( this.__field[i][j].type == ItemsConstant.TYPE_ZOMBIE || this.__field[i][j].type == ItemsConstant.TYPE_NINJA) this.__field[i][j].type = ItemsConstant.TYPE_ROAD;
				}
			}	
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