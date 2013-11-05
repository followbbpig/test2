package
{
	import engine.asset.AssetMonitor;
	import engine.asset.AssetParser;
	import engine.parsers.BitmapParser;
	import engine.parsers.ByteArrayPaster;
	import engine.parsers.JSONParser;
	import engine.parsers.JUIBinaryParser;
	import engine.parsers.JUITexturePakParser;
	import engine.parsers.TextureAtlasParser;
	import engine.parsers.TextureParser;
	import engine.parsers.XMLParser;
	
	import starling.core.Starling;

	//ddddddd
	public class Pig extends flash.display.Sprite
	{
		public function Pig()
		{
			super();
			
			// fix stage size is not the same on mobile device
			addEventListener(flash.events.Event.ENTER_FRAME, init);
		}
		
		private function init(p_event:flash.events.Event):void
		{
			removeEventListener(flash.events.Event.ENTER_FRAME, init);
			
			AssetParser.enableParsers(Vector.<Class>(
				[
					BitmapParser,
					TextureParser,
					JSONParser,
					JUIBinaryParser,
					JUITexturePakParser,
					XMLParser,
					TextureAtlasParser,
					ByteArrayPaster
				]));
			AssetMonitor.start(stage);
			
			Starling.handleLostContext = true;
			Starling.multitouchEnabled = true;
			
			m_starling = new Starling(starling.display.Sprite, stage);
			m_starling.simulateMultitouch  = false;
			m_starling.enableErrorChecking = false;
			m_starling.start();
			m_starling.addEventListener(starling.events.Event.ROOT_CREATED, function(p_event:starling.events.Event):void
			{
				Scene.context = new Context();
				Scene.context.stage = stage;
				Scene.context.stateBg = l_bg;
				Scene.context.m_root = new starling.display.Sprite();
				m_starling.stage.stageHeight = Scene.context.screenHeight;
				m_starling.stage.stageWidth = Scene.context.screenWidth;	
				m_starling.stage.addChild(Scene.context.m_root);
				m_starling.showStats = true;
				
				//Init command machine add by brady.
				Scene.cmd = new CommandMachine(Scene.context);
				
				Scene.regScene(SceneName.LOADING, Loading);
				Scene.regScene(SceneName.HOME, Home);
				Scene.regScene(SceneName.CHOOSE_COW, ChooseCow);
				Scene.regScene(SceneName.GUIDE, Guide);
				Scene.regScene(SceneName.SOUNDANDNAME, SoundAndName);
				Scene.regScene(SceneName.FARMLAND, Farmland);
				
				Scene.regScene(SceneName.TRAIN, Train);
				Scene.regScene(SceneName.SKILL, Skill);
				Scene.regScene(SceneName.SHARE, Share);
				Scene.regScene(SceneName.MARKET, Market);
				Scene.regScene(SceneName.RANK, Rank);
				Scene.regScene(SceneName.HELP, Help);
				
				Scene.gotoScene(aaaa);
				
				m_lastTime = getTimer();
				stage.addEventListener(flash.events.Event.ENTER_FRAME, onEnterFrame);
			});
		}
		
		protected function onEnterFrame(event:flash.events.Event):void
		{
			var l_nowTime:int = getTimer();
			var l_alpha:Number = (l_nowTime - m_lastTime) * 0.001;
			m_lastTime = l_nowTime;
			
			if (Scene.current)
				Scene.current.update(l_alpha);
			
			//			m_starling.nextFrame();
		}
		
		private var m_starling:Starling = null;
		private var m_lastTime:int = 0;
	}
}