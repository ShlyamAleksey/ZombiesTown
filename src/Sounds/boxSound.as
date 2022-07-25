package Sounds
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	public class boxSound
	{
		private var _type:String;
		private var _composition:Sound;
		private var _channel:SoundChannel;
		private var _time:Number = 0;
		private var _repead:Boolean;
		private var _volume:Number;
		
		public function boxSound(type:String, sound:Sound, volume:Number = 1, repead:Boolean = false)
		{
			_type = type;
			_composition = sound;
			_repead = repead;
			_volume = volume;
 		}
		
		public function play():void
		{
			var r:int = 0;
			if( _repead )
				r = int.MAX_VALUE;
			var tr:SoundTransform = new SoundTransform( _volume );
			_channel = _composition.play(_time, r, tr);
		}
		public function stop():void
		{
			if( _channel != null ){
				_time = _channel.position;
				_channel.stop();
			}
		}
		
		public function set volume(value:Number):void
		{
			_volume = value;
		}

		public function get type():String
		{
			return _type;
		}

		public function get composition():Sound
		{
			return _composition;
		}

	}
}