package engine.ui.core
{
	import engine.core.BaseVo;

	public interface IUIComponent
	{
		function get vo():BaseVo;
		function set vo(p_value:BaseVo):void;
	}
}