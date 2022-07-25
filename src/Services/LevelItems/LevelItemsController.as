package Services.LevelItems
{
	import Services.Service;

	public class LevelItemsController
	{
		static private var __init:LevelItemsController
		
		static public function get instance():LevelItemsController
		{
			if(!__init) __init = new LevelItemsController();
			return __init;
		}
		
		public function init(o:Array):void
		{
			for (var i:int = 0; i < o.length; i++) 
			{
				var lim:LevelItemsModel = new LevelItemsModel();
				lim.points = o[i].points;
				lim.id = o[i].level_item_id;
				
				Service.instance.levelItemModel.push( lim );
			}
			
		}
	}
}