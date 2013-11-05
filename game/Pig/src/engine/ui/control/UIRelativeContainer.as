package engine.ui.control
{
	import starling.events.Event;
	
	/**
	 * priority: topLeft > topRight > bottomLeft > bottomRight > topMiddle > bottomMiddle > leftMiddle > rightMiddle > middle > (left > right, top > bottom)
	 *@author Alan.Zhang
	 *
	 */
	public class UIRelativeContainer extends UIViewContainer
	{		
		public function UIRelativeContainer()
		{
			super();
		}
		
		override public function viewLoaded():void
		{
			addEventListener(Event.ADDED_TO_STAGE, addToStage);
		}
		
		public function resetLayout(p_scaleX:Number, p_scaleY:Number):void
		{
			m_scaleX = p_scaleX < 1 ? 1 : p_scaleX;
			m_scaleY = p_scaleY < 1 ? 1 : p_scaleY;
			setPosition();
		}
		
		private function addToStage(p_event:Event):void
		{
			setPosition();
		}
		
		private function setPosition():void
		{
			if (null == stage)
			{
				return;
			}
			
			var l_width:Number = width;
			var l_height:Number = height;
			
			if (null != m_properties["topLeft"])
			{
				x = y = m_properties["topLeft"];
			}
			else if (null != m_properties["topRight"])
			{
				y = m_properties["topRight"];
				x = stage.stageWidth * m_scaleX - m_properties["topRight"] - l_width;
			}
			else if (null != m_properties["bottomLeft"])
			{
				x = m_properties["bottomLeft"];
				y = stage.stageHeight * m_scaleY - m_properties["bottomLeft"] - l_height; 
			}
			else if (null != m_properties["bottomRight"])
			{
				x = stage.stageWidth * m_scaleX - m_properties["topRight"] - l_width;
				y = stage.stageHeight * m_scaleY - m_properties["bottomLeft"] - l_height;
			}
			else if (null != m_properties["topMiddle"])
			{
				x = (stage.stageWidth * m_scaleX - l_width) / 2;
				y = m_properties["topMiddle"];
			}
			else if (null != m_properties["bottomMiddle"])
			{
				x = (stage.stageWidth * m_scaleX - l_width) / 2;
				y = stage.stageHeight * m_scaleY - l_height - m_properties["bottomMiddle"];
			}
			else if (null != m_properties["leftMiddle"])
			{
				x = m_properties["leftMiddle"];
				y = (stage.stageHeight * m_scaleY - l_height) / 2;
			}
			else if (null != m_properties["rightMiddle"])
			{
				x = (stage.stageWidth * m_scaleX - m_properties["rightMiddle"] -l_width);
				y = (stage.stageHeight * m_scaleY - l_height) / 2;
			}
			else if (null != m_properties["middle"])
			{
				x = (stage.stageWidth * m_scaleX - l_width) / 2;
				y = (stage.stageHeight * m_scaleY - l_height) / 2;
			}
			else
			{
				if (null != m_properties["top"])
				{
					y = m_properties["top"];
				}
				else if (null != m_properties["bottom"])
				{
					y = stage.stageHeight * m_scaleY - m_properties["bottom"] - l_height; 
				}
				else 
				{
					y = 0;
				}
				
				if (null != m_properties["left"])
				{
					x = m_properties["left"];
				}
				else if (null != m_properties["right"])
				{
					x = stage.stageWidth * m_scaleX - m_properties["right"] - l_width;
				}
				else
				{
					x = 0;
				}
			}
		}
		
		private var m_scaleX:Number = 1;
		private var m_scaleY:Number = 1;
	}
}