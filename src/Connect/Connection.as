package Connect
{
	import Connect.Local.URLConnector;

	public class Connection
	{
//		public var gateway:String = "http://app1.greemlins.com/zombietown/index.php?r=";
		public var gateway:String = "http://app-v3.greemlins.com/zombietown/index.php?r=";
		public var nc:URLConnector;
		
		static public var USER_ID:String = "0000034";
//		static public var USER_ID:String = "559416966944";
		
		
		public function Connection()
		{
		}
		
		public function initConnection():void
		{
			
		} 
		
		/**ИНФОРМАЦИЯ О ПОЛЬЗОВАТЕЛЕ*/
		public function userInfo(target:*, fun:Function):void
		{
	
		}
		
		protected function onFault(fault:Object):void { trace(String(fault.description));	}
	}
}