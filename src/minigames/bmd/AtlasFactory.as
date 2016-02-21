package minigames.bmd 
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	public class AtlasFactory
	{
		[Embed(source = "../../../lib/pics/atlas.xml", mimeType="application/octet-stream")]
		private var xml:Class;
		
		public function AtlasFactory()
		{
			
		}
		
		public function create():TextureAtlas
		{
			var  shape:Shape = new Shape();
			
			shape.graphics.beginFill(0xe0e0e0);
			shape.graphics.drawRect(0, 0, 20, 20);
			shape.graphics.endFill();
			
			shape.graphics.beginFill(0x88ff88);
			shape.graphics.drawCircle(27, 7, 7);
			shape.graphics.endFill();
					
			shape.graphics.beginFill(0xff4444);
			shape.graphics.drawRoundRect(34, 0, 20, 20, 4, 4);
			shape.graphics.endFill();
			
			var rect:Rectangle = shape.getBounds();
			var data:BitmapData = new BitmapData(rect.width, rect.height, true, 0x00000000);
			data.draw(shape);
			
			var texture:Texture = Texture.fromBitmapData(data);
			var xml:XML = XML(new xml());
			var atlas:TextureAtlas = new TextureAtlas(texture, xml);
			
			
		}
		
	}
}