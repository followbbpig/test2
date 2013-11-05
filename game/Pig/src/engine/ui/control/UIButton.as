package engine.ui.control
{
	import engine.ui.core.IUIInteractive;
	
	import flash.display.Sprite;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class UIButton extends UIViewContainer implements IUIInteractive
	{
		public function UIButton()
		{
			super();
		}
		
		public function get isDown():Boolean
		{
			return m_isDown;
		}
		
		public function get enabled():Boolean
		{
			return m_enabled;
		}
		
		public function set enabled(p_value:Boolean):void
		{
			if (false == p_value)
			{
				gotoFrame(0);
				alpha = 0.5;
				m_enabled = false;
			}
			else
			{
				alpha = 1;
				m_enabled = true;
			}
		}
		
		public function get selected():Boolean
		{
			return (3 <= m_totalFrames) && m_selected;
		}
		
		public function set selected(p_value:Boolean):void
		{
			if (3 <= m_totalFrames)
			{
				m_selected = p_value;
				gotoFrame(m_selected?3:0);
				m_enabled = !m_selected;
			}
		}
		
		/**
		 * show sprite which is the display object in flash.<br>
		 * the width, height, x and y is the same as UIButton. 
		 * @param p_value
		 * 
		 */		
		public function set showFlashSprite(p_value:Boolean):void
		{
			m_showFlashSprite = p_value;
			if (p_value)
			{
				if (m_flashSprite)
				{
					m_flashSprite.destory();
					m_flashSprite = null;
				}
				m_flashSprite = new FlashSprite(this);
			}
			else
			{
				if (m_flashSprite)
				{
					m_flashSprite.destory();
					m_flashSprite = null;
				}
			}
		}
		
		/**
		 * flash.display.sprite
		 * @return flash.display.sprite 
		 * 
		 */		
		public function get flashSprite():Sprite
		{
			return m_flashSprite;
		}
		
		override public function viewLoaded():void
		{			
			addEventListener(TouchEvent.TOUCH, onTouched);
			for each(var l_view:UIView in m_views)
			{
				m_totalFrames = Math.max(m_totalFrames, l_view.frameIndex + l_view.frameDuration);
			}
		}
		
		override public function destroy():void
		{
			removeEventListener(TouchEvent.TOUCH, onTouched);
			super.destroy();
		}
		
		protected function onTouched(p_event:TouchEvent):void
		{			
			if (true == m_enabled)
			{
				var l_touch:Touch = p_event.getTouch(this);
				if (l_touch)
				{
					if (TouchPhase.BEGAN == l_touch.phase && false == m_isDown)
					{
						m_isDown = true;
						gotoFrame(FRAME_DOWN);
						if (m_enableMouseResize)
						{
							m_mouseResizeWidth = int(width / 20 * 10) / 10;
							m_mouseResizeHeight = int(height / 20 * 10) / 10;
							x -= m_mouseResizeWidth;
							y -= m_mouseResizeHeight;
							scaleX = 1.1;
							scaleY = 1.1;
						}
					}
					else if (TouchPhase.ENDED == l_touch.phase && true == m_isDown)
					{
						m_isDown = false;
						if (m_enableMouseResize)
						{
							x += m_mouseResizeWidth;
							y += m_mouseResizeHeight;
							scaleX = 1;
							scaleY = 1;
						}
						gotoFrame(FRAME_NORMAL);
						if (3 >= m_moveCount)
						{
							dispatchEventWith(Event.TRIGGERED, true);
						}
						m_moveCount = 0;
					}
					else if (TouchPhase.MOVED == l_touch.phase)
					{
						m_moveCount++;
					}
					else if (TouchPhase.HOVER == l_touch.phase && false == m_isDown)
					{
						gotoFrame(FRAME_OVER);
					}
				}
				else if (true == m_enabled)
				{
					gotoFrame(FRAME_NORMAL);
				}
			}
		}
		
		override public function gotoFrame(p_frameIndex:int = 0):void
		{
			super.gotoFrame(Math.max(0, Math.min(m_totalFrames - 1, p_frameIndex)));
		}
		
		private var m_totalFrames:int = 0;
		private var m_selected:Boolean;
		private var m_enabled:Boolean = true;
		private var m_isDown:Boolean = false;
		private var m_isUseHand:Boolean = false;
		private var m_moveCount:int = 0;
		private var m_showFlashSprite:Boolean = false;
		private var m_flashSprite:FlashSprite = null;
		
		protected var m_enableMouseResize:Boolean = true;
		protected var m_mouseResizeWidth:Number;
		protected var m_mouseResizeHeight:Number;
		
		private static const MAX_DRAG_DIST:Number = 50;
		
		private static const FRAME_NORMAL:int 	= 0;
		private static const FRAME_OVER:int 	= 1;
		private static const FRAME_DOWN:int 	= 2;
		private static const FRAME_DISABLE:int	= 3;
		private static const FRAME_SELECTED:int	= 3;
	}
}

import engine.ui.control.UIButton;

import flash.display.Sprite;
import flash.geom.Point;

import starling.core.Starling;

class FlashSprite extends Sprite
{
	public function FlashSprite(p_view:UIButton)
	{
		m_view = p_view;
		var l_pt:Point = m_view.localToGlobal(new Point());
		x = l_pt.x;
		y = l_pt.y;
		drawMe();
		Starling.current.nativeStage.addChild(this);
	}
	
	private function drawMe():void
	{
		graphics.clear();
		graphics.beginFill(0xff0000, 0);
		graphics.drawRect(0, 0, m_view.width, m_view.height);
		graphics.endFill();
	}
	
	internal function destory():void
	{
		Starling.current.nativeStage.removeChild(this);
	}
	
	private var m_view:UIButton;
}