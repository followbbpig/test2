package engine.ui.base
{
	import engine.asset.AssetVisitor;
	import engine.assets.AssetsPool;
	import engine.contants.AssetType;
	import engine.framework.command.BaseCommand;
	import engine.framework.core.Facade;
	import engine.framework.entity.IEntity;
	import engine.message.Debuger;
	import engine.message.IMessageSender;
	import engine.message.MessageHelper;
	import engine.message.StarlingEventHelper;
	import engine.ui.control.UIAnimation;
	import engine.ui.control.UIButton;
	import engine.ui.control.UIImage;
	import engine.ui.control.UILabel;
	import engine.ui.control.UIList;
	import engine.ui.control.UILoader;
	import engine.ui.control.UIPager;
	import engine.ui.control.UIProgress;
	import engine.ui.control.UIRelativeContainer;
	import engine.ui.control.UIScale9Image;
	import engine.ui.control.UIScrollBar;
	import engine.ui.control.UITileList;
	import engine.ui.control.UIViewContainer;
	
	public class BaseUIView extends UIViewContainer implements IMessageSender, IEntity
	{
		public function BaseUIView()
		{
			// import those classes
			UILoader;
			UIImage;
			UIButton;
			UILabel;
			UIProgress;
			UIPager;
			UITileList;
			UIScrollBar;
			UIList;
			UIAnimation;
			UIScale9Image;
			UIRelativeContainer;
			
			super();
			
			m_messageHelper = new MessageHelper();
			m_starlingEventHelper = new StarlingEventHelper(this);
			
			Debuger.instance.registerEntity(this);
		}
		
		public function get view():*
		{
			return this;
		}
		
		public function doCommand(p_cmd:BaseCommand):void
		{
			Facade.cmd.doCommand(p_cmd);
		}
		
		override public function viewLoaded():void
		{
		}
		
		override public function destroy():void
		{
			m_messageHelper.destroy();
			m_starlingEventHelper.destroy();
			
			Debuger.instance.unregisterEntity(this);
			
			super.destroy();
		}
		
		public final function initWithJson(p_path:String, p_specialClassDict:Object = null):void
		{
			//initWithGUI(AssetsPool.instance.getAsset(AssetType.OBJECT, p_path), p_specialClassDict);
			var l_visitor:AssetVisitor = new AssetVisitor();
			initWithGUI(l_visitor.retain(p_path, AssetType.OBJECT), p_specialClassDict);
			l_visitor.destroy();
		}
		
		public function sendMsg(p_type:String, p_msg:*=null):void
		{
			m_messageHelper.sendMsg(p_type, p_msg);
		}
		
		override public function addEventListener(p_type:String, p_listener:Function):void
		{
			m_starlingEventHelper.addListener(p_type, p_listener);
			super.addEventListener(p_type, p_listener);
		}
		
		override public function removeEventListener(p_type:String, p_listener:Function):void
		{
			m_starlingEventHelper.removeListener(p_type, p_listener);
			super.removeEventListener(p_type, p_listener);
		}
		
		protected var m_messageHelper:MessageHelper;
		private var m_starlingEventHelper:StarlingEventHelper;
	}
}