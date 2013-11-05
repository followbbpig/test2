package engine.asset 
{
	/**
	 * ...
	 * @author mm
	 */
	internal class Asset 
	{
		private static const INVALID:String		= "INVALID";
		private static const PROGRESS:String	= "PROGRESS";
		private static const COMPLETE:String	= "COMPLETE";
		
		public function Asset(p_url:String, p_type:int, p_level:int) 
		{
			m_id = _assetId(p_url, p_type);
			m_url = p_url;
			m_type = p_type;
			m_level = p_level;
		}
		
		internal function get _id():String
		{
			return m_id;
		}
		
		internal function get _url():String
		{
			return m_url;
		}
		
		internal function get _type():int
		{
			return m_type;
		}
		
		internal function get _level():int
		{
			return m_level;
		}
		
		internal function get data():*
		{
			return m_data.data;
		}
		
		internal function _retain():void
		{
			m_life = m_lifecycle;
			++m_ref;
		}
		
		internal function _release():void
		{
			--m_ref;
		}
		
		internal function get _ref():int
		{
			return m_ref;
		}
		
		internal function set _lifecycle(p_lifecycle:int):void
		{
			m_life = m_lifecycle = Math.max(m_lifecycle, p_lifecycle);
		}
		
		internal function get _lifecycle():int
		{
			return m_lifecycle;
		}
		
		internal function set _life(p_life:int):void
		{
			m_life = p_life
		}
		
		internal function get _life():int
		{
			return m_life;
		}
		
		internal function _destroy():void
		{
			if (m_parser)
			{
				m_parser._destroy();
				m_parser = null;
			}
			
			if (m_data)
			{
				m_data.destroy();
				m_data = null;
			}
		}
		
		internal function _request(p_callback:Function):void
		{
			if (COMPLETE == m_state)
			{
				if (null != p_callback)
				{
					p_callback(this);
				}
				
				return;
			}
			
			if (null != p_callback)
			{
				m_callbacks.push(p_callback);
			}
			
			if (PROGRESS == m_state)
			{
				return;
			}
			
			var l_parsers:Vector.<Class> = AssetParser._parsers;
			for (var i:int = 0; i < l_parsers.length; ++i)
			{
				if (Object(l_parsers[i]).support(m_type))
				{
					m_state = PROGRESS;
					m_parser = new l_parsers[i]();
					m_parser._parse(new AssetInfo(this), _done);
					break;
				}
			}
		}
		
		internal function _done(p_data:IAssetData):void
		{
			m_data = p_data;
			m_state = COMPLETE;
			
			for (var i:int = 0; i < m_callbacks.length; ++i)
			{
				m_callbacks[i](this);
			}
			m_callbacks.length = 0;
		}
		
		private var m_id:String = "undefined";
		private var m_url:String = null;
		private var m_type:int = -1;
		private var m_data:IAssetData = null;
		private var m_state:String = INVALID;
		private var m_callbacks:Vector.<Function> = new Vector.<Function>;
		private var m_parser:AssetParser = null;
		private var m_level:int = 0;
		private var m_ref:int = 0;
		private var m_life:int = 0;
		private var m_lifecycle:int = 0;
		
		internal static function _assetId(p_url:String, p_type:int):String
		{
			return p_url + "@" + p_type;
		}
	}
}