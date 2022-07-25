package Game.Logic
{
	import Game.Constants.ItemsConstant;
	import Game.Model.FieldModel;
	import Game.UI.DropItemUI;
	import Game.Utils;
	
	import flash.geom.Point;

	public class Undo
	{
		static private var data:Array;
		static private var last_data:Array;
		
		static public var last_drop:int;
		static private var drop:int;
		
		public function Undo()
		{

		}
		
		static public function save():void
		{
			if(data) clone();
			last_drop = drop;
			
			data = Utils.cloneArray(FieldModel.instance.field);
			drop = DropItemUI.TYPE;
		}
		
		static public function execute():void
		{
			for (var i:int = 0; i < 6; i++) 
			{
				for (var j:int = 0; j < 6; j++) 
				{
					FieldModel.instance.field[i][j].type = last_data[i][j]
				}
			}
			save();
		}
		
		static public function execute2(pt:Point):void
		{
			FieldModel.instance.field[pt.x][pt.y].type = ItemsConstant.TYPE_ROAD;

			save();
		}
		
		static public function clone():void
		{
			last_data = new Array();
			for (var i:int = 0; i < 6; i++) 
			{
				last_data[i] = new Array();
				for (var j:int = 0; j < 6; j++) 
				{
					last_data[i][j] = data[i][j]
				}
			}
		}
		
		static public function console():void
		{
			var str:String = "";
			for (var i:int = 0; i < 6; i++) 
			{
				for (var j:int = 0; j < 6; j++) 
				{
					str = str + " " + FieldModel.instance.field[j][i].type;
				}
				trace(str);
				str = "";
			}
			trace("_________________");
		}
	}
}