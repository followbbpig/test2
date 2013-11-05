package engine.ui.core
{
	import engine.ui.control.UIView;

	public interface IUIViewContainer
	{
		function addView(p_view:UIView):void;
		function addViewAt(p_view:UIView, p_index:int):void;
		function removeView(p_view:UIView):void;
		function removeViewAt(p_index:int):void;
		function clear():void;
		function viewWithTag(p_tag:String):UIView;
		function get views():Vector.<UIView>;
		function get currentFrame():int;
	}
}