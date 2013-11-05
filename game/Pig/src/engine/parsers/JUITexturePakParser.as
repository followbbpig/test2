package engine.parsers 
{
	import engine.asset.AssetLoader;
	import engine.asset.AssetNullData;
	import engine.asset.AssetParser;
	import engine.asset.AssetVisitor;
	import engine.contants.AssetType;
	import engine.ui.base.TexturePackVo;
	import engine.ui.base.TextureUIVo;
	import engine.util.TexturePacker;
	
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author mm
	 */
	public class JUITexturePakParser extends AssetParser
	{
		public function JUITexturePakParser() 
		{
			super();
		}
		
		protected override function parseData():void
		{
			m_loader = new AssetLoader();
			m_loader.add(info.url + ".json", AssetType.OBJECT);
			m_loader.add(info.url + ".png", AssetType.BITMAP, info.level, info.lifecycle);
			m_loader.load(loadComplete);
		}
		
		private function loadComplete():void
		{
			var l_arr:Array = info.url.split("_");
			var l_packId:int = l_arr[l_arr.length - 1];
			
			var l_visitor:AssetVisitor = new AssetVisitor();
			var l_bitmapData:BitmapData = l_visitor.retain(info.url + ".png", AssetType.BITMAP);
			var l_pack:TexturePackVo = new TexturePackVo();
			l_pack.bitmap = l_bitmapData;
			
			var l_loader:AssetLoader = new AssetLoader();
			l_loader.loadData(new TexturePackAssetData(l_pack), "" + l_packId, AssetType.UI_TEXTURE_PACK, info.level, info.lifecycle);
			
			var l_json:Object = l_visitor.retain(info.url + ".json", AssetType.OBJECT);
			var l_dict:Dictionary = TexturePacker.parseJson2(l_json);
			for (var l_name:String in l_dict) 
			{
				if (false == AssetVisitor.has("bitmap/" + l_name, AssetType.UI_TEXTURE_VO))
				{
					var l_vo:TextureUIVo = new TextureUIVo();
					l_vo.packId = l_packId;
					l_vo.region = l_dict[l_name];
					
					l_loader.loadData(new TextureUIAssetData(l_vo), "bitmap/" + l_name, AssetType.UI_TEXTURE_VO, info.level, info.lifecycle);
				}
			}
			
			l_visitor.destroy();
			
			parseDone(new AssetNullData());
		}
		
		private var m_loader:AssetLoader = null;
		
		public static function support(p_type:int):Boolean
		{
			if (AssetType.TEXTURE_UI == p_type)
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
import engine.ui.base.TexturePackVo;
import engine.ui.base.TextureUIVo;

class TexturePackAssetData implements IAssetData
{
	public function TexturePackAssetData(p_data:TexturePackVo)
	{
		m_data = p_data;
	}
	
	public function get data():*
	{
		return m_data;
	}
	
	public function destroy():void
	{
		if (m_data.bitmap)
		{
			m_data.bitmap.dispose();
			m_data.bitmap = null;
		}
		if (m_data.texture)
		{
			m_data.texture.dispose();
			m_data.texture = null;
		}
		m_data = null;
	}
	
	private var m_data:TexturePackVo = null;
}

class TextureUIAssetData implements IAssetData
{
	public function TextureUIAssetData(p_data:TextureUIVo)
	{
		m_data = p_data;
	}
	
	public function get data():*
	{
		return m_data;
	}
	
	public function destroy():void
	{
		m_data = null;
	}
	
	private var m_data:TextureUIVo = null;	
}
