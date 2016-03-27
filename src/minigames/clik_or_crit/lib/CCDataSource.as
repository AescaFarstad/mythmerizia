package minigames.clik_or_crit.lib 
{
	import minigames.clik_or_crit.model.CCModel;
	import minigames.clik_or_crit.model.Country;
	import util.SeededRandom;
	
	public class CCDataSource 
	{
		static public function init(model:CCModel):void
		{
			for (var i:int = 0; i < CCLibrary.countries.list.length; i++) 
			{
				model.loadCountry(CCLibrary.countries.list[i]);
			}
			
			model.loadResource({name:"money", cap:1000, value:100});
			
			var startingCountry:Country = new SeededRandom().getItem(model.scouting.countries);
			startingCountry.owned = true;
			startingCountry.discovered = true;
			startingCountry.building = CCLibrary.buildings.byID(1);
			
		}
		
	}

}