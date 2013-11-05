package engine.asset 
{
	/**
	 * ...
	 * @author mm
	 */
	public class AssetNullData implements IAssetData
	{
		public function AssetNullData() 
		{
		}
		
		public function get data():*
		{
			return null;
		}
		
		public function destroy():void
		{
		}
	}
}