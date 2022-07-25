package GlobalLogic
{
	public class TimeConverter
	{
		private var _value:int;
		
		public function TimeConverter(val:int)
		{
			this._value = val;
		}
		
		public function get value():int
		{
			return _value;
		}
		
		public function set value(val:int):void
		{
			_value = val;
		}
		
		public function get second():String
		{
			 return strConvert(this._value - int(this._value/60)*60);
		}
		
		public function get minute():String
		{
			return strConvert(int(this._value/60) - int(this._value/3600)*60);
		}
		
		public function get hour():String
		{	
			return strConvert(int(this._value/3600) - int(this._value/86400)*24);
		}
		
		public function get hour2():String
		{	
			return strConvert(int(this._value/3600));
		}
		
		public function get day():int
		{	
			return int(this._value/86400);
		}
		
		private function strConvert(val:int):String
		{
			if(val >= 10) return val.toString();
			else return "0" + val.toString();
		}
	}
}