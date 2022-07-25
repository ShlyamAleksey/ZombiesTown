package Services
{
	import Services.LevelItems.LevelItemsModel;
	import Services.Levels.LevelModel;
	import Services.Purchase.PurchaseModel;
	import Services.StatusPost.StatusPostModel;
	import Services.User.UserModel;

	public class Service
	{
		static private var __init:Service;
		
		private var __userModel:UserModel;
		private var __statisPostModel:StatusPostModel;
		private var __levelModel:Vector.<LevelModel>;
		private var __levelItemModel:Vector.<LevelItemsModel>;
		private var __purchaseModel:Vector.<PurchaseModel>;
		private var __bonusModel:BonusModel;
		private var __friendModel:Vector.<FriendModel>;
		private var __friendGiftsModel:Vector.<FriendGiftsModel>;
		
		
		public function get friendGiftsModel():Vector.<FriendGiftsModel>
		{
			return __friendGiftsModel;
		}

		public function set friendGiftsModel(value:Vector.<FriendGiftsModel>):void
		{
			__friendGiftsModel = value;
		}

		public function get friendsModel():Vector.<FriendModel>
		{
			return __friendModel;
		}

		public function set friendsModel(value:Vector.<FriendModel>):void
		{
			__friendModel = value;
		}

		static public function get instance():Service
		{
			if(!__init) __init = new Service();
			return __init; 
		}
		
		public function get userModel():UserModel
		{
			if(!__userModel) __userModel = new UserModel();
			return __userModel;
		}
		
		public function get statusPostModel():StatusPostModel
		{
			if(!__statisPostModel) __statisPostModel = new StatusPostModel();
			return __statisPostModel;
		}
		
		public function get levelModel():Vector.<LevelModel>
		{
			if(!__levelModel) __levelModel = new Vector.<LevelModel>();
			return __levelModel;
		}
		
		public function get levelItemModel():Vector.<LevelItemsModel>
		{
			if(!__levelItemModel) __levelItemModel = new Vector.<LevelItemsModel>();
			return __levelItemModel;
		}
		
		public function get purchaseModel():Vector.<PurchaseModel>
		{
			if(!__purchaseModel) __purchaseModel = new Vector.<PurchaseModel>();
			return __purchaseModel;
		}
		
		public function get bonusModel():BonusModel
		{
			if(!__bonusModel) __bonusModel = new BonusModel();
			return __bonusModel;
		}
	}
}