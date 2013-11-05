package engine.ui.core
{
	import engine.core.IDestroy;
	import engine.core.IExecute;
	import engine.core.ITag;

	public interface IUIView extends IExecute, IDestroy, ITag
	{
		function set properties(p_properties:Object):void;
		function viewLoaded():void;
		function initWithGUI(p_jsonObj:Object, p_specialClassDict:Object = null):void;
		
		function get frameIndex():int;
		function get frameDuration():int;
		function gotoFrame(p_frameIndex:int = 0):void;
	}
}