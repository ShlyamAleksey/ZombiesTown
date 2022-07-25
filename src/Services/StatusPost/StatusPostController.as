package Services.StatusPost
{
	import Services.Service;

	public class StatusPostController
	{
		static private var _init:StatusPostController
		
		public function init(res:*):void
		{
			Service.instance.statusPostModel.needStatusPost = res.need_status_post;
			Service.instance.statusPostModel.rewardCurrency = res.reward_currency_soft;
		}
		
		static public function get instance():StatusPostController
		{
			if(!_init) _init = new StatusPostController();
			return _init; 
		}
		
		public function StatusPostController()
		{
		}
	}
}