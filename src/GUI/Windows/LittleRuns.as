package GUI.Windows
{
	import Connect.ServiceHandler;
	
	import Game.Logic.Pause;
	
	import Services.Service;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class LittleRuns extends LittleRuns_GUI
	{
		private var _count:int = 0;
		static public var IS_OPEN:Boolean = false;

		public function LittleRuns()
		{
			super();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		private function init(e:Event = null):void
		{
			Pause.stop = true;
			removeEventListener(Event.ADDED_TO_STAGE, init);
			closeBtn.addEventListener(MouseEvent.CLICK, closeWin);
			buyBtn.addEventListener(MouseEvent.CLICK, paymentCall);
			IS_OPEN = true;
			
			this.descriptionTF.text = Service.instance.purchaseModel[8].content_count.toString() + " ходов =  " + Service.instance.purchaseModel[8].price_soft
		}
		
		protected function closeWin(event:MouseEvent):void
		{
			WindowsManager.instance.hide();
		}
		
		
		protected function paymentCall(e:MouseEvent):void
		{
			_count = Service.instance.purchaseModel[8].content_count;
			makePurchase(8);
		}
		
		private function makePurchase(bonusOrder:int):void
		{
			ServiceHandler.instance.softPurchase(this, function (res:*):void
			{
				if(res.response.message != "Not enough currency soft")
				{
					Service.instance.userModel.currencySoft -= Service.instance.purchaseModel[bonusOrder].price_soft;
					Service.instance.userModel.life.count += _count;
					Service.instance.userModel.life = Service.instance.userModel.life;
					WindowsManager.instance.hide();
				}
				else
				{
					WindowsManager.instance.show( DollarShop );
				}
			}
				, Service.instance.userModel.playerId, Service.instance.purchaseModel[bonusOrder].purchase_id);		
		}
		
		private function destroy(event:Event):void
		{
			IS_OPEN = false;
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);	
			closeBtn.removeEventListener(MouseEvent.CLICK, closeWin);
			buyBtn.removeEventListener(MouseEvent.CLICK, paymentCall);
		}
	}
}