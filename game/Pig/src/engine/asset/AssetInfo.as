package engine.asset 
{
	/**
	 * ...
	 * @author mm
	 */
	public class AssetInfo 
	{
		public function AssetInfo(p_asset:Asset) 
		{
			m_asset = p_asset;
		}
		
		public function get url():String
		{
			return m_asset._url;
		}
		
		public function get type():int
		{
			return m_asset._type;
		}
		
		public function get level():int
		{
			return m_asset._level;
		}
		
		public function get lifecycle():int
		{
			return m_asset._lifecycle;
		}
		
		private var m_asset:Asset = null;
	}
}