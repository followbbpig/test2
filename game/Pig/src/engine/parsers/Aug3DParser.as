package engine.parsers 
{
	import aug3d.GAsset;
	import engine.asset.AssetParser;
	import engine.contants.AssetType;
	
	/**
	 * ...
	 * @author mm
	 */
	public class Aug3DParser extends AssetParser
	{
		public function Aug3DParser() 
		{
			super();
		}
		
		protected override function parseData():void
		{
			var l_url:String = info.url;
			var l_name:String = l_url.substr(l_url.lastIndexOf("/") + 1);
			var l_asset:GAsset = new GAsset(l_name.substring(0, l_name.indexOf(".")));
			l_asset.load(l_url, loadComplete);
		}
		
		private function loadComplete(p_asset:GAsset):void
		{
			parseDone(new Aug3DAssetData(p_asset));
		}
		
		public static function support(p_type:int):Boolean
		{
			if (AssetType.AUG3D == p_type)
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

import aug3d.GAsset;
import aug3d.GObject;
import engine.asset.IAssetData;

class Aug3DAssetData implements IAssetData
{
	public function Aug3DAssetData(p_data:GAsset)
	{
		m_data = p_data;
	}
	
	public function get data():*
	{
		return m_data;
	}
	
	public function destroy():void
	{
		GObject.destroy(m_data);
		m_data = null;
	}
	
	private var m_data:GAsset = null;
}