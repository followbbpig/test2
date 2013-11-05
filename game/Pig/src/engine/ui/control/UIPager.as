package engine.ui.control
{
	import engine.ui.event.PagerEvent;
	
	import starling.events.Event;

	public class UIPager extends UIViewContainer
	{
		public function UIPager()
		{
			super();
		}
		
		override public function viewLoaded():void
		{
			m_btnFirst = UIButton(viewWithTag(m_properties["btnFirst"]));
			m_btnLast = UIButton(viewWithTag(m_properties["btnLast"]));
			m_btnNext = UIButton(viewWithTag(m_properties["btnNext"]));
			m_btnPrevious = UIButton(viewWithTag(m_properties["btnPrevious"]));
			
			m_txtCurrent = UILabel(viewWithTag(m_properties["txtCurrent"]));
			m_txtTotal = UILabel(viewWithTag(m_properties["txtTotal"]));
			
//			trace(m_txtCurrent, m_txtTotal);
			
			addEventListener(Event.TRIGGERED, onClick);
		}
		
		override public function destroy():void
		{
			removeEventListener(Event.TRIGGERED, onClick);
			
			super.destroy();
		}
		
		// currentPage start form 0, not 1;
		public function initPage(p_totalPage:int, p_currentPage:int = 0):void
		{
			m_totalPage = p_totalPage;
			switchPage(p_currentPage);
		}
		
		protected function onClick(e:Event):void
		{
			// TODO Auto Generated method stub
			switch(e.target)
			{
				case m_btnFirst:
					switchPage(0);
					break;
				case m_btnPrevious:
					switchPage(m_currentPage - 1);
					break;
				case m_btnNext:
					switchPage(m_currentPage + 1);
					break;
				case m_btnLast:
					switchPage(m_totalPage - 1);
					break;
			}
		}
		
		private function switchPage(p_page:int):void
		{
			if (m_currentPage != p_page)
			{
				m_currentPage = Math.min(Math.max(0, m_totalPage - 1), Math.max(0, p_page));
				
				if (m_btnFirst)	m_btnFirst.enabled = (0 != m_currentPage);
				if (m_btnFirst)	m_btnPrevious.enabled = (0 != m_currentPage);
				if (m_btnLast) m_btnLast.enabled = (m_totalPage - 1 > m_currentPage);
				if (m_btnFirst)	m_btnNext.enabled = (m_totalPage - 1 > m_currentPage);
				
				if (m_txtCurrent)	m_txtCurrent.text = String(m_currentPage + 1);
				if (m_txtTotal)	m_txtTotal.text = String(Math.max(1, m_totalPage));
				
				dispatchEvent(new PagerEvent(PagerEvent.PAGE_CHANGED, m_currentPage, m_totalPage));
			}
		}
		
		private var m_currentPage:int = -1;
		private var m_totalPage:int;
		
		private var m_btnFirst:UIButton;
		private var m_btnPrevious:UIButton;
		private var m_btnNext:UIButton;
		private var m_btnLast:UIButton;
		
		private var m_txtCurrent:UILabel;
		private var m_txtTotal:UILabel;
	}
}