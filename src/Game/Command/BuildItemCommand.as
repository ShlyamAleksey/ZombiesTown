package Game.Command
{
	import Game.Model.FieldModel;
	import Game.Types.IMouseHandler;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class BuildItemCommand extends SimpleCommand
	{
		public function BuildItemCommand(model:Object)
		{
			super(model);
		}
		
		public function execute(target:Point, type:int):void
		{
			(this.__model as FieldModel).buildNewItem(target, type);
		}
	}
}