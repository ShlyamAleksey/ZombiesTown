package Game.Logic
{
	import Game.Constants.ItemsConstant;
	import Game.Model.ItemsModel;
	
	import flash.geom.Point;

	public class Zombie
	{
		protected var __field:Array;
		protected var __type:int;
		
		public var newZombiesPoss:Array = new Array();
		public var oldZombiesPoss:Array = new Array();
		
		public function Zombie()
		{
			this.__type = ItemsConstant.TYPE_ZOMBIE;
		}
		
		public function moveZombie(field:Array):void
		{
			this.__field = field;
			
			for(var i:int = 0; i < this.__field.length; i++)	
			{
				for(var j:int = 0; j < this.__field.length; j++)
				{
					if( this.__field[i][j].type == this.__type && !this.__field[i][j].zombie__moved) 
					{
						var poss:Point = this.__field[i][j].position.clone();
						var pt:Point = getNearEmptyCell( poss.x, poss.y );
						if(pt) 
						{
							move(this.__field[i][j], pt);
						}
					}
				}
			}
			clearMovied();
		}
		
		/**Перемещаем в указаную точку*/
		protected function move(target:ItemsModel, pt:Point):void
		{
			target.type = ItemsConstant.TYPE_ROAD;
			
			this.__field[pt.x][pt.y].type = this.__type;
			this.__field[pt.x][pt.y].zombie__moved = true;
			
			this.__field[pt.x][pt.y].zombieID = target.zombieID;
			target.zombieID = 0;
		}
		
		/**Ищем ближайшую пустую ячейку*/
		protected function getNearEmptyCell(x:int, y:int):Point
		{
			var emptyNearCell:Array = new Array();
			
			//left
			if(this.__field[x-1] && this.__field[x-1][y] && (this.__field[x-1][y].type == ItemsConstant.TYPE_ROAD))
			{
				emptyNearCell.push( new Point(x - 1, y));
			} 
			//right
			if(this.__field[x+1] && this.__field[x+1][y] && (this.__field[x+1][y].type == ItemsConstant.TYPE_ROAD))
			{
				emptyNearCell.push( new Point(x + 1, y));
			} 
			//up
			if(this.__field[x][y-1] && (this.__field[x][y-1].type == ItemsConstant.TYPE_ROAD))
			{
				emptyNearCell.push( new Point(x, y - 1));
			} 
			//down
			if(this.__field[x][y+1] && (this.__field[x][y+1].type == ItemsConstant.TYPE_ROAD))
			{
				emptyNearCell.push( new Point(x, y + 1));
			} 

			if(emptyNearCell.length)
			{
				var rc:int = int( Math.random()*emptyNearCell.length )
				var pt:Point = emptyNearCell[rc];
				
				newZombiesPoss.push( pt );
				oldZombiesPoss.push( new Point( x, y ) );
				return pt;
			}
			else
			{
				return null;
			}
		}
		
		/**Все зомби могут двигаться*/
		private function clearMovied():void
		{
			for(var i:int = 0; i < this.__field.length; i++)	
			{
				for(var j:int = 0; j < this.__field.length; j++)
				{
					this.__field[i][j].zombie__moved = false;
				}
			}
		}
		
	}
}