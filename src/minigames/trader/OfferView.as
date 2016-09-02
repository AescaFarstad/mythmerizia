package minigames.trader 
{
	import components.Label;
	import flash.display.Sprite;
	import util.Button;
	import util.layout.LayoutGroup;
	import util.layout.LayoutUtil;
	
	public class OfferView extends Sprite
	{
		private var personaLabel:Label;
		private var allGroup:LayoutGroup;
		private var rewardLabels:Vector.<Label>;
		private var priceLabel:Label;
		private var rewardGroup:LayoutGroup;
		
		private var padding:int = 5;
		private var accept:Button;
		private var reject:Button;
		private var hold:Button;
		private var buttonGroup:LayoutGroup;
		private var model:TraderModel;
		private var offer:Offer;
		
		public function OfferView()
		{
			super();
			
			allGroup = new LayoutGroup();
			
			personaLabel = new Label();
			addChild(personaLabel);
			allGroup.addElement(personaLabel);
			
			priceLabel = new Label();
			addChild(priceLabel);
			allGroup.addElement(priceLabel);
			
			rewardGroup = new LayoutGroup();
			rewardLabels = new Vector.<Label>();
			
			for (var i:int = 0; i < 3; i++)
			{				
				var label:Label = new Label();
				addChild(label);
				allGroup.addElement(label);
				rewardLabels.push(label);
				rewardGroup.addElement(label);
			}
			
			buttonGroup = new LayoutGroup();
			
			accept = new Button("Принять", onAccept);
			addChild(accept);
			buttonGroup.addElement(accept);
			reject = new Button("Отклонить", onReject);
			buttonGroup.addElement(reject);
			addChild(reject);
			hold = new Button("Придержать", onHold);
			buttonGroup.addElement(hold);
			addChild(hold);
			
			allGroup.addElement(buttonGroup);
			
		}
		
		private function onHold(e:*):void
		{
			
		}
		
		private function onReject(e:*):void
		{
			model.rejectOffer(offer);
		}
		
		private function onAccept(e:*):void
		{
			model.acceptOffer(offer);
		}
		
		public function load(offer:Offer, model:TraderModel):void
		{
			this.offer = offer;
			this.model = model;
			personaLabel.text = S.format.black(15) + offer.persona.name + S.format.black(12) + "   (осталось " + offer.daysLeft + " дней)";
			priceLabel.text = S.format.black(12) + offer.price.resource.name + ": " + offer.price.amount.toString()
			
			for (var i:int = 0; i < 3; i++)
			{
				if (offer.result.length <= i)
				{
					rewardLabels[i].visible = false;
					continue;
				}
				else
				{
					rewardLabels[i].visible = true;
					rewardLabels[i].text = S.format.black(14) + "-  " + offer.result[i].resource.name + ": " + offer.result[i].amount.toString();
				}
			}
			
			priceLabel.x = 20;
			LayoutUtil.moveAtBottom(priceLabel, personaLabel, 5);
			rewardGroup.arrangeInVerticalLineWithSpacing(3);
			LayoutUtil.moveAtBottom(rewardGroup, priceLabel, 10);
			rewardGroup.x = 5;
			
			buttonGroup.arrangeInHorizontalLineWithSpacing(5);			
			LayoutUtil.moveAtBottom(buttonGroup, rewardGroup, 10);
			
			allGroup.x = padding;
			allGroup.y = padding;
			
			graphics.clear();
			graphics.beginFill(0xe7e7e7);
			graphics.drawRect(0, 0, allGroup.baseWidth + padding * 2, allGroup.baseHeight + padding * 2);
			graphics.endFill();
			
		}
		
		public function kill():void
		{
			if (parent)
				parent.removeChild(this);
		}
		
	}
}