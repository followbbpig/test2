package engine.ui.control
{
	import engine.core.Localization;
	
	import flash.display.BitmapData;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.textures.Texture;

	public class UILabel extends UIView
	{
		public static function set embed(p_value:Boolean):void
		{
			EMBED = p_value;
			if (p_value)
			{
				FONT_WEIGHT_MAP["MicrosoftYaHei"][0] = "weiyuanyahei";
			}
		}
		
		public function set color(p_value:uint):void
		{
			m_textFormat.color = p_value;
			m_textField.setTextFormat(m_textFormat);
			m_needRedraw = true;
		}
		
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			if (null != m_inputText)
			{
				m_inputText.visible = value;
			}
		}
		
		
		public function set glow(p_value:Boolean):void
		{
			if (p_value)
			{
				m_textField.filters = getTextFilter(int(m_textField.defaultTextFormat.size));
			}
			else
			{
				m_textField.filters = [];
			}
			
			m_needRedraw = true;
		}
		
		public function get textField():TextField { return m_textField; }
		
		public function get text():String { return (m_inputText) ? m_inputText.text : m_textField.text; }
		public function set text(p_text:String):void
		{
			var l_label:String = Localization.instance.getString(p_text);
			
			if (m_inputText)
			{
				m_inputText.text = (l_label)?l_label:"";
			}
			else if (m_textField && m_textField.text != l_label)
			{
				m_textField.text = (l_label)?l_label:"";
				m_textField.height = m_textField.textHeight + 4;
				
				m_needRedraw = true;
			}
		}
		
		override public function getBounds(targetSpace:DisplayObject, resultRect:Rectangle=null):Rectangle
		{
			if (null == m_hitArea)
			{
				m_hitArea = new Rectangle(0, 0, m_properties["width"], m_properties["height"])	
			}
			
			if (null != m_textField)
			{
				m_hitArea.width = m_textField.width;
				m_hitArea.height = m_textField.height;
			}			
			return m_hitArea;
		}
		
		public function UILabel() 
		{
			super();
		}
		
		override public function viewLoaded():void
		{
			super.viewLoaded();
			
			touchable = false;
			
			m_textField = new TextField();
			m_textFormat = new TextFormat();
			m_hitArea = new Rectangle(0, 0, m_properties["width"], m_properties["height"]);
			m_textFormat.color = parseInt(m_properties["color"].substr(1), 16);
			if(m_properties["align"]) m_textFormat.align = m_properties["align"];
			if(m_properties["size"]) m_textFormat.size = parseInt(m_properties["size"]);
			if (m_properties["font"])
			{
				if (FONT_WEIGHT_MAP.hasOwnProperty(m_properties["font"]))
				{
					if (m_properties["font"] == "MicrosoftYaHei")
					{
						m_textField.embedFonts = EMBED;
					}
					
					var l_fontObj:Array = FONT_WEIGHT_MAP[m_properties["font"]];
					m_textFormat.font = l_fontObj[0];
					m_textFormat.bold = l_fontObj[1];
					m_textFormat.italic = l_fontObj[2];
					m_textFormat.letterSpacing = (l_fontObj[3]) ? getTextSpace(int(m_textFormat.size)) : 0;
				}
				else
				{
					throw new Error("do not contain font " + m_properties["font"]);
				}
			}
			
			m_textField.defaultTextFormat = m_textFormat;
			m_textField.width = parseInt(m_properties["width"]);
			m_textField.height = parseInt(m_properties["height"]);
			m_textField.multiline = true;
			m_textField.wordWrap = true;
			m_textField.text = Localization.instance.getString(m_properties["text"]);
			
			if (m_textField.height < m_textField.textHeight + 4)
			{
				//trace(m_textField.text, m_textField.height, m_textField.textHeight);
				//throw new Error("text height is too small");
			}
			
			// default text has glow
//			if (0xFFD317 != m_textField.defaultTextFormat.color && 0 < m_textField.defaultTextFormat.color)
//			{
//				glow = true;
//			}
			
			m_needRedraw = true;
		}
		
		override public function destroy():void
		{
			if (m_inputText)
			{
				m_inputText.destroy();
			}
			else if (null != m_textImage)
			{
				removeChild(m_textImage);
				m_textImage.texture.dispose();
				m_textImage.dispose();
			}
			m_textField = null;
			
			super.destroy();
		}
		
		override public function render(support:RenderSupport, parentAlpha:Number):void
		{
			if (null == m_inputText &&
				true == m_needRedraw)
			{
				drawText();
			}
			super.render(support, parentAlpha);
		}
		
		private function drawText():void
		{
			m_needRedraw = false;
			
			var l_bitmapData:BitmapData = new BitmapData(m_textField.width, m_textField.height, true, 0x0);
			l_bitmapData.draw(m_textField);
			var l_texture:Texture = Texture.fromBitmapData(l_bitmapData, false);
			
			if (null == m_textImage) 
			{
				m_textImage = new Image(l_texture);
				m_textImage.touchable = false;
				addChild(m_textImage);
			}
			else 
			{ 
				m_textImage.texture.dispose();
				m_textImage.texture = l_texture; 
				m_textImage.readjustSize(); 
			}
		}
		
		public function setInput(p_scale:Number = 1):void
		{
			if (null == m_inputText)
			{
				m_inputText = new InputText(this, p_scale);
				if (null != m_textImage)
				{
					removeChild(m_textImage);
					m_textImage.texture.dispose();
					m_textImage.dispose();
				}
				m_needRedraw = false;
			}
		}
		
		private function getTextFilter(p_size:int):Array
		{
			var l_filter:GlowFilter;
			l_filter = new GlowFilter(0x4C4C4C, 1, 2, 2, 32, BitmapFilterQuality.MEDIUM);
			return [l_filter];
		}
		
		private function getTextSpace(p_size:int):int
		{
			return 0;
		}
		
		private static const FONT_WEIGHT_MAP:Object = {
			"Impact":["Impact",false,false,0],
			"TrebuchetMS-Bold":["Trebuchet MS",true,false,0],
			"TrebuchetMS":["Trebuchet MS",false,false,0],
			"TrebuchetMS-Italic":["Trebuchet MS",false,true,0],
			"Trebuchet-BoldItalic":["Trebuchet MS",true,true,0],
			"CollegeBold":["College",true,false,0],
			"College":["College",false,false,0],
			"UScoreRGH":["UScoreRGH",false,false,0],
			"Arial-BoldMT":["Arial",true,false,2],
			"Arial-Black":["Arial",true,false,2],
			"_sans":["Arial",false,false,0],
			"ArialMT":["Arial",false,false,2],
			"SimSun":["SimSun",false,false,0],
			"MicrosoftYaHei":["Microsoft YaHei",false,false,2]
		}
		
		private static var EMBED:Boolean = false;
			
		private var m_textField:TextField;
		private var m_inputText:InputText;
		private var m_textImage:Image;
		
		private var m_textFormat:TextFormat;
		private var m_needRedraw:Boolean;
		
		private var m_hitArea:Rectangle;
	}
}


import engine.ui.control.UILabel;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TextEvent;
import flash.geom.Point;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;

import starling.core.Starling;

class InputText extends TextField
{
	public function InputText(p_label:UILabel, p_scale:Number)
	{
		m_label = p_label;
		//trace("InputText", l_pt);
		Starling.current.nativeStage.addChild(this);
		width = p_label.width * p_scale;
		height = p_label.height * p_scale;
		defaultTextFormat = p_label.textField.defaultTextFormat;
		text = p_label.textField.text;
		type = TextFieldType.INPUT;
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
		addEventListener(MouseEvent.CLICK, onClick);
		
		Starling.current.nativeStage.addChild(this);
	}
	public function destroy():void
	{
		removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		removeEventListener(MouseEvent.CLICK, onClick);
		Starling.current.nativeStage.removeChild(this);
	}
	
	private function onEnterFrame(e:Event):void
	{
		// TODO Auto Generated method stub
		var l_pt:Point = m_label.localToGlobal(new Point);
		x = l_pt.x;
		y = l_pt.y;
	}
	
	protected function onClick(e:MouseEvent):void
	{
		setSelection(0, text.length);
	}
	
	private var m_input:TextField;
	private var m_label:UILabel;
}
