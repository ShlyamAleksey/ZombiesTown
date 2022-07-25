package GUI.InteractiveTutorial
{
	import GUI.Screens.MapScreen;
	import GUI.Screens.ScreenManager;
	
	import Game.Logic.Pause;
	import Game.UI.DropItemUI;
	
	import Services.Service;
	import Services.User.UserModel;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class UserInterface
	{
		private var __maskTarget:MovieClip;
		
		public function UserInterface()
		{
		}
		
		public function createMask(target:MovieClip, maskAlpha:int = 0.2):void
		{
			if(this.__maskTarget) zombietown.instance.removeChild( __maskTarget );
			this.__maskTarget = target;
			zombietown.instance.addChild( __maskTarget );
			
			if(Tutorial.STEP == 1)
			{
				this.__maskTarget.nextStep.addEventListener(MouseEvent.CLICK, toStep_2);
			}
			if(Tutorial.STEP == 4)
			{
				this.__maskTarget.nextStep.addEventListener(MouseEvent.CLICK, toStep_5);
			}
			if(Tutorial.STEP == 5)
			{
				this.__maskTarget.nextStep.addEventListener(MouseEvent.CLICK, toStep_6);
			}
			if(Tutorial.STEP == 11)
			{
				this.__maskTarget.nextStep.addEventListener(MouseEvent.CLICK, toStep_12);
			}
			if(Tutorial.STEP == 19)
			{
				this.__maskTarget.nextStep.addEventListener(MouseEvent.CLICK, toStep_19);
			}
		}
		
		public function removeMask():void
		{
			zombietown.instance.removeChild( __maskTarget );
			this.__maskTarget = null;
			Tutorial.STEP++;
		}
		
		private function toStep_2(e:MouseEvent):void
		{
			this.__maskTarget.nextStep.removeEventListener(MouseEvent.CLICK, toStep_2);
			Tutorial.STEP++;
			Tutorial.main.step_2();
		}
		
		private function toStep_5(e:MouseEvent):void
		{
			this.__maskTarget.nextStep.removeEventListener(MouseEvent.CLICK, toStep_5);
			Tutorial.STEP++;
			Tutorial.main.step_5();
		}
		
		private function toStep_6(e:MouseEvent):void
		{
			this.__maskTarget.nextStep.removeEventListener(MouseEvent.CLICK, toStep_6);
			Tutorial.STEP++;
			Tutorial.main.step_6();
		}
		
		private function toStep_12(e:MouseEvent):void
		{
			this.__maskTarget.nextStep.removeEventListener(MouseEvent.CLICK, toStep_12);
			Tutorial.STEP++;
			Tutorial.main.step_12();
		}
		
		private function toStep_19(e:MouseEvent):void
		{
			this.__maskTarget.nextStep.removeEventListener(MouseEvent.CLICK, toStep_19);
			Tutorial.STATUS = false;
			Service.instance.userModel.points = 0;
			
			ScreenManager.instance.show( MapScreen );
		}
	}
}