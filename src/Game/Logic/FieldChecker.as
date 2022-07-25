package Game.Logic
{
	import Connect.OK.ApiCallbackEvent;
	import Connect.OK.ForticomAPI;
	
	import Events.GameEvent;
	
	import GUI.InteractiveTutorial.Tutorial;
	import GUI.Windows.BotShop;
	import GUI.Windows.ItemsShop;
	import GUI.Windows.WindowsManager;
	
	import Game.Constants.ItemsConstant;
	import Game.Constants.Statics;
	import Game.Model.FieldModel;
	import Game.Model.ItemsModel;
	import Game.UI.DropItemUI;
	import Game.UI.EmerPoint;
	import Game.UI.boxAnim;
	import Game.Utils;
	
	import GlobalLogic.LevelManager;
	
	import Services.LevelItems.LevelItemsModel;
	import Services.Levels.LevelModel;
	import Services.Service;
	import Services.User.UserModel;
	
	import Sounds.GameMusic;
	import Sounds.boxSoundType;
	
	import com.demonsters.debugger.MonsterDebugger;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;

	public class FieldChecker
	{
		static public var MUST_GIVE_CRISTAL:Boolean = false;;
		
		private var __storage:int = 0;
		
		private var __field:Array;
		private var __target:Point;
		private var __type:int;
		
		private var __zombie__checker:Zombie;
		private var __ninja__checker:Zombie;
		private var __grave__changer:GraveChanger;
		private var __check_grave:CheckGrave;
		private var __cristal:Cristal;
		
		private var __parent:FieldModel;
		
		private var __turnsItem:Array = new Array();
		
		static public var completeFlag:Boolean = false;
		static public var FULL_FIELD:Boolean = false;
		static public var ZOMBIE_ID_COUNTER	:int = 0;
		
		
		
		private var __delateArr:Array = new Array()//массив отобранных для удаления фигур
		
		public function FieldChecker(field:Array, target:Point, type:int, parent:FieldModel)
		{
			FULL_FIELD = false;
			this.__target = target;
			this.__field = field;
			this.__type = type;
			this.__parent = parent;
			
			if(ItemsModel.PUT__STORAGE) return;
			if(ItemsModel.BUY__ITEM) return;
			if(MUST_GIVE_CRISTAL) return;
			
			if(this.__type == ItemsConstant.TYPE_ZOMBIE)
			{
				ZOMBIE_ID_COUNTER++;
				this.__field[target.x][target.y].zombieID =  ZOMBIE_ID_COUNTER;
			}
			
			this.__zombie__checker = new Zombie();
			this.__ninja__checker = new Ninja();
			this.__grave__changer = new GraveChanger();
			this.__check_grave = new CheckGrave();
			this.__cristal = new Cristal();
			
			if(!Service.instance.userModel.life.is_unlimit)
			{
					Service.instance.userModel.life.count--;					
			}
			
			switch(this.__type)
			{
				case ItemsConstant.TYPE_BOT:
					EmerPoint.EMER_COUNT = 0;
					if( this.__field[target.x][target.y].type == ItemsConstant.TYPE_ZOMBIE ||
						this.__field[target.x][target.y].type == ItemsConstant.TYPE_NINJA )
					{
					
					}
					else
					{
						var im:LevelItemsModel = Utils.getItemModelByType(this.__field[target.x][target.y].type);
						Service.instance.userModel.points -= im.points;
						EmerPoint.EMER_COUNT = -im.points;
						
						DropItemUI.POSITION = target.clone();
						ItemsModel.BUY__ITEM = true;
						ItemsShop.BOUGHT_ITEM = ItemsConstant.TYPE_HERBS;
						DropItemUI.TYPE = ItemsShop.BOUGHT_ITEM;
					}
					
					setupBot();
					dispatchAllEvents();
					this.__parent.field = this.__field;
					break;
				
				case ItemsConstant.TYPE_CRISTAL:
					DropItemUI.POSITION = null;
					this.__cristal.startup( this.__field, this.__target );
					this.__type = this.__cristal.lastType;
					checkField();
					getFullFiel();
					zombieAndOther();
					checkField2();
					dispatchAllEvents();
					
					getFullFiel();
					__parent.dispatchGameEvent(GameEvent.CHANGE_FIELD);
					
					break;
				
				default:
					DropItemUI.POSITION = null;
					checkField();
					getFullFiel();
					zombieAndOther();
					dispatchAllEvents();
					//checkField2();
					getFullFiel();
					break;
			}	
			
			if(FULL_FIELD) 
			{
				var __um:UserModel = Service.instance.userModel;
				if(__um.points < Service.instance.levelModel[Statics.CURRENT_LEVEL - 1].reguiredPoints)
				{
					WindowsManager.instance.show( BotShop );
				}
			}
		}

		private function zombieAndOther():void
		{
			this.__zombie__checker.moveZombie( this.__field );
			this.__ninja__checker.moveZombie( this.__field );
			
			this.__grave__changer.startUp( this.__field );
			this.__check_grave.startup(this.__field);
			
//			dispatchAllEvents();

			this.__parent.field = this.__field;
		}	
		
		private function dispatchAllEvents():void
		{
			this.__parent.dispatchGameEvent( GameEvent.ZOMBIE_MOVE, {	"newPosition" : this.__zombie__checker.newZombiesPoss,
				"oldPosition" : this.__zombie__checker.oldZombiesPoss,
				"target" : this.__target} );
			
			this.__parent.dispatchGameEvent( GameEvent.NINJA_MOVE, {	"newPosition" : this.__ninja__checker.newZombiesPoss,
				"oldPosition" : this.__ninja__checker.oldZombiesPoss,
				"target" : this.__target} );
			
			this.__parent.dispatchGameEvent( GameEvent.ITEMS_CHECK, {"turns" : this.__turnsItem, "target" : this.__target} );
			this.__parent.dispatchGameEvent( GameEvent.GRAVE_CHECK, {"turns" : this.__check_grave.__turnsItem, "target" : this.__check_grave.target} );
			
			this.__parent.dispatchGameEvent( GameEvent.COMPLETE_ANIM , { "fun" : updateParentField } );
		}
		private function updateParentField():void
		{
			
		}
		
		private function setupBot():void
		{
			var pt:Point = this.__target;
			
			if( this.__field[pt.x][pt.y].type == ItemsConstant.TYPE_NINJA || this.__field[pt.x][pt.y].type == ItemsConstant.TYPE_ZOMBIE ) this.__field[pt.x][pt.y].type = ItemsConstant.TYPE_GRAVE;
			else this.__field[pt.x][pt.y].type = ItemsConstant.TYPE_ROAD;	
		}
		
		private function checkField():void
		{
			var pt:Point = this.__target;
			this.__field[pt.x][pt.y].type = this.__type;		
			
			var im:LevelItemsModel = Utils.getItemModelByType(this.__field[pt.x][pt.y].type);
					Service.instance.userModel.points += im.points;
					EmerPoint.EMER_COUNT = im.points;
					
			
			startCheck(ItemsConstant.TYPE_HERBS, ItemsConstant.TYPE_BUSH, ItemsConstant.TYPE_SUPER_BUSH);
			startCheck(ItemsConstant.TYPE_BUSH, ItemsConstant.TYPE_TREE, ItemsConstant.TYPE_SUPER_TREE);
			startCheck(ItemsConstant.TYPE_TREE, ItemsConstant.TYPE_HUT, ItemsConstant.TYPE_HUT);
			startCheck(ItemsConstant.TYPE_HUT, ItemsConstant.TYPE_HOUSE, ItemsConstant.TYPE_SUPER_HOUSE);
			startCheck(ItemsConstant.TYPE_HOUSE, ItemsConstant.TYPE_CASTLE, ItemsConstant.TYPE_CASTLE);
			startCheck(ItemsConstant.TYPE_CASTLE, ItemsConstant.TYPE_ROAD, ItemsConstant.TYPE_ROAD);	
		}
		
		private function checkField2():void
		{
			
			startCheck(ItemsConstant.TYPE_HERBS, ItemsConstant.TYPE_BUSH, ItemsConstant.TYPE_SUPER_BUSH);
			startCheck(ItemsConstant.TYPE_BUSH, ItemsConstant.TYPE_TREE, ItemsConstant.TYPE_SUPER_TREE);
			startCheck(ItemsConstant.TYPE_TREE, ItemsConstant.TYPE_HUT, ItemsConstant.TYPE_HUT);
			startCheck(ItemsConstant.TYPE_HUT, ItemsConstant.TYPE_HOUSE, ItemsConstant.TYPE_SUPER_HOUSE);
			startCheck(ItemsConstant.TYPE_HOUSE, ItemsConstant.TYPE_CASTLE, ItemsConstant.TYPE_CASTLE);
			startCheck(ItemsConstant.TYPE_CASTLE, ItemsConstant.TYPE_ROAD, ItemsConstant.TYPE_ROAD);
			startCheck(ItemsConstant.TYPE_CHERCH, ItemsConstant.TYPE_HOSTEL, ItemsConstant.TYPE_HOSTEL);
			startCheck(ItemsConstant.TYPE_HOSTEL, ItemsConstant.TYPE_ROAD, ItemsConstant.TYPE_ROAD);
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
			
				
			if( this.__field[pt.x][pt.y].type ==  ItemsConstant.TYPE_CASTLE || this.__field[pt.x][pt.y].type ==  ItemsConstant.TYPE_HOSTEL) 
			{
				MUST_GIVE_CRISTAL = true;
				boxAnim(pt);
			}
			
			if(pt.x == 0 && pt.y == 0) pt = this.__delateArr[0].position.clone();
			
			for(var i:int = 0; i < this.__delateArr.length; i++)
			{
				this.__turnsItem.push( this.__delateArr[i].position );
				this.__delateArr[i].type = ItemsConstant.TYPE_ROAD;
			}

			if(this.__delateArr.length == 3)
			{
				this.__field[pt.x][pt.y].type = nextType;
				GameMusic.music.playSound( boxSoundType.SCombo );
			}
			if(this.__delateArr.length > 3) 
			{
				this.__field[pt.x][pt.y].type = superType;
				GameMusic.music.playSound( boxSoundType.SCombo );
			}
			
			var im:LevelItemsModel = Utils.getItemModelByType(this.__field[pt.x][pt.y].type);
			Service.instance.userModel.points += im.points;
			EmerPoint.EMER_COUNT = im.points;
			
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
		
		private function getFullFiel():void
		{
			FULL_FIELD = true;
			
			for (var i:int = 0; i < this.__field.length; i++) 
			{
				for (var j:int = 0; j < this.__field.length; j++) 
				{
					if(this.__field[i][j].type == ItemsConstant.TYPE_ROAD)
					{
						FULL_FIELD = false;
					}
				}
			}	
		}
		
		public function get field():Array
		{
			return this.__field;
		}
	}
}