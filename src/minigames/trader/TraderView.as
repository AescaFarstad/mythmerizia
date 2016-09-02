package minigames.trader 
{
	import components.Label;
	import flash.display.Sprite;
	import util.layout.LayoutGroup;
	import util.layout.LayoutUtil;
	
	public class TraderView extends Sprite
	{
		private var resources:Vector.<ResourceView>;
		private var offers:Vector.<OfferView>;
		private var model:TraderModel;
		private var counter:Label;
		
		public function TraderView()
		{
			super();
			
		}
		
		public function load(model:TraderModel):void
		{
			this.model = model;
			resources = new Vector.<ResourceView>();
			var group:LayoutGroup = new LayoutGroup();
			for (var i:int = 0; i < model.resources.length; i++)
			{
				var view:ResourceView = new ResourceView();
				view.load(model.resources[i]);
				resources.push(view);
				addChild(view);
				group.addElement(view);
			}
			group.arrangeInVerticalLineWithSpacing(10);
			
			group.x = 15;
			group.y = 35;
			
			var groupOffers:LayoutGroup = new LayoutGroup();
			offers = new Vector.<OfferView>();
			for (i = 0; i < model.offers.length; i++)
			{
				var viewOffer:OfferView = new OfferView();
				viewOffer.load(model.offers[i], model);
				offers.push(viewOffer);
				addChild(viewOffer);
				groupOffers.addElement(viewOffer);
			}
			
			groupOffers.arrangeInVerticalLineWithSpacing(10);
			
			groupOffers.x = 300;
			groupOffers.y = 35;
			
			counter = new Label();
			addChild(counter);
			counter.y = 5;
			LayoutUtil.moveToSameHorCenter(counter, stage);
			
			model.onChange.add(onChange);
		}
		
		private function onChange():void
		{
			for (var i:int = 0; i < offers.length; i++)
			{
				offers[i].kill();
			}
			
			var groupOffers:LayoutGroup = new LayoutGroup();
			offers = new Vector.<OfferView>();
			for (i = 0; i < model.offers.length; i++)
			{
				var viewOffer:OfferView = new OfferView();
				viewOffer.load(model.offers[i], model);
				offers.push(viewOffer);
				addChild(viewOffer);
				groupOffers.addElement(viewOffer);
			}
			
			groupOffers.arrangeInVerticalLineWithSpacing(10);
			
			groupOffers.x = 300;
			groupOffers.y = 35;
		}
		
		public function update(timePassed:int):void
		{
			for (var i:int = 0; i < resources.length; i++)
			{
				resources[i].load(model.resources[i]);
			}
			counter.text = S.format.black(20) + model.day.toString() + "/" + model.maxDay.toString();
		}
		
		
		
	}
}