package components
{
	import flash.display.Sprite;
	import flash.text.engine.*
	import flash.utils.Dictionary;
	
	public class Font
	{
		//[Embed(source = '../../lib/fonts/nobile_bold.ttf', fontName = 'nobile', fontWeight = "bold"/*, unicodeRange = "U+0020-U+007E, U+005B-U+0060, U+007B-U+007E"*/, mimeType='application/x-font-truetype')]
		[Embed(source = '../../lib/fonts/Days.otf', fontName = 'nobile', fontWeight = "bold", mimeType='application/x-font-truetype')]
		public var nobile_boldClass:String;
		//[Embed(source = '../../lib/fonts/nobile.ttf', fontName = 'nobile', fontWeight = "normal"/*, unicodeRange = "U+0020-U+007E, U+005B-U+0060, U+007B-U+007E"*/, mimeType = 'application/x-font-truetype')]
		[Embed(source = '../../lib/fonts/Days.otf', fontName = 'nobile', fontWeight = "normal", mimeType = 'application/x-font-truetype')]
		public var nobileClass:String;
		[Embed(source = '../../lib/fonts/JuraMedium.ttf', fontName = 'Jura', fontWeight = "normal"/*, unicodeRange = "U+0020-U+007E, U+005B-U+0060, U+007B-U+007E"*/, mimeType = 'application/x-font-truetype')]
		public var JuraMediumClass:String;
		
		private static var fonts:Dictionary;//name, font, color
		private static var initialized:Boolean = false;
		
		public static function init():void
		{
			initialized = true;
			fonts = new Dictionary(true); 
			var fd:FontDescription = new FontDescription("nobile", "bold", "normal", FontLookup.EMBEDDED_CFF);
			fonts["nobile"] = ( { font:fd, color:0xcdee00 } );
			//------------------------------------------------------------------------------
			fd = new FontDescription("Jura", "normal", "normal", FontLookup.EMBEDDED_CFF);
			fonts["jura"] = ( { font:fd, color:0xfeffbb } );
			//------------------------------------------------------------------------------
			fd = new FontDescription("Jura", "normal", "normal", FontLookup.EMBEDDED_CFF);
			fonts["edge"] = ( { font:fd, color:0x333333 } );
			//------------------------------------------------------------------------------
			fd = new FontDescription("nobile", "normal", "normal", FontLookup.EMBEDDED_CFF);
			fonts["main"] = ( { font:fd, color:0x555555 } );
			//------------------------------------------------------------------------------
			fd = new FontDescription("nobile", "normal", "normal", FontLookup.EMBEDDED_CFF);
			fonts["white"] = ( { font:fd, color:0xffffff } );
			//------------------------------------------------------------------------------
			fd = new FontDescription("nobile", "normal", "normal", FontLookup.EMBEDDED_CFF);
			fonts["dimmain"] = ( { font:fd, color:0xaaaaaa } );
			//------------------------------------------------------------------------------
			fd = new FontDescription("nobile", "normal", "normal", FontLookup.EMBEDDED_CFF);
			fonts["gold"] = ( { font:fd, color:0xcccc00 } );
			//------------------------------------------------------------------------------
			fd = new FontDescription("Jura", "normal", "normal", FontLookup.EMBEDDED_CFF);
			fonts["blood"] = ( { font:fd, color:0xcc0000 } );
			//------------------------------------------------------------------------------
			fd = new FontDescription("nobile", "normal", "normal", FontLookup.EMBEDDED_CFF);
			fonts["black"] = ( { font:fd, color:0x000000 } );
			//------------------------------------------------------------------------------
		}
		
		public static function getFontsDictionary():Dictionary
		{
			if (!initialized)
			{
				init();
			}
			return fonts;
		}
		
		public static function byName(s:String):ElementFormat
		{
			if (!initialized)
			{
				init();
			}
			var temp:int = s.search("#");
			var sz:int = Number(s.slice(temp + 1));
			try
			{
				var fd:FontDescription = fonts[s.slice(0, temp)].font;
			}
			catch (e:Error)
			{
				throw("Font not recognised ("+s+").");
			}
			return new ElementFormat(fd, sz, fonts[s.slice(0, temp)].color);
		}
	}
	
}