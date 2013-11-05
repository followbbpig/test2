package engine.ui.control
{
	import engine.contants.Orientation;
	import engine.ui.core.IUIInteractive;
	import engine.ui.core.IUIScrollTarget;
	import engine.ui.event.ListEvent;
	
	import flash.geom.Point;
	
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class UIScrollBar extends UIViewContainer implements IUIInteractive
	{
		public function get enabled():Boolean { return visible; }
		public function set enabled(p_value:Boolean):void
		{
			visible = p_value;
		}
		
		public function UIScrollBar()
		{
			super();
		}
		
		override public function viewLoaded():void
		{
			m_btnSlider = UIButton(viewWithTag(m_properties["btnSlider"]));
			
			m_range = m_properties["scrollRange"];
			m_startPosition = (Orientation.VERTICAL  == m_properties['orientation']) ? m_btnSlider.y : m_btnSlider.x;
			
			m_btnSlider.addEventListener(TouchEvent.TOUCH, onSliderTouch);
		}
		
		override public function destroy():void
		{
			m_btnSlider.removeEventListener(TouchEvent.TOUCH, onSliderTouch);
			m_scrollTarget.removeEventListener(ListEvent.SCROLL_CHANGED, onScrollChanged);
			m_scrollTarget = null;
			
			super.destroy();
		}
		
		public function bindScrollTaget(p_scrollTarget:IUIScrollTarget):void
		{
			m_scrollTarget = p_scrollTarget;
			m_scrollTarget.slideByPercent(0);
			m_scrollTarget.addEventListener(ListEvent.SCROLL_CHANGED, onScrollChanged);
		}
		
		protected function onScrollChanged(e:ListEvent):void
		{
			if (Orientation.VERTICAL  == m_properties['orientation'])
			{
				m_btnSlider.y = m_startPosition + m_range * e.scrollPercent;
			}
			else
			{
				m_btnSlider.x = m_startPosition + m_range * e.scrollPercent;
			}
		}
		
		protected function onSliderTouch(p_event:TouchEvent):void
		{
			var l_touch:Touch = p_event.getTouch(this);
			if (l_touch)
			{
				if (TouchPhase.BEGAN == l_touch.phase && false == m_isDragSlider)
				{
					m_isDragSlider = true;
					if (Orientation.VERTICAL  == m_properties['orientation'])
					{
						m_lastMousePos.y = l_touch.globalY;
					}
					else
					{
						m_lastMousePos.x = l_touch.globalX;
					}
				}
				else if (TouchPhase.MOVED == l_touch.phase && true == m_isDragSlider)
				{
					if (Orientation.VERTICAL  == m_properties['orientation'])
					{
						m_btnSlider.y += (l_touch.globalY - m_lastMousePos.y);
						m_btnSlider.y = Math.max(m_btnSlider.y, m_startPosition);
						m_btnSlider.y = Math.min(m_btnSlider.y, m_startPosition + m_range);
						m_lastMousePos.y = l_touch.globalY;
						if (m_scrollTarget)
						{
							m_scrollTarget.slideByPercent((m_btnSlider.y - m_startPosition) / m_range);
						}
					}
					else
					{
						m_btnSlider.x += (l_touch.globalX - m_lastMousePos.x);
						m_btnSlider.x = Math.max(m_btnSlider.x, m_startPosition);
						m_btnSlider.x = Math.min(m_btnSlider.x, m_startPosition + m_range);
						m_lastMousePos.x = l_touch.globalX;
						
						if (m_scrollTarget)
						{
							m_scrollTarget.slideByPercent((m_btnSlider.x - m_startPosition) / m_range);
						}
					}
				}
				else if (TouchPhase.ENDED == l_touch.phase)
				{
					m_isDragSlider = false;
				}
			}
		}
		
		private var m_lastMousePos:Point = new Point();
		private var m_isDragSlider:Boolean = false;
		private var m_range:Number;
		private var m_startPosition:Number;
		
		private var m_scrollTarget:IUIScrollTarget;
		
		private var m_btnBar:UIButton;
		private var m_btnSlider:UIButton;
	}
}