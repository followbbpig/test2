package engine.ui.extensions
{
    import flash.display3D.Context3D;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    import starling.core.RenderSupport;
    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.display.Sprite;
    import starling.errors.MissingContextError;
    
    public class ClippedSprite extends Sprite
    {
		public static var myScaleX:Number = 1;
		public static var myScaleY:Number = 1;
		
		public function ClippedSprite()
		{
			super();
		}
		
        public override function render(p_support:RenderSupport, p_alpha:Number):void
        {
            if (m_clipRect == null)
			{
				super.render(p_support, p_alpha);
			}
            else
            {
                var context:Context3D = Starling.context;
                if (context == null)
				{
					throw new MissingContextError();
				}
                
                p_support.finishQuadBatch();
				
				// use final rect to mask to resolve the mask is not changed when the position changed
				var l_pt:Point = localToGlobal(ZERO_PT);
				m_finalRect.x = m_clipRect.x + l_pt.x;
				m_finalRect.y = m_clipRect.y + l_pt.y;
				m_finalRect.width = m_clipRect.width * myScaleX;
				m_finalRect.height = m_clipRect.height * myScaleY;
                p_support.scissorRectangle = m_finalRect;
				
                super.render(p_support, p_alpha);
                
                p_support.finishQuadBatch();
                p_support.scissorRectangle = null;
            }
        }
        
        public override function hitTest(p_localPoint:Point, p_forTouch:Boolean = false):DisplayObject
        {
            // without a clip rect, the sprite should behave just like before
            if (m_clipRect == null)
			{
				return super.hitTest(p_localPoint, p_forTouch); 
			}
            
            // on a touch test, invisible or untouchable objects cause the test to fail
            if (p_forTouch && (!visible || !touchable))
			{
				return null;
			}
            
			// use final rect to hit test 
			var l_pt:Point = localToGlobal(ZERO_PT);
			m_finalRect.x = m_clipRect.x + l_pt.x;
			m_finalRect.y = m_clipRect.y + l_pt.y;
			m_finalRect.width = m_clipRect.width;
			m_finalRect.height = m_clipRect.height;
            if (m_finalRect.containsPoint(localToGlobal(p_localPoint)))
			{
                return super.hitTest(p_localPoint, p_forTouch);
			}
            else
			{
                return null;
			}
        }
        
        public function get clipRect():Rectangle { return m_clipRect; }
        public function set clipRect(p_value:Rectangle):void
        {
            if (p_value) 
            {
                if (m_clipRect == null)
				{
					m_clipRect = p_value.clone();
				}
                else
				{
					m_clipRect.setTo(p_value.x, p_value.y, p_value.width, p_value.height);
				}
            }
            else
			{
				m_clipRect = null;
			}
        }
		
        private var m_clipRect:Rectangle;
		private var m_finalRect:Rectangle = new Rectangle;
		private static const ZERO_PT:Point = new Point;
    }
}