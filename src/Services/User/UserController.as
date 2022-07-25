package Services.User
{
	import Services.Service;

	public class UserController
	{
		static private var __init:UserController;

		
		public function init(o:Object):void
		{
			Service.instance.userModel.abs = o.abs;
			Service.instance.userModel.completedLevelIds = o.completed_levels_ids;
			Service.instance.userModel.currencySoft = o.currency_soft;
			Service.instance.userModel.currentLevelId = o.current_level_id;
			Service.instance.userModel.entryCount = o.entry_count;
			Service.instance.userModel.firstName = o.first_name;
			Service.instance.userModel.lastName = o.last_name;
			Service.instance.userModel.levelProgress = o.level_progress;
			Service.instance.userModel.life = o.life;
			Service.instance.userModel.playerId = o.player_id;
			Service.instance.userModel.points = o.points;
			Service.instance.userModel.urlImage = o.url_image;
			Service.instance.userModel.currentLevelsProgress = o.current_level_progress;
		}
		
		static public function get instance():UserController
		{
			if(!__init) __init = new UserController();
			return __init;
		}
	}
}