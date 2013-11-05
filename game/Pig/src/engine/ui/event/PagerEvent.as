package engine.ui.event
{
	import starling.events.Event;
	
	public class PagerEvent extends Event
	{
		public static const PAGE_CHANGED:String = "PAGE_CHANGED";
		
		public var currentPage:int;
		public var totalPage:int;
		
		public function PagerEvent(p_type:String, p_current:int, p_total:int)
		{
			super(p_type);
			
			currentPage = p_current;
			totalPage = p_total;
		}
	}
}