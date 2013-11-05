package engine.framework.core
{
	import flash.net.SharedObject;

	public class ClientCache implements IClientCache
	{
		public function ClientCache()
		{
			m_so = SharedObject.getLocal("savedData");
		}
		
		public function hasValue(p_key:String):Boolean
		{
			return m_so.data.hasOwnProperty(p_key);
		}
		
		public function getValue(p_key:String):Object
		{
			return m_so.data[p_key];
		}
		
		public function setValue(p_key:String, p_value:Object):void
		{
			m_so.data[p_key] = p_value;
			m_so.flush();
		}
		
		private var m_so:SharedObject;
		
		public static function get instance():ClientCache
		{
			return s_instance ||= new ClientCache;
		}
		private static var s_instance:ClientCache;
	}
}