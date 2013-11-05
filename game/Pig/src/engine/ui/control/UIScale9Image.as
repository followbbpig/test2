package engine.ui.control
{
	import engine.contants.AssetType;
	import engine.framework.core.Facade;
	
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	import starling.textures.Texture;

	public class UIScale9Image extends UIViewContainer
	{
		public function UIScale9Image()
		{
			super();
		}
		
		override public function set height(p_value:Number):void
		{
			layout(width, p_value);
			super.height = p_value;
		}
		
		override public function set width(p_value:Number):void
		{
			layout(p_value, height);
			super.width = p_value;
		}
		
		override public function initWithGUI(p_jsonObj:Object, p_specialClassDict:Object = null):void
		{
			var l_subViews:Array = p_jsonObj["subViews"] as Array;
			if (0 != l_subViews.length && "UIImage" != l_subViews[0]['class'])
			{
				throw new Error("scale9Image json error");
			}
			else
			{
				var l_imageName:String = l_subViews[0]['properties']['image'];
				m_texture = fetchTextureByImageName(l_imageName);
				m_imageWidth = l_subViews[0]['properties']['width'];
				m_imageHeight = l_subViews[0]['properties']['height'];
				m_scaleX = m_texture.width / l_subViews[0]['properties']['width'];
				m_scaleY = m_texture.height / l_subViews[0]['properties']['height'];
			}
			
			if (null != p_jsonObj)
			{
				properties = p_jsonObj["properties"] as Object;
			}
			viewLoaded();
		}
		
		override public function viewLoaded():void
		{			
			var l_scaleGrid:Array = m_properties['scale9Grid'].split(",");
			for (var i:int = 0; i < l_scaleGrid.length; i++) 
			{
				l_scaleGrid[i] = parseInt(l_scaleGrid[i]);
			}
			
			if (4 != l_scaleGrid.length ||
				l_scaleGrid[0] > m_imageWidth ||
				l_scaleGrid[2] > m_imageWidth ||
				l_scaleGrid[0] > l_scaleGrid[2] ||
				l_scaleGrid[1] > m_imageHeight ||
				l_scaleGrid[3] > m_imageHeight ||
				l_scaleGrid[1] > l_scaleGrid[3])
			{
				throw new Error("scale9Grid properties is invalid");
			}
			else
			{
				m_leftWidth = l_scaleGrid[0];
				m_centerWidth = l_scaleGrid[2] - l_scaleGrid[0];
				m_rightWidth = m_imageWidth - l_scaleGrid[2];
				m_topHeight = l_scaleGrid[1];
				m_middleHeight = l_scaleGrid[3] - l_scaleGrid[1];
				m_bottomHeight = m_imageHeight - l_scaleGrid[3];
				
				m_scaleRect = new Rectangle(l_scaleGrid[0] * m_scaleX, l_scaleGrid[1] * m_scaleY, (l_scaleGrid[2] - l_scaleGrid[0]) * m_scaleX, (l_scaleGrid[3] - l_scaleGrid[1]) * m_scaleY);
				
				m_topLeftImage = new Image(Texture.fromTexture(m_texture, new Rectangle(0, 0, m_scaleRect.x, m_scaleRect.y)));
				m_topCenterImage = new Image(Texture.fromTexture(m_texture, new Rectangle(m_scaleRect.x, 0, m_scaleRect.width, m_scaleRect.y)));
				m_topRightImage = new Image(Texture.fromTexture(m_texture, new Rectangle(m_scaleRect.x + m_scaleRect.width, 0, m_texture.width - m_scaleRect.x - m_scaleRect.width, m_scaleRect.y)));
				
				m_middleLeftImage = new Image(Texture.fromTexture(m_texture, new Rectangle(0, m_scaleRect.y, m_scaleRect.x, m_scaleRect.height)));
				m_middleCenterImage = new Image(Texture.fromTexture(m_texture, new Rectangle(m_scaleRect.x, m_scaleRect.y, m_scaleRect.width, m_scaleRect.height)));
				m_middleRightImage = new Image(Texture.fromTexture(m_texture, new Rectangle(m_scaleRect.x + m_scaleRect.width, m_scaleRect.y, m_texture.width - m_scaleRect.x - m_scaleRect.width, m_scaleRect.height)));
				
				m_bottomLeftImage = new Image(Texture.fromTexture(m_texture, new Rectangle(0, m_scaleRect.y + m_scaleRect.height, m_scaleRect.x, m_texture.height - m_scaleRect.y - m_scaleRect.height)));
				m_bottomCenterImage = new Image(Texture.fromTexture(m_texture, new Rectangle(m_scaleRect.x, m_scaleRect.y + m_scaleRect.height, m_scaleRect.width, m_texture.height - m_scaleRect.y - m_scaleRect.height)));
				m_bottomRightImage = new Image(Texture.fromTexture(m_texture, new Rectangle(m_scaleRect.x + m_scaleRect.width, m_scaleRect.y + m_scaleRect.height, m_texture.width - m_scaleRect.x - m_scaleRect.width, m_texture.height - m_scaleRect.y - m_scaleRect.height)));
				
				addChild(m_topLeftImage);
				addChild(m_topCenterImage);
				addChild(m_topRightImage);
				addChild(m_middleLeftImage);
				addChild(m_middleCenterImage);
				addChild(m_middleRightImage);
				addChild(m_bottomLeftImage);
				addChild(m_bottomCenterImage);
				addChild(m_bottomRightImage);
				
				layout(m_properties['width'], m_properties['height']);
			}
		}
		
		override public function destroy():void
		{
			while(0 < numChildren)
			{
				var l_image:Image = getChildAt(0) as Image;
				removeChild(l_image);
				l_image.texture.dispose();
				l_image.dispose();
			}
			m_texture.dispose();
		}
		
		private function layout(p_width:int, p_height:int):void
		{
			var l_centerScaleX:Number = (p_width - m_leftWidth - m_rightWidth) / m_centerWidth;
			var l_centerScaleY:Number = (p_height - m_topHeight - m_bottomHeight) / m_middleHeight;
			
			m_topCenterImage.scaleX = l_centerScaleX;
			m_topCenterImage.x = m_leftWidth * m_scaleX;
			
			m_topRightImage.x = (p_width - m_rightWidth) * m_scaleX;
			
			m_middleLeftImage.y = m_topHeight * m_scaleY;
			m_middleLeftImage.scaleY = l_centerScaleY;
			
			m_middleCenterImage.x = m_leftWidth * m_scaleX;
			m_middleCenterImage.y = m_topHeight * m_scaleY;
			m_middleCenterImage.scaleX = l_centerScaleX;
			m_middleCenterImage.scaleY = l_centerScaleY;
			
			m_middleRightImage.x = (p_width - m_rightWidth) * m_scaleX;
			m_middleRightImage.y = m_topHeight * m_scaleY;
			m_middleRightImage.scaleY = l_centerScaleY;
			
			m_bottomLeftImage.y = (p_height - m_bottomHeight) * m_scaleY;
			
			m_bottomCenterImage.x = m_leftWidth * m_scaleX;
			m_bottomCenterImage.y = (p_height - m_bottomHeight) * m_scaleY;
			m_bottomCenterImage.scaleX = l_centerScaleX;
			
			m_bottomRightImage.x = (p_width - m_rightWidth) * m_scaleX;
			m_bottomRightImage.y = (p_height - m_bottomHeight) * m_scaleY;
		}
		
		private var m_leftWidth:int;
		private var m_centerWidth:int; 
		private var m_rightWidth:int;
		private var m_topHeight:int; 
		private var m_middleHeight:int;
		private var m_bottomHeight:int;
		
		private var m_imageWidth:int;
		private var m_imageHeight:int;
		private var m_scaleRect:Rectangle;
		private var m_texture:Texture;
		
		private var m_topLeftImage:Image;
		private var m_topCenterImage:Image;
		private var m_topRightImage:Image;
		private var m_middleLeftImage:Image;
		private var m_middleCenterImage:Image;
		private var m_middleRightImage:Image;
		private var m_bottomLeftImage:Image;
		private var m_bottomCenterImage:Image;
		private var m_bottomRightImage:Image;
		
		private var m_scaleX:Number = 1;
		private var m_scaleY:Number = 1;
	}
}