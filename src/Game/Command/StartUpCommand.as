package Game.Command
{
	import Game.Model.FieldModel;
	import Game.Model.ItemsModel;
	import Game.Types.IField;
	import Game.Types.IMouseHandler;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class StartUpCommand
	{
		private var __model:*;
		
		public function StartUpCommand(model:*)
		{
			this.__model = model;	
		}
		
		public function execute(position:Point = null):void
		{	
			if(this.__model is ItemsModel)
			{
				this.__model.startup(position);
			}
			else
			{
				this.__model.startup();
			}
		}
		
		public function setTarget(target:*, position:Point = null):void
		{
			(this.__model as ItemsModel).setMainField(target);
			this.execute(position);
		}
	}
}