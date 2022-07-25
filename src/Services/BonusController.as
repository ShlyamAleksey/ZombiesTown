package Services
{
	public class BonusController
	{
		static private var _init:BonusController
		
		static public function get instance():BonusController
		{
			if(!_init) _init = new BonusController();
			return _init; 
		}
		
		public function init(res:*):void
		{
			if(res.response.bonus.daily_bonus != null) Service.instance.bonusModel.dailyBonus = res.response.bonus.daily_bonus;
			Service.instance.bonusModel.currentRewardCurrencySoft = res.response.friends.current_reward_currency_soft;
			Service.instance.bonusModel.currentRewardLifeCount = res.response.friends.current_reward_life_count;
		}
		
		public function BonusController()
		{
		}
	}
}