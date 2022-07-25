package Services.Levels
{
	import Services.Service;

	public class LevelController
	{
		static private var __init:LevelController
		
		static public function get instance():LevelController
		{
			if(!__init) __init = new LevelController();
			return __init;
		}
		
		public function init(o:Array):void
		{
			for (var i:int = 0; i < o.length; i++) 
			{
				var lm:LevelModel = new LevelModel();
					lm.description = o[i].desc;
					lm.levelId = o[i].level_id;
					lm.name = o[i].name;
					lm.reguiredPoints = o[i].required_points;
					lm.rewardCurrencySoft = o[i].reward_currency_soft;
				
				Service.instance.levelModel.push( lm );
			}
			
		}
	}
}