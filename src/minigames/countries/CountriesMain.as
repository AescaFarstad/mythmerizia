package minigames.countries 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class CountriesMain extends Sprite
	{
		
		public function CountriesMain()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, init);
			/* countrydata
			 * scout simple
			 * country list
			 * buy
			 * enclosed areas
			 */
			
		}
		
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			var model:CountriesModel = new CountriesModel();
			var view:MapView = new MapView();
			addChild(view);
			model.init();
			view.load(model);
		}
		
	}
}