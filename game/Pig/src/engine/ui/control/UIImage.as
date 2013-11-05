package engine.ui.control
{
	
	import starling.display.Image;

	public class UIImage extends UIView
	{
		public function UIImage()
		{
			super();
		}
		
		override public function viewLoaded():void
		{
			image = m_properties['image'];
			if (null != m_properties["width"] && 0 != m_properties["width"])
			{
				width = m_properties["width"];
			}
			
			if (null != m_properties["height"] && 0 != m_properties["height"])
			{
				height = m_properties["height"];				
			}			
		}
		
		override public function destroy():void
		{
			removeChild(m_image);
			m_image.texture.dispose();
			m_image.dispose();
			m_image = null;
			
			super.destroy();
		}
		
		public function set image(p_image:String):void
		{
			//trace(p_image);
			if (m_imageName != p_image)
			{
				// set name
				m_imageName = p_image;
				m_tag = m_imageName.substring(m_imageName.lastIndexOf("/")+1);
				
				// clear
				if (null != m_image)
				{
					removeChild(m_image);
					m_image.dispose();
					m_image = null;
				}
				
				// load image
				addChild(m_image = new Image(fetchTextureByImageName(m_imageName)));
			}
		}
		
		private var m_image:Image;
		private var m_imageName:String = null;
	}
}