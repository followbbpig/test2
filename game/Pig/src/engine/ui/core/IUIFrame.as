package engine.ui.core
{
	public interface IUIFrame
	{
		function frameIndex():int;
		function frameDuration():int;
		function gotoFrame(p_frame:int):void;
	}
}