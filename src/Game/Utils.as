package Game
{
	import Game.Constants.ItemsConstant;
	import Game.Model.ItemsModel;
	
	import Services.LevelItems.LevelItemsModel;
	import Services.Levels.LevelModel;
	import Services.Service;
	
	import flash.geom.Point;

	public class Utils
	{
		/**Ищет произвольное число*/
		static public function random(value:int):int
		{
			return int(Math.random()*value);
		}
		
		/**Ищет произвольную точку*/
		static public function randomPoint(value:int):Point
		{
			return new Point( int(Math.random()*value), int(Math.random()*value) ); 							
		}
		
		/**Переводит координаты в позицию*/
		static public function Arr2Poss(pt:Point):Point
		{
			var position:Point = new Point();
			
			position.x = pt.x*80 + 55;
			position.y = pt.y*80 + 145;
			
			return position;
		}
		
		/**Переводит позицию в координаты*/
		static public function Poss2Arr(pt:Point):Point
		{
			var position:Point = new Point();
			position.x = getIndexByCoord(pt.x - 55, 55);
			position.y = getIndexByCoord(pt.y - 145, 145);
			
			return position;
		}
		
		/**Находит индекс по координатам*/
		static private function getIndexByCoord( coord:int, limit:int):int
		{
			if( (coord > limit) || (coord < 80*6 + limit) )
			{
				var index:int = 6;
				for(var i:int = 0; i <= 6; i++)
				{
					if( i * 80 > coord )
					{
						index = i - 1;
						break;
					}
				}
			}
			
			if(index == -1) index = 0;			
			if(index > 5) index = 5;
			
			return index;
		}
		
		/**Копирует в новый масив типы из текущего масива*/
		static public function cloneArray(arr:Array):Array
		{
			var newArr:Array = new Array();
			for (var i:int = 0; i < arr.length; i++) 
			{
				newArr.push(new Array());
				for (var j:int = 0; j < arr.length; j++) 
				{
					newArr[i][j] = arr[i][j].type;
				}
			}
			return newArr;
		}
		
		/**Ищет по типу нужную модель итема*/
		static public function getItemModelByType(type:int):LevelItemsModel
		{
			var im:LevelItemsModel;
			var lim:Vector.<LevelItemsModel> = Service.instance.levelItemModel;
			var id:String;
			
			for (var i:int = 0; i < ItemsConstant.ALL_NAME.length; i++) 
			{
				if(ItemsConstant[ "TYPE_" + ItemsConstant.ALL_NAME[i] ] == type)
				{
					id = ItemsConstant[ "ID_" + ItemsConstant.ALL_NAME[i]];
				}
			}

			for (var j:int = 0; j < lim.length; j++) 
			{
				if( lim[j].id == id )
				{
					im = lim[j]; 
				}
			}
			
			if( im == null )
			{
				im = lim[lim.length - 1];
			}
			
			return im;
		}
		
		static public function nameByType(type:int):String
		{
			for (var i:int = 0; i < ItemsConstant.ALL_NAME.length; i++) 
			{
				if(ItemsConstant[ "TYPE_" + ItemsConstant.ALL_NAME[i] ] == type)
				{
					return ItemsConstant[ "NAME_" + ItemsConstant.ALL_NAME[i]] ;
				}
			}			
			return "";
		}
		
		static public function randomCount(arr:Array, count:int):Array
		{
			var pointsList:Array = new Array();
			
			for (var i:int = 0; i < count; i++) { check(); }
			
			function check():void
			{
				var pt:Point = randomPoint(arr.length);
				if(arr[ pt.x ][ pt.y ] != null)
				{
					check();
					return;
				}
				else
				{
					arr[ pt.x ][ pt.y ] = new Object();
					pointsList.push( pt ); 
					return;
				}
			}
			
			return pointsList;
		}	
	}
}