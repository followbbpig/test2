package engine.asset 
{
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author mm
	 */
	internal class AssetPool 
	{
		internal static function get _pool():Dictionary
		{
			return s_pool;
		}
		
		public static var s_pool:Dictionary = new Dictionary();
	}
}