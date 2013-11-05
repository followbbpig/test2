package engine.ui.control
{
	import engine.asset.AssetVisitor;
	import engine.contants.AssetType;
	import engine.ui.base.TexturePackVo;
	import engine.ui.base.TextureUIVo;
	import engine.ui.core.IUIView;
	import engine.util.UtilClass;
	
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class UIView extends Sprite implements IUIView
	{		
		public function UIView()
		{
			super();
		}
		
		public function viewLoaded():void
		{			
//			var l_quad:Quad = new Quad(width, height, 0xFF0000);
//			l_quad.alpha = 0.5;
//			addChild(l_quad);
		}
		
		public function execute(p_alpha:Number):void
		{
		}
		
		public function destroy():void
		{
		}
		
		public function initWithGUI(p_jsonObj:Object, p_specialClassDict:Object=null):void
		{
			if (null != p_jsonObj)
			{
				properties = p_jsonObj["properties"] as Object;
			}
			viewLoaded();
		}
		
		public function set properties(p_properties:Object):void
		{
			if (p_properties)
			{
				m_properties = p_properties;
				// tag
				m_tag = p_properties["tag"];
				
				// position
				x = parseFloat(p_properties["x"]);
				y = parseFloat(p_properties["y"]);
				
				// frame
				if (true == p_properties.hasOwnProperty("frameIndex")) m_frameIndex = p_properties["frameIndex"];
				if (true == p_properties.hasOwnProperty("frameDuration")) m_frameDuration = p_properties["frameDuration"];
			}
		}
		
		public function get tag():String {return m_tag;}
		
		// frame
		public function get frameIndex():int { return m_frameIndex; }
		public function get frameDuration():int { return m_frameDuration; }
		public function gotoFrame(p_frameIndex:int = 0):void
		{
			if (p_frameIndex >= m_frameIndex &&
				p_frameIndex < m_frameIndex + m_frameDuration)
			{
				visible = true;
			}
			else
			{
				visible = false;
			}
		}
		
		protected function fetchTextureByImageName(p_imageName:String):Texture
		{
			var l_visitor:AssetVisitor = new AssetVisitor();
			var l_texture:Texture;
			if (AssetVisitor.has(p_imageName, AssetType.UI_TEXTURE_VO))
			{
				var l_vo:TextureUIVo = l_visitor.retain(p_imageName, AssetType.UI_TEXTURE_VO);
				var l_packTexture:TexturePackVo = l_visitor.retain(String(l_vo.packId), AssetType.UI_TEXTURE_PACK);
				if (null == l_packTexture.texture)
				{
					l_packTexture.texture = Texture.fromBitmapData(l_packTexture.bitmap, false);
				}
				l_texture = Texture.fromTexture(l_packTexture.texture, l_vo.region);
			}
			else if (AssetVisitor.has(p_imageName, AssetType.TEXTURE))
			{
				l_texture = l_visitor.retain(p_imageName, AssetType.TEXTURE);
			}
			else
			{ 
				throw new Error("can not find texture by image name:", p_imageName);
			}
			
			l_visitor.destroy();
			l_visitor = null;
			
			return l_texture;
		}
		
		public function toString():String
		{
			return "[" + UtilClass.getClassName(this) + " " + tag + "]";
		}
		
		// make sure the font is clear, we must set the position is int not number (with pixel)
		override public function set x(value:Number):void
		{
			super.x = Math.round(value);
		}
		
		override public function set y(value:Number):void
		{
			super.y = Math.round(value);
		}
		
		protected var m_tag:String = "";
		protected var m_properties:Object;
		
		protected var m_frameIndex:int;
		protected var m_frameDuration:int = 1;
		protected var m_currentFrame:int = 0;
	}
}