package engine.ui.control
{
	import engine.ui.base.BaseUIComponent;
	import engine.ui.core.IUIComponentContainer;
	
	public class UIList extends UIViewContainer implements IUIComponentContainer
	{
		public function UIList()
		{
			super();
		}
		
		override public function viewLoaded():void
		{
			m_tileList = UITileList(viewWithTag(m_properties['tileList']));
			m_scrollBar = UIScrollBar(viewWithTag(m_properties['scrollBar']));
			m_scrollBar.bindScrollTaget(m_tileList);
		}
		
		override public function destroy():void
		{
			super.destroy();
		}
		
		public function addComponent(p_component:BaseUIComponent):void
		{
			m_tileList.addComponent(p_component);
		}
		
		public function removeComponent(p_component:BaseUIComponent):void
		{
			m_tileList.removeComponent(p_component);
		}
		
		private var m_scrollBar:UIScrollBar;
		private var m_tileList:UITileList;
	}
}