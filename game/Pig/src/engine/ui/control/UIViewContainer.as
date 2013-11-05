package engine.ui.control
{
	import engine.ui.core.IUIViewContainer;
	
	import flash.utils.getDefinitionByName;

	public class UIViewContainer extends UIView implements IUIViewContainer
	{
		private const PACKAGE_NAME:String = "com.augmentum.engine.ui.control";
		
		public function UIViewContainer()
		{
			super();
			
			m_views = new Vector.<UIView>;
		}
		
		override public function viewLoaded():void
		{
			super.viewLoaded();	
		}
		
		override public function destroy():void
		{
			clear();
			m_views = null;
			
			super.destroy();
		}
		
		override public function initWithGUI(p_jsonObj:Object, p_specialClassDict:Object = null):void
		{
			var l_subViews:Array = p_jsonObj["subViews"] as Array;
			for each (var l_xui:Object in l_subViews)
			{
				var l_class:Class;
				if (p_specialClassDict && p_specialClassDict[l_xui["properties"]["type"]])
				{
					l_class = p_specialClassDict[l_xui["properties"]["type"]]; 
				}
				else
				{
					
					l_class = getDefinitionByName(PACKAGE_NAME + "." + l_xui["class"]) as Class;
				}
				
				if (l_class)
				{
					var l_view:UIView = new l_class();
					l_view.initWithGUI(l_xui, p_specialClassDict);
					addView(l_view);
				}
				else
				{
					throw new Error("can not find class to present this json ui");
				}
			}
			
			gotoFrame(0);
			
			super.initWithGUI(p_jsonObj, p_specialClassDict);
		}
		
		override public function gotoFrame(p_frameIndex:int=0):void
		{
			for each(var l_view:UIView in m_views)
			{
				if (p_frameIndex >= l_view.frameIndex &&
					p_frameIndex < l_view.frameIndex + l_view.frameDuration)
				{
					l_view.visible = true;
				}
				else
				{
					l_view.visible = false;
				}
			}
			
			m_currentFrame = p_frameIndex;
		}
		
		public function clear():void
		{
			for (var i:int = m_views.length - 1; i >= 0; --i)
			{
				m_views[i].destroy();
				removeView(m_views[i]);
			}
			m_views.length = 0;
		}
		
		public function get views():Vector.<UIView>
		{
			return m_views;
		}
		
		public function addView(p_view:UIView):void
		{
			addViewAt(p_view, numChildren);
		}
		
		public function addViewAt(p_view:UIView, p_index:int):void
		{
			addChildAt(p_view, p_index);
			
			var l_index:int = m_views.indexOf(p_view);
			if (l_index > -1)
			{
				m_views.splice(l_index, 1);
			}
			m_views.push(p_view);
		}
		
		public function removeView(p_view:UIView):void
		{
			removeChild(p_view);
			for (var i:int = 0; i < m_views.length; ++i)
			{
				if (m_views[i] == p_view)
				{
					m_views.splice(i, 1);
					break;
				}
			}
		}
		
		public function removeViewAt(p_index:int):void
		{
			var l_removeViews:Vector.<UIView> = m_views.splice(p_index, 1);
			if (1 == l_removeViews.length)
			{
				removeChild(l_removeViews[0]);
			}
		}
		
		public function viewWithTag(p_tag:String):UIView
		{
			for each (var l_view:UIView in m_views)
			{
				if (l_view.tag == p_tag)
				{
					return l_view;
				}
			}
			
			return null;
		}
		
		public function get currentFrame():int {return m_currentFrame;}		
		protected var m_views:Vector.<UIView>;
	}
}