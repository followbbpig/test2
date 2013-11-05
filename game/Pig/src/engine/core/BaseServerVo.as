package engine.core
{
	import engine.util.UtilClass;
	
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 *
	 * @author Fred Feng
	 *
	 */
	public class BaseServerVo extends BaseConfigVo implements ISerialize
	{
		public function BaseServerVo(p_obj:Object)
		{
			super(p_obj);
		}
		
		public function serialize():Object
		{
			var l_obj:Object = new Object;
			var l_describeType:Dictionary = UtilClass.getDescribeType(this);
			for(var l_variableName:String in l_describeType){
				var l_variableType:String = l_describeType[l_variableName];
				
				if (-1 < l_variableName.indexOf("c_")) continue;
				
				if (l_variableType == "int" ||
					l_variableType == "uint" ||
					l_variableType == "Number" ||
					l_variableType == "String" ||
					l_variableType == "flash.utils::ByteArray" ||
					l_variableType == "Boolean")
				{
					l_obj[l_variableName] = this[l_variableName];
				}
				else if ( -1 != l_variableType.indexOf("__AS3__.vec::Vector"))
				{
					l_obj[l_variableName] = [];
					for each(var l_item:* in this[l_variableName])
					{
						if (l_item is BaseServerVo)
						{
							l_obj[l_variableName].push(l_item.serialize());
						}
						else
						{
							l_obj[l_variableName].push(l_item);
						}
					}
				}
				else
				{
					if (this[l_variableName])
					{
						l_obj[l_variableName] = this[l_variableName].serialize();
					}
				}
			}
			return l_obj;
		}
		
		public function clone():*
		{
			var l_cls:Class = getDefinitionByName(getQualifiedClassName(this)) as Class;
			return new l_cls(this.serialize());
		}
//		
//		public function copy(p_vo:BaseServerVo):*
//		{
//			var l_describeType:Dictionary = UtilClass.getDescribeType(p_vo);
//			
//			for(var l_variableName:String in l_describeType){
//				this[l_variableName] = p_vo[l_variableName];
//			}
//			return this;
//		}
	}
}