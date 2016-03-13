package minigames.countries 
{
	import components.Label;
	import flash.display.Sprite;
	import util.HMath;
	
	public class MapView extends Sprite
	{
		
		public function MapView()
		{
			super();
			
		}
		
		public function load(model:CountriesModel):void
		{
			for (var i:int = 0; i < model.countries.length; i++)
			{
				drawCountry(model.countries[i]);
			}
		}
		
		private function drawCountry(country:Country):void
		{
			graphics.beginFill(0);
			var x:Number = HMath.linearInterp( -180, 0, 180, 1000, country.x);
			var y:Number = HMath.linearInterp( 90, 0, -90, 500, country.y);
			graphics.drawCircle(x, y, 2);
			
			var label:Label = new Label();
			addChild(label);
			label.text = S.format.black(10) + country.name;
			label.x = x;
			label.y = y;
		}
		
	}
}