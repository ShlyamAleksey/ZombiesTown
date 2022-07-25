package Game.Command
{
	import Game.Model.ItemsModel;

	public class StorageCommand extends SimpleCommand
	{
		public function StorageCommand(model:Object)
		{
			super(model);
		}
		
		public function execute(type:int):void
		{
			(this.__model as ItemsModel).putToStorage(type);
		}
	}
}