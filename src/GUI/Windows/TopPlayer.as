package GUI.Windows
{
	import Connect.ServerConnect;
	import Connect.ServiceHandler;
	
	import Services.Service;
	
	import Sounds.GameMusic;
	import Sounds.boxSoundType;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class TopPlayer extends TopPlayer_GUI
	{
		static public var CURRENT_TOP_PAGE:int = 0;
		static public const ITEM_COUNT:int = 6;
		static private var _init:TopPlayer;
		static public var resp:Object;
		
		public var memoryList:Array = new Array();
		private var _currentPage:int = 0;
		private var maxPage:int = 0;
		private var _defaultURL:String = "";
		private var _defaultName:String = "...";
		private var __myPlace:int = 0;
		private var __findMyPlacePage:int = 1;
		
		
		static public function get instance():TopPlayer
		{
			if(!_init) _init = new TopPlayer();
			return _init; 
		}
		
		public function TopPlayer()
		{
			super();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			closeBtn.addEventListener(MouseEvent.CLICK, closeWindow);
			prevPage.addEventListener(MouseEvent.CLICK, showPrevPage);
			nextPage.addEventListener(MouseEvent.CLICK, showNextPage);
			
			setParams(resp);
			prevPage.visible = false;
			
			setMyRealPlace();
			
			GameMusic.music.playSound( boxSoundType.SWindowOpen);
		}
		
		private function setMyPlace(res:*):void
		{
			if(__findMyPlacePage > 5) 
			{
				setMyRealPlace();
				return;
			}
			for (var i:int = 0; i < ITEM_COUNT; i++) 
			{
				if(res.response[i].player_id == Service.instance.userModel.playerId)
				{
					__myPlace = int(i+1) + (__findMyPlacePage - 1)*ITEM_COUNT;
				}
			}
			
			if(__myPlace == 0)
			{
				findMyPlace(__findMyPlacePage++);
			}
			else
			{
				myPlace.text = "Ваше место - " + __myPlace;
				return;
			}
		}
		
		private function setMyRealPlace():void
		{
			ServiceHandler.instance.myPlace(this, setPlace, Service.instance.userModel.playerId);
			
			function setPlace(res:*):void
			{
				myPlace.text = "Ваше место - " + int( int(res.response.position_total) - 1);
			}
		}
		
		protected function showNextPage(event:MouseEvent):void
		{			
			_currentPage++;
			
			if(_currentPage * ITEM_COUNT >= memoryList.length) showTop();
			else getInfoFromMemory();
			
			if(maxPage == _currentPage) nextPage.visible = false;
			prevPage.visible = true;
			showNumPage();
		}
		
		protected function showPrevPage(event:MouseEvent):void
		{
			
			if(_currentPage > 0)
			{
				_currentPage--;
				prevPage.visible = true;
				getInfoFromMemory();
			}
			
			if(_currentPage == 0) prevPage.visible = false;
			else prevPage.visible = true;
			
			nextPage.visible = true;
			showNumPage()
		}
		
		public function setParams(res:*):void
		{
			for (var i:int = 0; i < ITEM_COUNT; i++) 
			{
				if( !res.response[i] )
				{
					nextPage.visible = false;
					maxPage = _currentPage;
					clean(i);
				}
				else
				{
					if(res.response[ i ].first_name) this["fi_" + int(i+1)].firstTF.text = res.response[ i ].first_name;
					else this["fi_" + int(i+1)].firstTF.text = _defaultName;
					
					if(res.response[ i ].url_image) var url:String = res.response[ i ].url_image;
					else url = _defaultURL;
					
					if(res.response[ i ].points) this["fi_" + int(i+1)].levelTF.text = res.response[ i ].points;
					else this["fi_" + int(i+1)].levelTF.text = 1;
					
					var item:ImageLoader = new ImageLoader(url, this["fi_" + int(i+1)].img);
					var o:Object = { "fist_name" : this["fi_" + int(i+1)].firstTF.text,
						"img" : url,
						"level" : this["fi_" + int(i+1)].levelTF.text}
					
					memoryList.push(o);
				}
			}
		}
		
		public function clean(i:int):void
		{
			this["fi_" + int(i+1)].firstTF.text = _defaultName;
			var item:ImageLoader = new ImageLoader(_defaultURL, this["fi_" + int(i+1)].img);
			
			var o:Object = { "fist_name" : _defaultName,
				"img" : _defaultURL,
				"level" : 1}
				memoryList.push(o);
		}
		
		private function getInfoFromMemory():void
		{
			for (var i:int = 0; i < ITEM_COUNT; i++) 
			{
				if(memoryList[ i + ITEM_COUNT*_currentPage ]["fist_name"]) this["fi_" + int(i+1)].firstTF.text = memoryList[ i + ITEM_COUNT*_currentPage ]["fist_name"];
				if(memoryList[ i + ITEM_COUNT*_currentPage ]["img"]) var item = new ImageLoader(memoryList[ i + ITEM_COUNT*_currentPage ]["img"], this["fi_" + int(i+1)].img);
				if(memoryList[ i + ITEM_COUNT*_currentPage ]["level"]) this["fi_" + int(i+1)].levelTF.text = memoryList[ i + ITEM_COUNT*_currentPage ]["level"];
			}
		}
		
		private function showNumPage():void
		{
			for (var i:int = 0; i < ITEM_COUNT; i++) 
			{
				this["place_" + int(i+1)].text = int(i+1)+ _currentPage*ITEM_COUNT + " место";	
			}
		}
		
		private function showTop():void
		{
			ServiceHandler.instance.topPage(this, setParams, ServerConnect.SOCIAL_ID, ITEM_COUNT, _currentPage*ITEM_COUNT);
		}
		
		private function findMyPlace(page:int):void
		{
			ServiceHandler.instance.topPage(this, setMyPlace, ServerConnect.SOCIAL_ID, ITEM_COUNT, page*ITEM_COUNT);
		}
		
		protected function closeWindow(event:MouseEvent):void
		{	
			
			WindowsManager.instance.hide();
		}
		
		private function destroy(event:Event):void
		{			
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);	
			closeBtn.removeEventListener(MouseEvent.CLICK, closeWindow);
			prevPage.removeEventListener(MouseEvent.CLICK, showPrevPage);
			nextPage.removeEventListener(MouseEvent.CLICK, showNextPage);
			
		}
	}
}