package Sounds
{

import com.greensock.loading.LoaderMax;
import com.greensock.loading.MP3Loader;

import flash.events.Event;

import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;

	public class GameMusic
	{

        static private var _instanse:GameMusic;
        static private var _canCreate:Boolean = false;

        static public function get music():GameMusic
		{
            if( !_instanse ){
                _canCreate = true;
                _instanse = new GameMusic();
                _canCreate = false;
            }
            return _instanse;
        }

        private var _curMusicBackGround:String;
		
		private var _musics:Vector.<boxSound>;
		private var _sounds:Vector.<boxSound>;
		
		private var _mute:Boolean = false;
        //private var _mute:Boolean = true;
        private var _loadComplete:Boolean;
        private var _callComplete:Function;
        private var _pool:String;
		
		public function GameMusic()
		{
            if( !_canCreate ){
                throw "Use instanse!";
            }
		}
		
        var queue:LoaderMax = new LoaderMax({name:"musicQueue", onComplete:completeHandler, onError:errorHandler});
        
		public function loadMusic():void
		{
            LoaderMax.defaultAuditSize = false;
			
            addToLoad( boxSoundType.SCombo );
			addToLoad( boxSoundType.SJump );
			addToLoad( boxSoundType.SPurchaise );
			addToLoad( boxSoundType.SPurchaise2 );
			addToLoad( boxSoundType.SUndo );
			addToLoad( boxSoundType.SWindowLoss );
			addToLoad( boxSoundType.SWindowOpen );
			
			addToLoad( boxSoundType.MMapBackGround );
			addToLoad( boxSoundType.MPlayBackground );
			addToLoad( boxSoundType.MVictory );
			addToLoad( boxSoundType.MDefeat );
			
            queue.load();

        }

        private function addToLoad( musicName:String ):void
		{
            var str:String = "http://static.greemlins.com/zombietown/Sounds/" + musicName + ".mp3";		
           		queue.append( new MP3Loader(str, {name:musicName, autoPlay:false}) );
        }

        private function completeHandler( event:Event ):void
		{
			initMusic();
			initSound();

            _callComplete();
            _loadComplete = true;
            if( _pool ){
                playMusic( _pool );
                _pool = null;
            }
        }

        private function errorHandler( event:Event ):void{
            trace( event );
        }
		
		private function initMusic():void
		{
			_musics = new Vector.<boxSound>();
			_musics.push( new boxSound( boxSoundType.MPlayBackground, queue.getContent( boxSoundType.MPlayBackground ), 0.2, true ) );
			_musics.push( new boxSound( boxSoundType.MMapBackGround, queue.getContent( boxSoundType.MMapBackGround ), 0.2, true )  );
			
			_musics.push( new boxSound( boxSoundType.MVictory, queue.getContent( boxSoundType.MVictory ), 0.2, false ) );
			_musics.push( new boxSound( boxSoundType.MDefeat, queue.getContent( boxSoundType.MDefeat ), 0.2, false )  );
			_curMusicBackGround = null;
		}
		
		private function initSound():void
		{
			_sounds = new Vector.<boxSound>();
			_sounds.push( new boxSound( boxSoundType.SJump, 	queue.getContent( boxSoundType.SJump  ), 0.5 ) );
			_sounds.push( new boxSound( boxSoundType.SCombo, 	queue.getContent( boxSoundType.SCombo ) ) );
			_sounds.push( new boxSound( boxSoundType.SPurchaise, 	queue.getContent( boxSoundType.SPurchaise ) ) );
			_sounds.push( new boxSound( boxSoundType.SPurchaise2, 	queue.getContent( boxSoundType.SPurchaise2 ) ) );
			_sounds.push( new boxSound( boxSoundType.SUndo, 	queue.getContent( boxSoundType.SUndo ) ) );
			_sounds.push( new boxSound( boxSoundType.SWindowLoss, 	queue.getContent( boxSoundType.SWindowLoss  ), 1 ) );
			_sounds.push( new boxSound( boxSoundType.SWindowOpen, 	queue.getContent( boxSoundType.SWindowOpen ) ) );
		}

        public function addLoadComplete( func:Function ):void
		{
            _callComplete = func;
        }
		
		public function play( compositionType:String ):Boolean
		{
			var play:Boolean = playMusic( compositionType );
			if( !play ){
				play = playSound( compositionType );
			}
			return play;
		}
		
		public function playSound( soundType:String ):Boolean
		{
            if( !_loadComplete ){
                return false;
            }

			var isSound:Boolean = false;
			for( var i:int = 0; i < _sounds.length; i++){
				if( _sounds[i].type == soundType ){
					isSound = true;
					playCOmposition( _sounds[i] );
				}
			}
			return isSound;
		}
		
		public function playMusic( musicType:String ):Boolean
		{
			var isMusic:Boolean = false;

            if( !_loadComplete ){
                _pool = musicType;
                return false;
            }

            if( _curMusicBackGround == musicType ){
                return false;
            }

            if( _curMusicBackGround != musicType && _curMusicBackGround){
                for( var i:int = 0; i < _musics.length; i++){
                    if( _musics[i].type == _curMusicBackGround ){
                        _musics[i].stop();
                    }
                }
            }

            _curMusicBackGround = musicType;
			for( var i:int = 0; i < _musics.length; i++){
				if( _musics[i].type == musicType ){
					isMusic = true;
					playCOmposition( _musics[i] );
				}
			}
			return isMusic;
		}

        private function continuePlay():void{
            for( var i:int = 0; i < _musics.length; i++){
                if( _musics[i].type == _curMusicBackGround ){
                    playCOmposition( _musics[i] );
                }
            }
        }
		
		private function playCOmposition( composition:boxSound ):void
		{
			if( _mute ){
				/*var ch:SoundChannel = composition.play();
				ch.soundTransform.volume = 0.2;*/
				//composition.volume = 0.2;
				composition.play();
			}
		}
		
		public function get mute():Boolean{ return _mute; }
		public function set mute(value:Boolean):void{
			
			if( _mute != value )
			{
				_mute = value;
				if( !value ){
					stopAll();
				}else{
					//play( boxSoundType.MBackground );
                    //play( _curMusicBackGround );
                    continuePlay();
				}
				
			}
		}
		
		public function allOn():void
		{
			//setGlobalVolume( 1 );
			mute = true;
		}
		public function allOff():void
		{
			//setGlobalVolume( 0 );
			mute = false;
		}
		private function stopAll():void
		{
			for(var i:int = 0; i < _musics.length; i++)
			{
				_musics[i].stop();
			}
			
/*			for(i = 0; i < _sounds.length; i++){
				_sounds[i].stop();
			}*/
		}
		private function setGlobalVolume( value:int ):void
		{
			var soundTransform:SoundTransform;
			if( SoundMixer.soundTransform == null ){
				soundTransform = new SoundTransform();
			}else{
				soundTransform = SoundMixer.soundTransform;
			}
			soundTransform.volume = value;
		}
		
		public function musicOn():void
		{
			
		}
		public function musicOff():void
		{
			
		}
		
		public function soundOn():void
		{
			
		}
		public function soundOff():void
		{
			
		}
	}
}