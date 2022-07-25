package Game.Types
{
	import flash.events.IEventDispatcher;
	import flash.geom.Point;

	public interface IGameItems extends IEventDispatcher
	{
		function get type():int;
		function set type(val:int):void;
		
		function get name():String;
		function set name(val:String):void;
		
		function get position():Point;
		function set position(val:Point):void;
	}
}