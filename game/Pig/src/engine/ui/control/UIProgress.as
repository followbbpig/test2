package engine.ui.control
{
	import engine.contants.Direction;
	import engine.ui.extensions.ClippedSprite;
	
	import flash.geom.Rectangle;
	
	public class UIProgress extends UIViewContainer
	{
		public function get percent():Number
		{
			if (Direction.LEFT == m_properties['direction'] || Direction.RIGHT == m_properties['direction'])
			{
				return m_clipRect.width / m_properties["width"];
			}
			else
			{
				return m_clipRect.height / m_properties["height"] ;
			}
		}
		
		public function set percent(p_value:Number):void
		{
			m_clipRect.x = 0;
			m_clipRect.y = 0;
			
			switch(m_properties['direction'])
			{
				case Direction.LEFT:
					m_clipRect.width = m_properties["width"] * Math.max(0, Math.min(1, p_value));
					m_clipRect.x = m_properties["width"] * Math.max(0, Math.min(1, 1 - p_value));
					break;
				
				case Direction.BOTTOM:
					m_clipRect.height = m_properties["height"] * Math.max(0, Math.min(1, p_value));
					break;
				
				case Direction.TOP:
					m_clipRect.height = m_properties["height"] * Math.max(0, Math.min(1, p_value));
					m_clipRect.y = m_properties["height"] * Math.max(0, Math.min(1, 1 - p_value));
					break;
				
				case Direction.RIGHT:
				default:
					m_clipRect.width = m_properties["width"] * Math.max(0, Math.min(1, p_value));
					break;
			}
			
			m_container.clipRect = m_clipRect;
		}
		
		public function UIProgress()
		{
			super();
		}
		
		override public function viewLoaded():void
		{
			//return;
			m_container = new ClippedSprite;
			m_clipRect = new Rectangle(0, 0, m_properties["width"], m_properties["height"]);
			for each (var l_view:UIView in m_views) 
			{
				m_container.addChild(l_view);
				//m_container.mask = m_mask;
			}
			m_container.clipRect = m_clipRect;
			addChild(m_container);
		}
		
		override public function destroy():void
		{
			for each (var l_view:UIView in m_views) 
			{
				m_container.removeChild(l_view);
				l_view.destroy();
			}
			removeChild(m_container);
			m_container.dispose();
			m_container = null;
		}
		
		private var m_clipRect:Rectangle;
		private var m_container:ClippedSprite;
	}
}