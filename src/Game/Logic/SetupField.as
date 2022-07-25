package Game.Logic
{
	import GUI.InteractiveTutorial.Tutorial;
	import GUI.Windows.Tutorial.Rulers_1;
	
	import Game.Command.StorageCommand;
	import Game.Constants.ItemsConstant;
	import Game.Model.FieldModel;
	import Game.Model.ItemsModel;
	import Game.Utils;
	
	import Services.Service;
	import Services.User.UserModel;
	
	import flash.geom.Point;

	public class SetupField
	{
		static public const ROAD_STARTUP_COUNT:int = 24;
		static public const HERB_STARTUP_COUNT:int = 5;
		static public const BUSH_STARTUP_COUNT:int = 2;
		static public const TREES_STARTUP_COUNT:int = 1;
		static public const GRAVE_STARTUP_COUNT:int = 1;
		static public const HOUSE_STARTUP_COUNT:int = 1;
		static public const ZOMBIES_STARTUP_COUNT:int = 1;
		
//		static public const ROAD_STARTUP_COUNT:int = 35;
//		static public const HERB_STARTUP_COUNT:int = 0;
//		static public const BUSH_STARTUP_COUNT:int = 0;
//		static public const TREES_STARTUP_COUNT:int = 0;
//		static public const GRAVE_STARTUP_COUNT:int = 0;
//		static public const HOUSE_STARTUP_COUNT:int = 0;
//		static public const ZOMBIES_STARTUP_COUNT:int = 0;
		
		private var __width:int;
		private var __height:int;
		private var __field:Array;
		private var  __um:UserModel = Service.instance.userModel;
		
		public function SetupField(w:int, h:int)
		{
			this.__width = w;
			this.__height = h;

			if( __um.currentLevelsProgress.hasOwnProperty("field") )
			{
				//loadMap()
				//return;
			}
			
			createMatrix();			
			pullField();
		}
		
		private function createMatrix():void
		{			
			this.__field = new Array();
			
			for (var i:int = 0; i < this.__width; i++) 
			{
				this.__field.push( new Array() );
			}			
		}
		
		private function loadMap():void
		{
			this.__field = __um.currentLevelsProgress.field;
			
			for (var i:int = 0; i < __width; i++) 
			{
				for (var j:int = 0; j < __height; j++) 
				{
					var pt:Point = new Point( this.__field[i][j].position.x, this.__field[i][j].position.y );
					this.__field[i][j].position = new Point(pt.x, pt.y);	
					
					var im:ItemsModel = new ItemsModel();
						im.id = this.__field[i][j].id;
						im.name = this.__field[i][j].name;
						im.position = this.__field[i][j].position.clone();
						im.type = this.__field[i][j].type;
						im.zombieID = this.__field[i][j].zombieID;
						im.zombie__moved = this.__field[i][j].zombie__moved;	
						
						this.__field[i][j] = im;
				}
				
			}
			
		}
		
		private function pullField():void
		{
			createStorage();
			createRoad();
			createHerb();
			createBush();
			createTrees();
			createGrave();
			createHouse();
			createZombie();
		}	
		
		public function get field():Array
		{
			return this.__field;
		}
		
		//Склад
		private function createStorage():void
		{
			this.__field[0][0] = createNewItem( new Point(), ItemsConstant.TYPE_STORAGE, ItemsConstant.NAME_STORAGE);
		}
		
		//Дорога
		private function createRoad():void
		{
			pushObjects(ROAD_STARTUP_COUNT,
						ItemsConstant.TYPE_ROAD,
						ItemsConstant.NAME_ROAD );
		}
		
		//Трава
		private function createHerb():void
		{
			pushObjects(HERB_STARTUP_COUNT,
						ItemsConstant.TYPE_HERBS,
						ItemsConstant.NAME_HERBS );
		}
		
		//Куст
		private function createBush():void
		{
			pushObjects(BUSH_STARTUP_COUNT,
						ItemsConstant.TYPE_BUSH,
						ItemsConstant.NAME_BUSH );
		}
		
		//Дерево
		private function createTrees():void
		{
			pushObjects(TREES_STARTUP_COUNT,
						ItemsConstant.TYPE_TREE,
						ItemsConstant.NAME_TREE );
		}

		//Могила
		private function createGrave():void
		{
			pushObjects(GRAVE_STARTUP_COUNT,
						ItemsConstant.TYPE_GRAVE,
						ItemsConstant.NAME_GRAVE );
		}
		
		//Дом
		private function createHouse():void
		{
			pushObjects(HOUSE_STARTUP_COUNT,
						ItemsConstant.TYPE_HUT,
						ItemsConstant.NAME_HUT );
		}
		
		//Зомби
		private function createZombie():void
		{
			pushObjects(ZOMBIES_STARTUP_COUNT,
						ItemsConstant.TYPE_ZOMBIE,
						ItemsConstant.NAME_ZOMBIE );
		}
		
		private function pushObjects(count:int, type:int, name:String):void
		{
			var emptyCell:Array = Utils.randomCount(this.__field, count);
			
			for (var i:int = 0; i < emptyCell.length; i++) 
			{
				this.__field[ emptyCell[i].x ][ emptyCell[i].y ] =  createNewItem( 	new Point( emptyCell[i].x, emptyCell[i].y ), type, name );
			}
		}
		
		private function createNewItem(pos:Point, type:int, name:String):ItemsModel
		{
			var im:ItemsModel = new ItemsModel();
				im.type = type;
				im.position = pos;
				im.name = name;	
				
				return im;
		}
	}
}