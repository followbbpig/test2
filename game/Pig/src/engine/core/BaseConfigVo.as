package engine.core
{
	import engine.util.UtilClass;
	
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	public class BaseConfigVo extends BaseVo implements IUnserialize
	{
		public function BaseConfigVo(p_obj:Object)
		{
			unserialize(p_obj);
		}
		
		public function unserialize(p_obj:Object):void
		{
			if (null == p_obj)
			{
				return;
			}
			
			var l_variableType:String;
			var l_class:Class;
			var l_describeType:Dictionary = UtilClass.getDescribeType(this);
			
			for(var l_key:String in p_obj)
			{
				if (true == l_describeType.hasOwnProperty(l_key))
				{
					l_variableType = l_describeType[l_key];
					
					var l_value:* = p_obj[l_key];
					if (l_value is Number ||
						l_value is String ||
						l_value is Boolean)
					{
						this[l_key] = l_value;
					}
					else if(l_value is Array)
					{
						l_variableType = l_variableType.slice(l_variableType.indexOf("<")+1, l_variableType.indexOf(">"));
						l_class = getDefinitionByName(l_variableType) as Class;
						
						for each(var l_item:* in l_value)
						{
							if (l_item) 
							{
								this[l_key].push(new l_class(l_item));
							}
							else
							{
								this[l_key].push(null);
							}
						}
					}
					else if(l_value is Object)
					{
						if (l_value)
						{
							l_class = getDefinitionByName(l_variableType) as Class;
							this[l_key] = new l_class(l_value);
						}
					}
				}
			}
		}
	}
}