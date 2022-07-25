package Connect.OK
{
	import Connect.Jsons.JSON;
	import Connect.OK.adobe.images.JPGEncoder;
	import Connect.OK.adobe.images.MultipartData;
	
	import Game.Constants.Statics;
	
	import api.com.adobe.json.JSON;
	import api.com.odnoklassniki.Odnoklassniki;
	import api.com.odnoklassniki.events.ApiCallbackEvent;
	import api.com.odnoklassniki.events.ApiServerEvent;
	
	import com.demonsters.debugger.MonsterDebugger;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;

	/**
	 * ...
	 * @author Alex
	 */
	public class OKposter 
	{
		private var uid:String;
		private var helloCountryName:String;
		private var image:Bitmap;
		private var urlLoader:URLLoader = new URLLoader();
		private var gameName:String = "Зомби Town";
		private var gameUrl:String = "";
		private var albumDescription:String;
		private var albumTitle:String;
		private var photoDescription:String;
		
		public function OKposter(_image:Bitmap, _uid:String, helloCountryName:String, state:String="recipe"):void 
		{
			image = _image;
			uid = _uid;
			
			albumDescription = "Альбом из игры " + gameName + " " + gameUrl; 
			albumTitle = "Альбом из игры " + gameName + " " + gameUrl; 
			photoDescription = "Ура! У меня на " + Statics.CURRENT_LEVEL.toString() + " уровне получился прекрасный город!"; 
			
			getUserAlbums();
		}
		private function getUserAlbums():void 
		{
			MonsterDebugger.trace(this, "getAlbumsCalled");
			Odnoklassniki.callRestApi("photos.getAlbums", onGetAlbumsHandler, { }, "JSON", "POST");
		}
		private function onGetAlbumsHandler(response:*):void 
		{
			MonsterDebugger.trace(this, response, "", "getAlbumsResponse");
			for (var i:int = 0; i < response.albums.length; i++) 
			{
				if (response.albums[i].title== albumTitle) 
				{
					getUploadUrl(response.albums[i].aid);
					return;
				}
			}
			createAlbum();
		}
		private function createAlbum():void 
		{
			MonsterDebugger.trace(this, "createAlbum");
			Odnoklassniki.callRestApi("photos.createAlbum", onCreateAlbumHandler, {title:albumTitle,description:albumDescription,type:"public" }, "JSON", "POST");
		}
		private function onCreateAlbumHandler(response:*):void 
		{
			MonsterDebugger.trace(this, response, "", "createAlbumresponse");
			getUploadUrl(response);
		}
		private function getUploadUrl(aid:String):void 
		{
			MonsterDebugger.trace(this, aid, "", "getUploadUrl for this aid");
			Odnoklassniki.callRestApi("photosV2.getUploadUrl", onGetUploadUrlHandler, {uid:uid,aid:aid }, "JSON", "POST");
		}
		
		private function onGetUploadUrlHandler(response:*):void 
		{
			MonsterDebugger.trace(this, response, "", "getUploadUrl response");
			var jpgEncoder:JPGEncoder = new JPGEncoder(80);
			var jpgStream:ByteArray = jpgEncoder.encode(image.bitmapData);
			var urlRequest:URLRequest = new URLRequest(response.upload_url);
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.requestHeaders.push(new URLRequestHeader("Content-type", "multipart/form-data; boundary=" + MultipartData.BOUNDARY));
			var mdata:MultipartData = new MultipartData();
			mdata.addFile(jpgStream, "pic1");
			urlRequest.data = mdata.data;
			urlLoader.addEventListener(Event.COMPLETE, albumSavePhoto);
			urlLoader.load(urlRequest);
			
		}
		private function albumSavePhoto(e:Event):void 
		{
			MonsterDebugger.trace(this, "try to save photo");
			MonsterDebugger.trace(this, e.target.data);
			var data:Object = Connect.Jsons.JSON.decode(e.target.data as String);
			data = data.photos;
			MonsterDebugger.trace(this, data, "", "decoded json data");
						
			var photo_id:String;
			var token:String;
			for (var key:String in data) 
			{
				MonsterDebugger.trace(this, key, "", "key");
				photo_id = key;
				token = data[key].token;
				
			}
			
			Odnoklassniki.callRestApi("photosV2.commit", onEndPosting, { photo_id:photo_id,token:token,comment:photoDescription }, "JSON", "POST");
		}
		private function onEndPosting(response:*):void 
		{
			MonsterDebugger.trace(this, response, "", "end posting response");
		}
	}
	
}