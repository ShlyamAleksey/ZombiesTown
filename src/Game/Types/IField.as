package Game.Types
{
	import flash.events.IEventDispatcher;

	public interface IField extends IEventDispatcher
	{
		function get width():int;
		function set width(val:int):void;
		
		function get height():int;
		function set height(val:int):void;
		
		function get field():Array;
		function set field(val:Array):void;
	}
}