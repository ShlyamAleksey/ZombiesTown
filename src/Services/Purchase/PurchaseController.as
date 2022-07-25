package Services.Purchase
{
	import Services.Service;

	public class PurchaseController
	{
		
		static private var _init:PurchaseController
		
		static public function get instance():PurchaseController
		{
			if(!_init) _init = new PurchaseController();
			return _init; 
		}
		
		public function PurchaseController()
		{
		}
		
		public function init(res:*):void
		{
			for (var i:int = 0; i < res.response.purchases.length; i++) 
			{
				var pm:PurchaseModel 				= 	new PurchaseModel();
					pm.content_count 				= 	res.response.purchases[i].content_count;
					pm.description 					= 	res.response.purchases[i].description;
					pm.name 						= 	res.response.purchases[i].name;
					pm.price_hard 					= 	res.response.purchases[i].price_hard;
					pm.price_soft 					= 	res.response.purchases[i].price_soft;
					pm.purchase_id 					= 	res.response.purchases[i].purchase_id;
					pm.purchase_type_id 			= 	res.response.purchases[i].purchase_type_id;
					pm.social_id 					= 	res.response.purchases[i].social_id;
					
				Service.instance.purchaseModel.push(pm);
			}
		}
	}
}