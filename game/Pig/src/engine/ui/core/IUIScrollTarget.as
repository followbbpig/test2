package engine.ui.core
{
	import flash.events.IEventDispatcher;

	public interface IUIScrollTarget
	{
		function slideBySize(p_value:Number):void;
		function slideByPercent(p_value:Number):void;
		function get scrollPercent():Number;
		function addEventListener(type:String, listener:Function):void
		function removeEventListener(type:String, listener:Function):void
	}
}