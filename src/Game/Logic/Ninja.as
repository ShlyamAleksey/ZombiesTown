package Game.Logic
{
	import Game.Constants.ItemsConstant;
	
	import flash.geom.Point;

	public class Ninja extends Zombie
	{
		public function Ninja()
		{
			this.__type = ItemsConstant.TYPE_NINJA;
		}
		
		override protected function getNearEmptyCell(x:int, y:int):Point
		{
			var emptyNearCell:Array = new Array();
			
			for (var i:int = 0; i < this.__field.length; i++) 
			{
				for (var j:int = 0; j < this.__field.length; j++) 
				{
					if( this.__field[i][j].type == ItemsConstant.TYPE_ROAD ) emptyNearCell.push( new Point(i, j));
				}
				
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
	}
}