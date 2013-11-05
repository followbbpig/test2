package engine.asset 
{
	/**
	 * ...
	 * @author mm
	 */
	public class AssetLoader 
	{
		public function AssetLoader() 
		{
		}
		
		public function destroy():void
		{
			release();
			m_callback = null;
		}
		
		public function add(p_url:String, p_type:int, p_level:int = 0, p_lifecycle:Number = 10/*-1 means infinite*/):void
		{
			var l_asset:Asset = AssetPool._pool[Asset._assetId(p_url, p_type)];
			if (null == l_asset)
			{
				l_asset = new Asset(p_url, p_type, p_level);
				AssetPool._pool[l_asset._id] = l_asset;
			}
			
			l_asset._lifecycle = int(p_lifecycle * 1000); // to ms
			l_asset._retain();
			m_assets.push(l_asset);
		}
		
		public function load(p_callback:Function):void
		{
			m_callback = p_callback;
			
			var l_length:int = m_total = m_count = m_assets.length;
			for (var i:int = 0; i < l_length; ++i)
			{
				m_assets[i]._request(loadAssetComplete);
			}
		}
		
		public function loadData(p_data:IAssetData, p_url:String, p_type:int, p_level:int = 0, p_lifecycle:Number = 10/*-1 means infinite*/):void
		{
			var l_asset:Asset = AssetPool._pool[Asset._assetId(p_url, p_type)];
			if (null == l_asset)
			{
				l_asset = new Asset(p_url, p_type, p_level);
				l_asset._lifecycle = p_lifecycle;
				l_asset._done(p_data);
				AssetPool._pool[l_asset._id] = l_asset;
			}
		}
		
		public function get progress():Number
		{
			if (0 == m_total)
			{
				return 1.0;
			}
			else
			{
				return (1.0 - m_count * 1.0 / m_total)
			}
		}
		
		private function loadAssetComplete(p_asset:Asset):void
		{
			--m_count;
			if (0 == m_count)
			{
				if (null != m_callback)
				{
					m_callback();
					m_callback = null;
				}
				
				release();
			}
		}
		
		private function release():void
		{
			if (m_assets)
			{
				var l_length:int = m_assets.length;
				for (var i:int = 0; i < l_length; ++i)
				{
					m_assets[i]._release();
				}
				m_assets = null;
			}
		}
		
		private var m_assets:Vector.<Asset> = new Vector.<Asset>;
		private var m_count:int = 0;
		private var m_total:int = 1;
		private var m_callback:Function = null;
	}
}