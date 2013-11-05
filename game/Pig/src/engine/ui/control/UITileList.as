package engine.ui.control
{
	import engine.contants.Orientation;
	import engine.ui.base.BaseUIComponent;
	import engine.ui.core.IUIComponentContainer;
	import engine.ui.core.IUIScrollTarget;
	import engine.ui.event.ListEvent;
	import engine.ui.extensions.ClippedSprite;
	
	import flash.geom.Rectangle;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class UITileList extends UIViewContainer implements IUIScrollTarget, IUIComponentContainer
	{
		public function UITileList()
		{
			super();
		}
		
		override public function viewLoaded():void
		{
			m_width = m_properties["maskWidth"];
			m_height = m_properties["maskHeight"];
			m_spaceX = m_properties["tileWidth"];
			m_spaceY = m_properties["tileHeight"];
			m_numCols = m_properties["columnCount"];
			
			m_touchBg = new Quad(m_width, m_height, 0xff0000);
			m_touchBg.alpha = 0.0;
			m_touchBg.x = 0;
			m_touchBg.y = 0;
			addChild(m_touchBg);
			
			m_container = new Sprite;
			
			if (m_properties["maskWidth"] && m_properties["maskHeight"])
			{
				var l_maskContainer:ClippedSprite = new ClippedSprite;
				l_maskContainer.addChild(m_container);
				addChild(l_maskContainer);
				
				l_maskContainer.clipRect = new Rectangle(0, 0, m_properties["maskWidth"], m_properties["maskHeight"]);
			}
			else
			{
				addChild(m_container);
			}
			
			addEventListener(TouchEvent.TOUCH, onTouched);
		}
		
		override public function destroy():void
		{
			removeEventListener(TouchEvent.TOUCH, onTouched);
			
			if (m_properties["maskWidth"] && m_properties["maskHeight"])
			{
				removeChild(m_container.parent);
			}
			else
			{
				removeChild(m_container);
			}
			removeChild(m_touchBg);
			m_touchBg = null;
			m_components.length = 0;
			m_components = null;
			super.destroy();
		}
		
		override public function clear():void
		{
			super.clear();
			
			while (0 < m_container.numChildren)
			{
				removeComponent(m_container.getChildAt(0) as BaseUIComponent);
			}
			
			if (m_components)
			{
				m_components.length = 0;
			}
		}
		
		public function get componentList():Vector.<BaseUIComponent>
		{
			var l_list:Vector.<BaseUIComponent> = new Vector.<BaseUIComponent>;
			for (var i:int = 0; i < m_container.numChildren; i++) 
			{
				l_list.push(m_container.getChildAt(i) as BaseUIComponent);
			}
			return l_list;
		}
		
		public function get scrollPercent():Number
		{
			var l_percent:Number
			if (Orientation.VERTICAL  == m_properties['orientation'])
			{
				l_percent = -m_container.y / scrollRangePosition;
			}
			else
			{
				l_percent = -m_container.x / scrollRangePosition;
			}
			
			return isNaN(l_percent) ? 0 : l_percent;
		}
		
		public function slideByPercent(p_value:Number):void
		{
			scrollPosition = scrollRangePosition * p_value;
		}
		
		public function slideBySize(p_value:Number):void
		{
			scrollPosition = Math.max(0, Math.min(scrollRangePosition,  - m_container.y + p_value));
		}
		
		public function addComponent(p_component:BaseUIComponent):void
		{
			m_components.push(p_component);
			layoutComponents();
			if (m_enabled)
			{
				if (true == isVertical)
				{
					if (m_height < m_touchBg.height)
					{
						m_touchBg.height = m_height;
					}
				}
				else
				{
					if (m_width < m_touchBg.width)
					{
						m_touchBg.width = m_width;
					}
				}
			}
			else
			{
				if (true == isVertical)
				{
					if (m_spaceY * Math.ceil(m_components.length/m_numCols) < m_height)
					{
						m_touchBg.height = m_spaceY * Math.ceil(m_container.numChildren/m_numCols);
					}
					else
					{
						m_touchBg.height = m_height;
					}
				}
				else
				{
					if (m_spaceX * Math.ceil(m_components.length/m_numCols) < m_width)
					{
						m_touchBg.width = m_spaceX * Math.ceil(m_container.numChildren/m_numCols);
					}
					else
					{
						m_touchBg.width = m_width;
					}
				}
			}
			scrollPosition = 0;
		}
		
		public function removeComponent(p_component:BaseUIComponent):void
		{
			if (m_container.contains(p_component))
			{
				m_container.removeChild(p_component);
			}
			
			if (m_components)
			{
				var l_index:int = m_components.indexOf(p_component);
				if (-1 != l_index)
				{
					m_components.splice(l_index, 1);
				}
			}
			
			p_component.destroy();
		}
		
		protected function onTouched(p_event:TouchEvent):void
		{
			var l_touch:Touch = p_event.getTouch(this);
			if (l_touch)
			{
				if (TouchPhase.BEGAN == l_touch.phase)
				{
					if (true == isVertical)
					{
						m_dragStartPosition = l_touch.globalY;
						m_dragStartContainerPosition = m_container.y;
					}
					else
					{
						m_dragStartPosition = l_touch.globalX;
						m_dragStartContainerPosition = m_container.x;
					}
				}
				else if (TouchPhase.ENDED == l_touch.phase)
				{
					if (true == isVertical)
					{
						if (m_container.y > 0)
						{
							backToPosition(0);
						}
						else if (m_container.y < - scrollRangePosition)
						{
							backToPosition(- scrollRangePosition);
						}
					}
					else
					{
						if (m_container.x > 0)
						{
							backToPosition(0);
						}
						else if (m_container.x < - scrollRangePosition)
						{
							backToPosition(- scrollRangePosition);
						}
					}
				}
				else if (TouchPhase.MOVED == l_touch.phase)
				{
					if (true == isVertical)
					{
						scrollPosition = - (m_dragStartContainerPosition + l_touch.globalY - m_dragStartPosition);
					}
					else
					{
						scrollPosition = - (m_dragStartContainerPosition + l_touch.globalX - m_dragStartPosition);
					}
					dispatchEvent(new ListEvent(ListEvent.SCROLL_CHANGED, Math.max(0, Math.min(1, scrollPercent))));
				}
			}
		}
		
		public function layoutComponents():void
		{
			var i:int;
			var l_view:DisplayObject = null;
			if (m_adsorption)
			{
				var l_value:Number = 0;
				for (i = 0; i < m_components.length; i++) 
				{
					l_view = m_components[i];
					if (Orientation.VERTICAL  == m_properties['orientation'])
					{
						l_view.y = l_value;
					}
					else
					{
						l_view.x = l_value;
					}
					l_value += l_view.height;
				}
				if (Orientation.VERTICAL  == m_properties['orientation'])
				{
					m_touchBg.height = l_value;
				}
				else
				{
					m_touchBg.width = l_value;
				}
			}
			else
			{
				for (i = 0; i < m_components.length; i++) 
				{
					l_view = m_components[i];
					if (Orientation.VERTICAL  == m_properties['orientation'])
					{
						l_view.x = m_spaceX * (i % m_numCols);
						l_view.y = m_spaceY * Math.floor(i / m_numCols);
					}
					else
					{
						l_view.x = m_spaceX * Math.floor(i / m_numCols);
						l_view.y = m_spaceY * (i % m_numCols);
					}
				}
			}
		}
		
		private function set scrollPosition(p_value:int):void
		{
			if (p_value < 0 || p_value > scrollRangePosition)
			{
				return;
			}
			
			var i:int = 0;
			var l_child:DisplayObject;
			if (true == isVertical)
			{
				m_container.y = -p_value;
				
				var l_startY:int = p_value;
				var l_endY:int = p_value + m_height;
				for (i = 0; i < m_components.length; i++) 
				{
					l_child = m_components[i];
					if ((l_child.y >= l_startY && l_child.y <= l_endY) ||
						(l_child.y + m_spaceY >= l_startY && l_child.y + m_spaceY <= l_endY) )
					{
						m_container.addChild(l_child);						
					}
					else
					{
						m_container.removeChild(l_child);
					}
				}
			}
			else
			{
				m_container.x = -p_value;
				
				var l_startX:int = p_value;
				var l_endX:int = p_value + m_width;
				for (i = 0; i < m_components.length; i++) 
				{
					l_child = m_components[i];
					if ((l_child.x >= l_startX && l_child.x <= l_endX) ||
						(l_child.x + m_spaceX >= l_startX && l_child.x + m_spaceX <= l_endX) )
					{
						m_container.addChild(l_child);
					}
					else
					{
						m_container.removeChild(l_child);
					}
				}
			}
		}
		
		private function get scrollRangePosition():int
		{
			if (true == isVertical)
			{
				return Math.max(0 , m_spaceY * Math.ceil(m_components.length/m_numCols) - m_height);
			}
			else
			{
				return Math.max(0 , m_spaceX * Math.ceil(m_components.length/m_numCols) - m_width);
			}
		}
		
		private function get isVertical():Boolean
		{
			return Orientation.VERTICAL  == m_properties['orientation']
		}
		
		private function backToPosition(p_targetPosition:int):void
		{
			if (true == isVertical)
			{
				Starling.juggler.tween(m_container, 0.3, {
					transition: Transitions.EASE_IN_OUT,
					onUpdate: function():void{scrollPosition = - m_container.y;},
					y : p_targetPosition
				});
			}
			else
			{
				Starling.juggler.tween(m_container, 0.3, {
					transition: Transitions.EASE_IN_OUT,
					onUpdate: function():void{scrollPosition = - m_container.x;},
					x : p_targetPosition
				});
			}
		}
		
		public function enAdsorption():void
		{
			m_adsorption = true;
		}
		
		private var m_spaceX:int;
		private var m_spaceY:int;
		private var m_numCols:int;
		private var m_width:int;
		private var m_height:int;
		
		private var m_container:Sprite;
		private var m_touchBg:Quad;
		
		private var m_enabled:Boolean = true;
		private var m_isDown:Boolean = false;
		private var m_dragStartPosition:int;
		private var m_dragStartContainerPosition:int;
		
		private var m_components:Vector.<BaseUIComponent> = new Vector.<BaseUIComponent>();
		
		private var m_adsorption:Boolean = false;
	}
}