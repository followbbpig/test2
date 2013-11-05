package engine.parsers
{
	import engine.asset.AssetLoader;
	import engine.asset.AssetParser;
	import engine.asset.AssetVisitor;
	import engine.contants.AssetType;
	
	import flash.display.BitmapData;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class TextureAtlasParser extends AssetParser
	{
		public function TextureAtlasParser()
		{
			super();
		}
		
		protected override function parseData():void
		{
			m_loader = new AssetLoader();
			m_loader.add(info.url + ".xml", AssetType.XML);
			m_loader.add(info.url + ".png", AssetType.BITMAP);
			m_loader.load(loadComplete);
		}
		
		private function loadComplete():void
		{
			var l_arr:Array = info.url.split("_");
			var l_packId:int = l_arr[1];
			
			var l_visitor:AssetVisitor = new AssetVisitor();
			var l_bitmapData:BitmapData = l_visitor.retain(info.url + ".png", AssetType.BITMAP);
		    var l_xml:XML = l_visitor.retain(info.url + ".xml", AssetType.XML);
			
			var l_texture:Texture = Texture.fromBitmapData(l_bitmapData, false);
			
			parseDone(new TextureAtlasAssetData(new TextureAtlas(l_texture, l_xml)));
			l_visitor.destroy();
		}
		
		private var m_loader:AssetLoader = null;
		
		public static function support(p_type:int):Boolean
		{
			if (AssetType.TEXTUREATLAS == p_type)
			{
				return true;
			}
			else
			{
				return false;
			}
		}		
	}
}
import engine.asset.IAssetData;

import starling.textures.TextureAtlas;


class TextureAtlasAssetData implements IAssetData
{
	public function TextureAtlasAssetData(p_data:TextureAtlas)
	{
		m_data = p_data;
	}
	
	public function get data():*
	{
		return m_data;
	}
	
	public function destroy():void
	{
		m_data.dispose();
		m_data = null;
	}
	
	private var m_data:TextureAtlas = null;	
}
