package Game.Logic
{
	import Game.Constants.ItemsConstant;
	import Game.Constants.Statics;
	import Game.Model.ItemsModel;
	import Game.Utils;
	
	import flash.geom.Point;

	public class ItemsRandomCreater
	{
		static private var HERB_CHANCE					:int = 62;
		static private var BUSH_CHANCE					:int = 16;
		static private const TREE_CHANCE				:int = 1;
		static private const HUT_CHANCE					:int = 1;
		static private var ZOMBIE_CHANCE				:int = 15;
		static private var NINJA_CHANCE					:int = 0;
		static private const CRISTAL_CHANCE				:int = 2;
		static private const BOT_CHANCE					:int = 3;

		
		private var __field:Array;
		
		public function ItemsRandomCreater(field:Array)
		{
			this.__field = field;
			if(Statics.CURRENT_LEVEL > 20)
			{
				BUSH_CHANCE = 15;
				NINJA_CHANCE = 1;
			}
		}
		
		public function getRandomEmptyPlace():Point
		{
			var luckyNumber:int = Utils.random(100) + 1;
			var emptyPlaces:Array = new Array();
			var luckyCell:Point;
			
			for (var i:int = 0; i < this.__field.length; i++) 
			{
				for (var j:int = 0; j < this.__field.length; j++) 
				{
					if( (this.__field[i][j] as ItemsModel).type == ItemsConstant.TYPE_ROAD ) emptyPlaces.push( new Point(i, j) );
				}
			}
			
			if(luckyNumber == 100) luckyNumber = 99; // если число равно 100, то ячейку не получит, шанс ошибки 1 из 100
			luckyCell = emptyPlaces [ int( emptyPlaces.length * luckyNumber/100 ) ];
			return luckyCell;
		}
		
		public function getRandomType():int
		{
			var luckyNumber:int = Utils.random(100) + 1;
			var luckyType:int;
			
			if( luckyNumber <= CRISTAL_CHANCE) luckyType = ItemsConstant.TYPE_CRISTAL;
			
			if( luckyNumber > CRISTAL_CHANCE &&
				luckyNumber <= (CRISTAL_CHANCE + ZOMBIE_CHANCE)) luckyType = ItemsConstant.TYPE_ZOMBIE;
			
			if( luckyNumber > (CRISTAL_CHANCE + ZOMBIE_CHANCE) &&
				luckyNumber <= (CRISTAL_CHANCE + ZOMBIE_CHANCE + TREE_CHANCE)) luckyType = ItemsConstant.TYPE_TREE;
			
			if( luckyNumber > (CRISTAL_CHANCE + ZOMBIE_CHANCE + TREE_CHANCE) &&
				luckyNumber <= (CRISTAL_CHANCE + ZOMBIE_CHANCE + TREE_CHANCE + HERB_CHANCE)) luckyType = ItemsConstant.TYPE_HERBS;
			
			if( luckyNumber > (CRISTAL_CHANCE + ZOMBIE_CHANCE + TREE_CHANCE + HERB_CHANCE) &&
				luckyNumber <= (CRISTAL_CHANCE + ZOMBIE_CHANCE + TREE_CHANCE + HERB_CHANCE + BUSH_CHANCE)) luckyType = ItemsConstant.TYPE_BUSH;
			
			if( luckyNumber > (CRISTAL_CHANCE + ZOMBIE_CHANCE + TREE_CHANCE + HERB_CHANCE + BUSH_CHANCE) &&
				luckyNumber <= (CRISTAL_CHANCE + ZOMBIE_CHANCE + TREE_CHANCE + HERB_CHANCE + BUSH_CHANCE + HUT_CHANCE)) luckyType = ItemsConstant.TYPE_HUT;
			
			if( luckyNumber > (CRISTAL_CHANCE + ZOMBIE_CHANCE + TREE_CHANCE + HERB_CHANCE + BUSH_CHANCE + HUT_CHANCE) &&
				luckyNumber <= (CRISTAL_CHANCE + ZOMBIE_CHANCE + TREE_CHANCE + HERB_CHANCE + BUSH_CHANCE + HUT_CHANCE + NINJA_CHANCE)) luckyType = ItemsConstant.TYPE_NINJA;
			
			if( luckyNumber > (CRISTAL_CHANCE + ZOMBIE_CHANCE + TREE_CHANCE + HERB_CHANCE + BUSH_CHANCE + HUT_CHANCE + NINJA_CHANCE) &&
				luckyNumber <= (CRISTAL_CHANCE + ZOMBIE_CHANCE + TREE_CHANCE + HERB_CHANCE + BUSH_CHANCE + HUT_CHANCE + NINJA_CHANCE + BOT_CHANCE)) luckyType = ItemsConstant.TYPE_BOT;
			
			return luckyType;
		}
	}
}