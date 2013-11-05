package engine.core
{
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author GameCloud Studios, Inc.
	 */
	public class Localization
	{
		public function Localization()
		{
		}
		
		public function loadLocaleStrings(p_locale:String):void
		{
			var l_strings:Array = p_locale.split("\n");
			for (var i:int = 0; i < l_strings.length; ++i)
			{
				var l_locale:Array = splitString(l_strings[i]);
				var l_id:String = l_locale.shift();
				m_localeStrings[l_id] = l_locale;
			}
		}
		
		public function loadLocaleJson(p_object:Object):void
		{
			for (var l_key:String in p_object)
			{
				m_localeStrings[l_key] = p_object[l_key][m_language];
			}
		}
		
		public function getString(p_id:String, ...p_args):String
		{
			if ("" == p_id || null == m_localeStrings[p_id])
				return p_id;
			
			return getFormatString.apply(null, [m_localeStrings[p_id]].concat(p_args));;
		}
		
		public function set language(p_language:String):void
		{
			switch(p_language)
			{
				case "en":
					m_language = 0;
					break;
				case "zh-CN":
					m_language = 1;
					break;
			}
		}
		
		public function get language():String
		{
			return (m_language == 0)?"en":"zh-CN";
		}
		
		protected function splitString(p_string:String):Array
		{
			var l_strings:Array = new Array();
			
			var l_string:String = "";
			var l_skip:Boolean = false;
			for (var i:int = 0; i < p_string.length; ++i)
			{
				var l_char:String = p_string.charAt(i);
				if (l_char == "\"")
				{
					l_skip = !l_skip;
				}
				else if (l_char == "," && !l_skip)
				{
					l_strings.push(l_string);
					l_string = "";
				}
				else
				{
					l_string += l_char;
				}
			}
			l_strings.push(l_string);
			
			return l_strings;
		}
		
		
		protected var m_localeStrings:Dictionary = new Dictionary();
		protected var m_language:int = 0;
		
		public static function get instance():Localization
		{
			if (null == s_instance)
				s_instance = new Localization();
			
			return s_instance;
		}
		protected static var s_instance:Localization = null;
		
		public static function getFormatString(p_str:String, ...p_args):String
		{
			if (p_args.length > 0)
			{
				for (var i:int = 0; i < p_args.length; ++i)
				{
					p_str = p_str.replace("{" + i + "}", p_args[i]);
				}
			}
			
			return p_str;
		}
		
		// util functions
		public static function getNumberSuffix(p_num:int):String
		{
			var l_ret:String;
			switch(p_num)
			{
				case 11:
				case 12:
					l_ret = "th";
					break;
				default:
					var l_lastNum:int = p_num%10;
					l_ret = (1 == l_lastNum)?"st":
							(2 == l_lastNum)?"nd":
							(3 == l_lastNum)?"rd":
							"th";
					break;
			}
			return l_ret;
		}
	}
}