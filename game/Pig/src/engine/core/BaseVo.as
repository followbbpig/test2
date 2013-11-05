package engine.core
{
	import avmplus.getQualifiedClassName;
	
	import engine.util.UtilClass;
	

	public class BaseVo
	{
		public function toString():String
		{
			return UtilClass.vardump(this);
		}
	}
}