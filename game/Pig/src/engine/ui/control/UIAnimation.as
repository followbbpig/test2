package engine.ui.control
{
	import engine.contants.AssetType;
	import engine.framework.core.Facade;
	import engine.util.UtilString;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.textures.Texture;

	public class UIAnimation extends UIView
	{
		private static const FRAMES_PER_SECOND:Number	= 24;
		private static const FRAME_INTERVAL:Number 		= 1.0 / FRAMES_PER_SECOND;
		
		public function get isPlay():Boolean { return m_movieClip.isPlaying; }
		public function get currentFrame():int { return m_movieClip.currentFrame }
		public function get totalFrame():int { return m_movieClip.numFrames; }
		
		public function UIAnimation()
		{
			super();
		}
		
		override public function viewLoaded():void
		{
			super.viewLoaded();
			
			var l_textures:Vector.<Texture> = new Vector.<Texture>;
			for (var i:int = 1; i <= m_properties["totalFrames"]; i++) 
			{
				var l_imageName:String = "bitmap/" + String(m_properties["image"]).replace("{0}", UtilString.fillZero(i, 4));
				l_textures.push(fetchTextureByImageName(l_imageName));
			}
			
			m_movieClip = new MovieClip(l_textures, m_properties['fps']);
			
			addChild(m_movieClip);
			
			if (m_properties["width"] && 0 != m_properties["width"])
			{
				m_movieClip.width = m_properties["width"];
			}
			
			if (m_properties["height"] && 0 != m_properties["height"])
			{
				m_movieClip.height = m_properties["height"];
			}
						
			Starling.juggler.add(m_movieClip);
		}
		
		override public function destroy():void
		{
			Starling.juggler.remove(m_movieClip);
			m_movieClip.dispose();
			
			super.destroy();
		}
		
		public function gotoAndPlay(p_frame:int = 1):void
		{
			m_movieClip.currentFrame = p_frame;
			m_movieClip.play();
		}
		
		public function gotoAndStop(p_frame:int = 1):void
		{
			m_movieClip.currentFrame = p_frame;
			m_movieClip.stop();
		}
		
		private var m_movieClip:MovieClip;
	}
}