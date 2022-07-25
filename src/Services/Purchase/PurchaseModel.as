package Services.Purchase
{
	import Events.ServiceEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class PurchaseModel extends EventDispatcher
	{
		private var __content_count:int;
		private var __description:String;
		private var __name:String;
		private var __price_hard:int;
		private var __price_soft:int;
		private var __purchase_type_id:String;
		private var __purchase_id:String;
		private var __social_id:String;
		
		public function PurchaseModel(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		
		
		public function get social_id():String
		{
			return __social_id;
		}

		public function set social_id(value:String):void
		{
			__social_id = value;
			dispatchEvent(new Event( ServiceEvent.PURCHASE_SERVICE ));
		}

		public function get purchase_id():String
		{
			return __purchase_id;
		}

		public function set purchase_id(value:String):void
		{
			__purchase_id = value;
			dispatchEvent(new Event( ServiceEvent.PURCHASE_SERVICE ));
		}

		public function get purchase_type_id():String
		{
			return __purchase_type_id;
		}

		public function set purchase_type_id(value:String):void
		{
			__purchase_type_id = value;
			dispatchEvent(new Event( ServiceEvent.PURCHASE_SERVICE ));
		}

		public function get price_soft():int
		{
			return __price_soft;
		}

		public function set price_soft(value:int):void
		{
			__price_soft = value;
			dispatchEvent(new Event( ServiceEvent.PURCHASE_SERVICE ));
		}

		public function get price_hard():int
		{
			return __price_hard;
		}

		public function set price_hard(value:int):void
		{
			__price_hard = value;
			dispatchEvent(new Event( ServiceEvent.PURCHASE_SERVICE ));
		}

		public function get name():String
		{
			return __name;
		}

		public function set name(value:String):void
		{
			__name = value;
			dispatchEvent(new Event( ServiceEvent.PURCHASE_SERVICE ));
		}

		public function get description():String
		{
			return __description;
		}

		public function set description(value:String):void
		{
			__description = value;
			dispatchEvent(new Event( ServiceEvent.PURCHASE_SERVICE ));
		}

		public function get content_count():int
		{
			return __content_count;
		}

		public function set content_count(value:int):void
		{
			__content_count = value;
			dispatchEvent(new Event( ServiceEvent.PURCHASE_SERVICE ));
		}

	}
}