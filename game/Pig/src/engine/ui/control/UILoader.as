package engine.ui.control
{
	import engine.asset.AssetLoader;
	import engine.asset.AssetVisitor;
	import engine.contants.AssetType;
	import engine.framework.core.Facade;
	
	import starling.display.Image;
	import starling.textures.Texture;

	public class UILoader extends UIView
	{
		public function UILoader()
		{
			super();
		}
		
		public function loadImageByPath(p_path:String, p_keepWidthHeightRatio:Boolean = false):void
		{
			m_path = p_path;
			m_keepWidthHeightRatio = p_keepWidthHeightRatio;
			clear();
			
			var l_loader:AssetLoader = new AssetLoader();
			l_loader.add(m_path, AssetType.TEXTURE);
			l_loader.load(onBitmapLoaded);
		}
		
		public function loadImageByName(m_imageName:String):void
		{
			loadImageByTexture(fetchTextureByImageName(m_imageName));
		}
		
		public function loadImageByTexture(p_texture:Texture, p_width:int = 0, p_height:int = 0):void
		{
			if (0 < p_width) m_width = p_width;
			if (0 < p_height) m_height = p_height; 
			
			if (p_texture)
			{
				addImage(p_texture);
			}
		}
		
		private function onBitmapLoaded():void
		{
			addImage(m_visitor.retain(m_path, AssetType.TEXTURE));
		}
		
		override public function set properties(p_properties:Object):void
		{
			super.properties = p_properties;
			
			m_width = m_properties["width"];
			m_height = m_properties["height"];
		}
		
		override public function destroy():void
		{
			clear();
			
			m_visitor.destroy();
			m_visitor = null;
			
			super.destroy();		
		}
		
		public function clear():void
		{
			if (null != m_image)
			{
				removeChild(m_image);
				m_image.dispose();
				m_image = null;
			}
		}
		
		private function addImage(p_texture:Texture):void
		{
			clear();
			
			m_image = new Image(p_texture);
			addChild(m_image);
			
			if (m_width && m_height)
			{
				m_image.x = 0;
				m_image.y = 0;
				m_image.scaleX = 1;
				m_image.scaleY = 1;
				if (m_keepWidthHeightRatio)
				{
					var l_scaleW:Number = m_width / m_image.width;
					var l_scaleH:Number = m_height / m_image.height;
					var l_scale:Number = Math.min(l_scaleW, l_scaleH);
					if (l_scaleW < l_scaleH)
					{
						m_image.y = (m_height - l_scale * m_image.height) / 2;
					}
					else
					{
						m_image.x = (m_width - l_scale * m_image.width) / 2;
					}
					m_image.scaleX = l_scale;
					m_image.scaleY = l_scale;
				}
				else
				{
					m_image.scaleX = m_width / m_image.width;
					m_image.scaleY = m_height / m_image.height;
				}
			}
		}
		
		private var m_visitor:AssetVisitor = new AssetVisitor();
		
		private var m_path:String;
		private var m_keepWidthHeightRatio:Boolean;
		
		private var m_width:int;
		private var m_height:int;
		private var m_image:Image;
	}
}