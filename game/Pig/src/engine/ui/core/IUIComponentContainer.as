package engine.ui.core
{
	import engine.ui.base.BaseUIComponent;
	
	public interface IUIComponentContainer
	{
		function addComponent(p_component:BaseUIComponent):void;
		function removeComponent(p_component:BaseUIComponent):void;	}
}