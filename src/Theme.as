package  
{
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.ProgressBar;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.DisplayListWatcher;
	import feathers.core.FeathersControl;
	import feathers.core.ITextRenderer;
	import feathers.display.Scale9Image;
	import feathers.display.TiledImage;
	import feathers.skins.SmartDisplayObjectStateValueSelector;
	import feathers.system.DeviceCapabilities;
	import feathers.textures.Scale9Textures;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	import model.TextureStore;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.events.ResizeEvent;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import view.text.OutlinedTextRenderer;
	/**
	 * ...
	 * @author Nikro
	 */
	public class Theme extends DisplayListWatcher
	{
		
		[Embed(source="/../asset/fonts/a_LCDNova.ttf",fontName="a_LCDNova",mimeType="application/x-font",embedAsCFF="false")]
		protected static const LCD_NOVA_FONT:Class;
		
		protected static const ORIGINAL_DPI_IPHONE_RETINA:int = 326;
		protected static const ORIGINAL_DPI_IPAD_RETINA:int = 264;
		protected static const DEFAULT_SCALE9_GRID:Rectangle = new Rectangle(5, 5, 22, 22);
		protected static const BUTTON_SCALE9_GRID:Rectangle = new Rectangle(5, 5, 302, 32);
		protected static const BUTTON_SELECTED_SCALE9_GRID:Rectangle = new Rectangle(8, 8, 44, 44);
		protected static const BACK_BUTTON_SCALE3_REGION1:Number = 24;
		protected static const BACK_BUTTON_SCALE3_REGION2:Number = 6;
		protected static const FORWARD_BUTTON_SCALE3_REGION1:Number = 6;
		protected static const FORWARD_BUTTON_SCALE3_REGION2:Number = 6;
		protected static const ITEM_RENDERER_SCALE9_GRID:Rectangle = new Rectangle(13, 0, 2, 82);
		protected static const INSET_ITEM_RENDERER_FIRST_SCALE9_GRID:Rectangle = new Rectangle(13, 13, 3, 70);
		protected static const INSET_ITEM_RENDERER_LAST_SCALE9_GRID:Rectangle = new Rectangle(13, 0, 3, 75);
		protected static const INSET_ITEM_RENDERER_SINGLE_SCALE9_GRID:Rectangle = new Rectangle(13, 13, 3, 62);
		protected static const TAB_SCALE9_GRID:Rectangle = new Rectangle(19, 19, 50, 50);
		protected static const SCROLL_BAR_THUMB_REGION1:int = 5;
		protected static const SCROLL_BAR_THUMB_REGION2:int = 14;
		
		[Inject]
		public var textureStore:TextureStore;
		
		protected static function f():ITextRenderer
		{
			var renderer:ITextRenderer = new OutlinedTextRenderer();
			
			return renderer
		}
		
		protected static function textRendererFactory():TextFieldTextRenderer
		{
			return new TextFieldTextRenderer();
		}

		protected static function textEditorFactory():StageTextTextEditor
		{
			return new StageTextTextEditor();
		}
		
		public function Theme(textureAtlas:TextureAtlas, container:DisplayObjectContainer = null, scaleToDPI:Boolean = true)
		{
			inject(this);
			atlas = textureAtlas;
			if(!container)
			{
				container = Starling.current.stage;
			}
			
			super(container)
			this._scaleToDPI = scaleToDPI;
			this.initialize();
		}
		
		protected var _originalDPI:int;

		public function get originalDPI():int
		{
			return this._originalDPI;
		}

		protected var _scaleToDPI:Boolean;

		public function get scaleToDPI():Boolean
		{
			return this._scaleToDPI;
		}

		protected var scale:Number = 1;
		
		protected var primaryBackgroundTexture:Texture
		protected var primaryBackground:TiledImage;
		
		protected var headerTextFormat:TextFormat;
		protected var alertTextFormat:TextFormat;
		protected var buttonTextFormat:TextFormat;
		protected var buttonTextFormatDown:TextFormat;
		
		
		protected var buttonUpSkinTextures:Scale9Textures;
		protected var buttonDownSkinTextures:Scale9Textures;
		
		protected var backgroundSkinTextures:Scale9Textures;
		protected var backgroundDisabledSkinTextures:Scale9Textures;
		protected var backgroundFocusedSkinTextures:Scale9Textures;
		protected var backgroundPopUpSkinTextures:Scale9Textures;
		protected var alertStyle:StyleSheet;
		
		
		public var atlas:TextureAtlas;
		protected var atlasBitmapData:BitmapData;
		
		override public function dispose():void
		{
			if(this.root)
			{
				this.root.removeEventListener(Event.ADDED_TO_STAGE, root_addedToStageHandler);
				if(this.primaryBackground)
				{
					this.root.stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
					this.root.removeEventListener(Event.REMOVED_FROM_STAGE, root_removedFromStageHandler);
					this.root.removeChild(this.primaryBackground, true);
					this.primaryBackground = null;
				}
			}
			if(this.atlas)
			{
				this.atlas.dispose();
				this.atlas = null;
			}
			if(this.atlasBitmapData)
			{
				this.atlasBitmapData.dispose();
				this.atlasBitmapData = null;
			}
			super.dispose();
		}
		
		protected function initializeRoot():void
		{
			this.primaryBackground = new TiledImage(this.primaryBackgroundTexture);
			this.primaryBackground.width = root.stage.stageWidth;
			this.primaryBackground.height = root.stage.stageHeight;
			this.root.addChildAt(this.primaryBackground, 0);
			this.root.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
			this.root.addEventListener(Event.REMOVED_FROM_STAGE, root_removedFromStageHandler);
		}
		
		protected function initialize():void
		{
			const scaledDPI:int = DeviceCapabilities.dpi / Starling.contentScaleFactor;
			this._originalDPI = scaledDPI;
			if(this._scaleToDPI)
			{
				if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
				{
					this._originalDPI = 72//ORIGINAL_DPI_IPAD_RETINA;
				}
				else
				{
					this._originalDPI = ORIGINAL_DPI_IPHONE_RETINA;
				}
			}

			this.scale = scaledDPI / this._originalDPI;

			FeathersControl.defaultTextRendererFactory = textRendererFactory;
			FeathersControl.defaultTextEditorFactory = textEditorFactory;

			const regularFontNames:String = "SourceSansPro";
			const semiboldFontNames:String = "a_LCDNova";

			
			if(Starling.handleLostContext)
			{
				this.atlasBitmapData = atlasBitmapData;
			}
			else
			{
				atlasBitmapData.dispose();
			}

			
			alertStyle = new StyleSheet();
			alertStyle.parseCSS
							(
								  "button{fontWeight:bold; fontSize:35; color:#FFFFFF;}"
								+ "header{fontWeight:bold; fontSize:20;}"
								+ "scores{fontSize:20}"
								+ "a:link { text-decoration:none; }"
								+ "a:hover{text-decoration:underline;}"
							
							);
			
			this.primaryBackgroundTexture = textureStore.getTexture("bg.png");
			
			var backgroundSkinTexture:Texture = textureStore.getTexture("bg.png");
			var backgroundDisabledSkinTexture:Texture = textureStore.getTexture("bg.png");
			var backgroundFocusedSkinTexture:Texture = textureStore.getTexture("bg.png");
			var backgroundPopUpSkinTexture:Texture = textureStore.getTexture("bg.png");
			
			this.backgroundSkinTextures = new Scale9Textures(backgroundSkinTexture, DEFAULT_SCALE9_GRID);
			this.backgroundDisabledSkinTextures = new Scale9Textures(backgroundDisabledSkinTexture, DEFAULT_SCALE9_GRID);
			this.backgroundFocusedSkinTextures = new Scale9Textures(backgroundFocusedSkinTexture, DEFAULT_SCALE9_GRID);
			this.backgroundPopUpSkinTextures = new Scale9Textures(backgroundPopUpSkinTexture, DEFAULT_SCALE9_GRID);
			
			this.alertTextFormat = new TextFormat(semiboldFontNames, 27 * this.scale, 0xAAA7A5);
			this.buttonTextFormat = new TextFormat(semiboldFontNames, 27 * this.scale, 0xAAA7A5);
			this.buttonTextFormatDown = new TextFormat(semiboldFontNames, 27 * this.scale, 0xBE651C);
			
			this.buttonUpSkinTextures = new Scale9Textures(this.atlas.getTexture("big_button_normal"), BUTTON_SCALE9_GRID);
			this.buttonDownSkinTextures = new Scale9Textures(this.atlas.getTexture("big_button_down"), BUTTON_SCALE9_GRID);
			
			
			if(this.root.stage)
			{
				this.initializeRoot();
			}
			else
			{
				this.root.addEventListener(Event.ADDED_TO_STAGE, root_addedToStageHandler);
			}
			
			this.setInitializerForClass(Button, buttonInitializer);
			this.setInitializerForClass(ProgressBar, progressBarInitializer);
			this.setInitializerForClass(Label, labelInitializer);
		}
		
		protected function labelInitializer(label:Label):void
		{
			label.textRendererProperties.styleSheet = alertStyle;
			label.textRendererProperties.textFormat = this.alertTextFormat;
			label.textRendererProperties.embedFonts = true;
			label.textRendererProperties.isHTML = true;
			//label.textRendererProperties.border = true;
			//label.textRendererProperties.borderColor = 0xFFFFFF;
			
		}
		
		protected function progressBarInitializer(progress:ProgressBar):void
		{
			const backgroundSkin:Scale9Image = new Scale9Image(this.backgroundSkinTextures, this.scale);
			backgroundSkin.width = 240 * this.scale;
			backgroundSkin.height = 22 * this.scale;
			progress.backgroundSkin = backgroundSkin;

			const backgroundDisabledSkin:Scale9Image = new Scale9Image(this.backgroundDisabledSkinTextures, this.scale);
			backgroundDisabledSkin.width = 240 * this.scale;
			backgroundDisabledSkin.height = 22 * this.scale;
			progress.backgroundDisabledSkin = backgroundDisabledSkin;

			const fillSkin:Scale9Image = new Scale9Image(this.buttonUpSkinTextures, this.scale);
			fillSkin.width = 8 * this.scale;
			fillSkin.height = 22 * this.scale;
			progress.fillSkin = fillSkin;
		}
		
		
		protected function buttonInitializer(button:Button):void
		{
			const skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();
			skinSelector.defaultValue = this.buttonUpSkinTextures;
			//skinSelector.defaultSelectedValue = this.buttonSelectedUpSkinTextures;
			skinSelector.setValueForState(this.buttonDownSkinTextures, Button.STATE_DOWN, false);
			//skinSelector.setValueForState(this.buttonDisabledSkinTextures, Button.STATE_DISABLED, false);
			//skinSelector.setValueForState(this.buttonSelectedDisabledSkinTextures, Button.STATE_DISABLED, true);
			skinSelector.displayObjectProperties =
			{
				width: 311 * this.scale,
				height: 42 * this.scale,
				textureScale: this.scale
			};
			button.stateToSkinFunction = skinSelector.updateValue;
			this.baseButtonInitializer(button);
		}
		
		protected function baseButtonInitializer(button:Button):void
		{
			button.defaultLabelProperties.textFormat = this.buttonTextFormat;
			button.defaultLabelProperties.embedFonts = true;
			//button.disabledLabelProperties.textFormat = this.smallUIDisabledTextFormat;
			//button.disabledLabelProperties.embedFonts = true;
			//button.selectedDisabledLabelProperties.textFormat = this.smallUIDisabledTextFormat;
			//button.selectedDisabledLabelProperties.embedFonts = true;
			
			button.downLabelProperties.textFormat = this.buttonTextFormatDown;
			button.downLabelProperties.embedFonts = true;
			button.labelFactory = f

			button.paddingTop = 5 * this.scale;
			//button.paddingLeft = button.paddingRight = 16 * this.scale;
			//button.gap = 12 * this.scale;
			//button.minWidth = button.minHeight = 60 * this.scale;
			//button.minTouchWidth = button.minTouchHeight = 88 * this.scale;
		}
		
		protected function stage_resizeHandler(event:ResizeEvent):void
		{
			this.primaryBackground.width = event.width;
			this.primaryBackground.height = event.height;
		}

		protected function root_addedToStageHandler(event:Event):void
		{
			this.root.removeEventListener(Event.ADDED_TO_STAGE, root_addedToStageHandler);
			this.initializeRoot();
		}
		
		protected function root_removedFromStageHandler(event:Event):void
		{
			this.root.removeEventListener(Event.REMOVED_FROM_STAGE, root_removedFromStageHandler);
			this.root.stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
			this.root.removeChild(this.primaryBackground, true);
			this.primaryBackground = null;
		}

	}

}