package engine.ui.base
{
	import engine.core.BaseVo;
	import engine.ui.core.IUIComponent;
	
	public class BaseUIComponent extends BaseUIView implements IUIComponent
	{
		public function get vo():BaseVo { return m_vo; }
		public function set vo(p_value:BaseVo):void
		{
			m_vo = p_value;
		}
		
		public function BaseUIComponent()
		{
			super();
		}
		
		protected var m_vo:BaseVo;
	}
}