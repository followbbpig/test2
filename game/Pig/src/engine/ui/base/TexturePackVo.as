package engine.ui.base
{
	import engine.core.BaseVo;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import starling.textures.Texture;
	
	public class TexturePackVo extends BaseVo
	{
		public var bitmap:BitmapData;
		public var texture:Texture;
		public var usedRectangles:Vector.<Rectangle>;
		public var freeRectangles:Vector.<Rectangle>;
		
		public function TexturePackVo()
		{
			super();
		}
	}
}