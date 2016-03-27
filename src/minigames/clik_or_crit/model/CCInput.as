package minigames.clik_or_crit.model 
{
	import minigames.clik_or_crit.lib.BuildingItem;
	public class CCInput 
	{
		public var model:CCModel;
		
		public function CCInput(model:CCModel) 
		{
			this.model = model;
			
		}
		
		public function takeCountry(country:Country):void 
		{
			if (country.discovered && !country.owned)
			{
				country.owned = true;
				model.scouting.reloadHull();
				model.scouting.onCountryTaken.dispatch(country);
			}
		}
		
		public function scoutIn():void
		{
			model.scouting.scoutIn();
		}
		
		public function scoutOut():void
		{
			model.scouting.scoutOut();
		}
		
		public function tryToBuild(building:BuildingItem, country:Country):void 
		{
			model.scouting.tryToBuild(building, country);
		}
		
	}

}