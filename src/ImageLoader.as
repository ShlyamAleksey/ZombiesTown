package 
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	public class ImageLoader extends Sprite
	{
		private var _url:String;
		private var _parent:MovieClip
		public var img:Loader = new Loader();
		private var _heightIMG:int;
		
		public function ImageLoader(url:String, target:MovieClip, heightIMG:int = 41)
		{
			super();
			_url = url;
			_parent = target;
			_heightIMG = heightIMG;
			
			if(_url != "" && _url != "null") 
			{
				initP();
			}
		}
		
		public function startLoad():void
		{
		
		}
		
		private function initP():void
		{					
			var pictURL:String = _url;
			
			var pictURLReq:URLRequest = new URLRequest(pictURL);
			img.load(pictURLReq); 
			
			_parent.addChild(img);
			img.contentLoaderInfo.addEventListener(Event.COMPLETE, cc);	
		}
		
		private function cc(e:Event):void 
		{	
			img.height = _heightIMG;
			img.scaleX = img.scaleY;
			
			img.contentLoaderInfo.removeEventListener(Event.COMPLETE, cc);
		}
	}
}