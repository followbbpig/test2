package engine.ui.event
{
	import starling.events.Event;
	
	public class ListEvent extends Event
	{
		public static const SCROLL_CHANGED:String = "SCROLL_CHANGED";
		
		public var scrollPercent:Number;
		
		public function ListEvent(p_type:String, p_scrollPercent:Number)
		{
			super(p_type);
			
			scrollPercent = p_scrollPercent;
		}
	}
}