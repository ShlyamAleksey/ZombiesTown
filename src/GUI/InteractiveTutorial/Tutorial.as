package GUI.InteractiveTutorial
{
	import Events.GameEvent;
	
	import GUI.Screens.GameScreen;
	import GUI.Screens.ScreenManager;
	import GUI.Windows.ItemsShop;
	import GUI.Windows.TopPlayer;
	import GUI.Windows.WindowsManager;
	
	import Game.Constants.ItemsConstant;
	import Game.Model.FieldModel;
	import Game.Model.ItemsModel;
	import Game.UI.DropItemUI;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class Tutorial extends Sprite
	{
		static public var STATUS:Boolean;
		static public var STEP:int;
		
		static private var __init:Tutorial
		
		
		private var __tutorialField:Array;
		private var __mainField:Array;
		
		public var setupPlace:Point;
		
		private var __ui:UserInterface = new UserInterface();
		
		public function Tutorial()
		{
			super();
			this.__mainField = FieldModel.instance.field;
		}
		
		public function start():void
		{
			setupField();
			step_1();
		}
		
		public function step_1():void
		{
			//Приветствие 
			STEP = 1;	
			__ui.createMask( new step_1_UI());
			zombietown.instance.tracker.trackEvent("Обучение - шаг 1","Обучение");
		}
		
		public function step_2():void
		{
			//Добавляем первую траву
			STEP = 2;
			__ui.createMask( new step_2_UI());
			setupPlace = new Point(3, 2);
			zombietown.instance.tracker.trackEvent("Обучение - шаг 2","Обучение");
		}
		
		public function step_3():void
		{
			//Соеденяем в куст
			STEP = 3;
			__ui.createMask( new step_3_UI());
			setupPlace = new Point(4, 2);	
			zombietown.instance.tracker.trackEvent("Обучение - шаг 3","Обучение");
		}
		
		public function step_4():void
		{
			//Расказуем про предметы. Часть 1
			STEP = 4;
			__ui.createMask( new step_4_UI());	
			zombietown.instance.tracker.trackEvent("Обучение - шаг 4","Обучение");
		}
		
		public function step_5():void
		{
			//Расказуем про предметы. Часть 2
			STEP = 5;
			__ui.createMask( new step_5_UI());		
			zombietown.instance.tracker.trackEvent("Обучение - шаг 5","Обучение");
		}
		
		public function step_6():void
		{
			//Помещаем траву для супер комбинации
			STEP = 6;
			__ui.createMask( new step_6_UI());
			setupPlace = new Point(5, 3);
			zombietown.instance.tracker.trackEvent("Обучение - шаг 6","Обучение");
		}
		
		public function step_7():void
		{
			//Cупер-предмет
			STEP = 7;
			
			__ui.createMask( new step_7_UI());
			setupPlace = new Point(0, 5);	
			zombietown.instance.tracker.trackEvent("Обучение - шаг 7","Обучение");
		}
		
		public function step_8():void
		{
			//Ставим зомби
			STEP = 8;
			
			__ui.createMask( new step_8_UI());
			setupPlace = new Point(1, 1);
			zombietown.instance.tracker.trackEvent("Обучение - шаг 8","Обучение");
		}
		
		public function step_9():void
		{
			//Запираем зомби
			STEP = 9;
			
			__ui.createMask( new step_9_UI());
			setupPlace = new Point(1, 1);	
			zombietown.instance.tracker.trackEvent("Обучение - шаг 9","Обучение");
		}
		
		public function step_10():void
		{
			//Ставим церковь
			STEP = 10;
			
			__ui.createMask( new step_10_UI());
			setupPlace = new Point(1, 5);		
			zombietown.instance.tracker.trackEvent("Обучение - шаг 10","Обучение");
		}
		
		public function step_11():void
		{
			//Ставим церковь
			STEP = 11;
			
			__ui.createMask( new step_11_UI());
			setupPlace = new Point(1, 5);	
			zombietown.instance.tracker.trackEvent("Обучение - шаг 11","Обучение");
		}
		
		public function step_12():void
		{
			//Окно для свободного перетаскивания
			STEP = 12;
			
			__ui.removeMask();
			setupPlace = new Point(100, 100);	
			zombietown.instance.tracker.trackEvent("Обучение - шаг 12","Обучение");
		}
		
		public function step_13():void
		{
			//Ставим кристал
			STEP = 13;	
			
			if(FieldModel.instance.field[5][4].type == ItemsConstant.TYPE_ROAD)
			{
				__ui.createMask( new step_13_b_UI());
				setupPlace = new Point(5, 4);	
			}
			else
			{
				__ui.createMask( new step_13_a_UI());
				setupPlace = new Point(4, 4);
			}	
			zombietown.instance.tracker.trackEvent("Обучение - шаг 13","Обучение");
		}
		
		public function step_14():void
		{
			//Склад
			STEP = 14;
			
			__ui.createMask( new step_14_UI());
			setupPlace = new Point(0, 0);
			zombietown.instance.tracker.trackEvent("Обучение - шаг 14","Обучение");
		}
		
//		public function step_15():void
//		{
//			//Магазин
//			STEP = 15;
//			
//			__ui.createMask( new step_15_UI());	
//			zombietown.instance.tracker.trackEvent("Обучение - шаг 15","Обучение");
//		}
		
//		public function step_16():void
//		{
//			//Магазин открыт
//			STEP = 16;
//
//			__ui.createMask( new step_16_UI());
//			//WindowsManager.instance.show( ItemsShop, onShopOpen );	
//			zombietown.instance.tracker.trackEvent("Обучение - шаг 16","Обучение");
//		}
		
//		public function step_17():void
//		{
//			//Магазин открыт
//			STEP = 17;
//			
//			
//			ItemsModel.BUY__ITEM = true;
//			ItemsShop.BOUGHT_ITEM = ItemsConstant.TYPE_BUSH;
//			DropItemUI.TYPE = ItemsShop.BOUGHT_ITEM;
//			FieldModel.instance.dispatchGameEvent(GameEvent.CHANGE_FIELD);
//			
//			__ui.removeMask();
//			WindowsManager.instance.hide();
//			zombietown.instance.tracker.trackEvent("Обучение - шаг 17","Обучение");
//		}
		
		public function step_18():void
		{
			//Бот
			STEP = 18;
			
			__ui.createMask( new step_18_UI());
			setupPlace = new Point(0, 2);	
			zombietown.instance.tracker.trackEvent("Обучение - шаг 18","Обучение");
		}
		
		public function step_19():void
		{
			//Склад
			STEP = 19;
			
			__ui.createMask( new step_19_UI());
			setupPlace = new Point(0, 2);
			zombietown.instance.tracker.trackEvent("Обучение - шаг 19","Обучение");
		}
		
		private function onShopOpen():void
		{
			
		}
		
		private function setupField():void
		{
			this.__tutorialField = [ 	[16, 1,  0, 2, 0, 4 ],
										[ 0, 0,  2, 0, 0, 6 ],
										[13, 2,  1, 0, 0, 2 ],
										[ 1, 4,  0, 0, 4, 0 ],
										[ 1, 17, 17, 0, 0, 1 ],
										[ 0, 1,  2, 0, 0, 1 ]	 ];
			
			for (var i:int = 0; i < 6; i++) 
			{
				for (var j:int = 0; j < 6; j++) 
				{
					this.__mainField[i][j].type = this.__tutorialField[j][i];
				}
			}
		}
		
		static public function get main():Tutorial
		{
			if(!__init) __init = new Tutorial();
			return __init;
		}
		
	}
}