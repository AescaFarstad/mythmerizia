package minigames.countries 
{
	public class CountriesModel
	{
		[Embed(source="countries.csv", mimeType="application/octet-stream")]
		private var countryData:Class;
		
		public var countries:Vector.<Country> = new Vector.<Country>();
		
		public function CountriesModel()
		{
			
		}
		
		public function init():void
		{
			var cData:String = new countryData();
			var array:Array = cData.split("\n");
			for (var i:int = 0; i < array.length; i++)
			{
				var subArray:Array = array[i].split(",");
				var country:Country = new Country(subArray[0], Number(subArray[2]), Number(subArray[1]));
				countries.push(country);
			}
		}
		
	}
}