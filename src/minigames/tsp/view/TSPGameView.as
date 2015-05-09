package minigames.tsp.view 
{
	import components.GrayTextButton;
	import components.Label;
	import components.SimpleLabel;
	import components.TextButton;
	import engine.AnimUpdater;
	import engine.TimeLineManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;	
	import minigames.tsp.AIInteraction;
	import minigames.tsp.BaseInteraction;
	import minigames.tsp.PencilInteraction;
	import minigames.tsp.RubberInteraction;
	import minigames.tsp.TransInteraction;
	import minigames.tsp.TSPGameManager;
	import minigames.tsp.TSPModel;
	import minigames.tsp.view.BasePlaneView;
	import util.Button;
	
	public class TSPGameView extends TSPCoreGameView 
	{
		private const PADDING:int = 20;
		
		public var planeView:BasePlaneView;
		
		private var model:TSPModel;
		private var interaction:BaseInteraction;
		private var view:BasePlaneView;
		//private var label:Button;
		private var aiInteraction:AIInteraction;
		private var aiView:BasePlaneView;
		private var manager:TSPGameManager;
		
		private var regenerateButton:GrayTextButton;
		private var revertButton:GrayTextButton;
		private var submitButton:GrayTextButton;
		
		private var lengthTitleLable:SimpleLabel;
		private var lengthLable:SimpleLabel;
		private var length1Lable:SimpleLabel;
		private var length2Lable:SimpleLabel;
		private var length3Lable:SimpleLabel;
		
		private var feedbackLabel:SimpleLabel;
		
		private var stars1:StarLabel;
		private var stars2:StarLabel;
		private var stars3:StarLabel;
		
		public function TSPGameView() 
		{
			super();
		}
		
		public function update(timePassed:int):void 
		{
			timeline.update(timePassed);
			updater.update(timePassed);
			planeView.render(timePassed);
			refreshPoints();
		}
		
		public function init():void
		{
			timeline = new TimeLineManager();
			
			regenerateButton = new GrayTextButton(120, 30, "Regenerate", "white", 16, onRegenerateClick);
			addChild(regenerateButton);
			regenerateButton.x = 640;
			regenerateButton.y = 140;
			
			revertButton = new GrayTextButton(120, 30, "Revert", "white", 16, onRevertClick);
			addChild(revertButton);
			revertButton.x = 640;
			revertButton.y = 180;
			
			submitButton = new GrayTextButton(120, 30, "Submit", "white", 16, onSubmitClick);
			addChild(submitButton);
			submitButton.x = 640;
			submitButton.y = 220;
			
			var scoreSprite:Sprite = new Sprite();
			scoreSprite.x = 700;
			scoreSprite.y = 20;
			addChild(scoreSprite);
			
			lengthTitleLable = new SimpleLabel(Label.RIGHT_Align);
			lengthTitleLable.format = "main#20";
			lengthTitleLable.text = "Length: ";
			scoreSprite.addChild(lengthTitleLable);
			lengthTitleLable.x = 0;
			lengthTitleLable.y = 0;
			
			lengthLable = new SimpleLabel();
			lengthLable.format = "main#20";
			scoreSprite.addChild(lengthLable);
			lengthLable.x = 5;
			lengthLable.y = 0;
			
			length1Lable = new SimpleLabel();
			length1Lable.format = "main#20";
			scoreSprite.addChild(length1Lable);
			length1Lable.x = 5;
			length1Lable.y = 30;
			
			length2Lable = new SimpleLabel();
			length2Lable.format = "main#20";
			scoreSprite.addChild(length2Lable);
			length2Lable.x = 5;
			length2Lable.y = 60;
			
			length3Lable = new SimpleLabel();
			length3Lable.format = "main#20";
			scoreSprite.addChild(length3Lable);
			length3Lable.x = 5;
			length3Lable.y = 90;
			
			stars1 = new StarLabel(1, 0);
			stars1.scaleX = stars1.scaleY = 0.5;
			scoreSprite.addChild(stars1);
			stars1.x = length1Lable.x - stars1.width - 5;
			stars1.y = length1Lable.y - 5;
			
			stars2 = new StarLabel(2, 0);
			stars2.scaleX = stars2.scaleY = 0.5;
			scoreSprite.addChild(stars2);
			stars2.x = length2Lable.x - stars2.width - 5;
			stars2.y = length2Lable.y - 5;
			
			stars3 = new StarLabel(3, 0);
			stars3.scaleX = stars3.scaleY = 0.5;
			scoreSprite.addChild(stars3);
			stars3.x = length3Lable.x - stars3.width - 5;
			stars3.y = length3Lable.y - 5;
			
			feedbackLabel = new SimpleLabel(Label.CENTER_Align);
			addChild(feedbackLabel);
			feedbackLabel.x = 675;
			feedbackLabel.y = 270;
			feedbackLabel.format = "main#14";
		}
		
		public function load(model:TSPModel, interaction:BaseInteraction, aiInteraction:AIInteraction, manager:TSPGameManager):void 
		{			
			this.manager = manager;
			this.aiInteraction = aiInteraction;
			this.interaction = interaction;
			this.model = model;
			planeView = getPanelView(interaction); 
			addChild(planeView);
			planeView.x = 20;
			planeView.y = 20;
			planeView.render(0);
			feedbackLabel.text = "";
			interaction.solution.addEventListener(Event.CHANGE, onSolutionChanged);
			
		}
		
		private function onSolutionChanged(e:Event):void 
		{			
			feedbackLabel.text = "";
		}
		
		public function refreshPoints():void
		{
			var validLength:Number = Math.floor(interaction.solution.length) + (interaction.solution.isValid() ? 0 : Number.POSITIVE_INFINITY);
			var points:Vector.<int> = aiInteraction.getGradingPoints();
			length1Lable.text = points[0].toFixed();
			length1Lable.format = validLength <= points[0] ? "dimmain#20" : "main#20";
			length2Lable.text = points[1].toFixed();                      
			length2Lable.format = validLength <= points[1] ? "dimmain#20" : "main#20";
			length3Lable.text = points[2].toFixed();                      
			length3Lable.format = validLength <= points[2] ? "dimmain#20" : "main#20";
			var solutionLength:int = interaction.solution.length;
			lengthLable.text = Math.floor(interaction.solution.length).toFixed();
			
			stars1.setStars(1, validLength <= points[0] ? 1 : 0);
			stars2.setStars(2, validLength <= points[1] ? 2 : 0);
			stars3.setStars(3, validLength <= points[2] ? 3 : 0);
		}
		
		override public function clear():void 
		{			
			super.clear();
			regenerateButton.enabled = true;
			revertButton.enabled = true;
			submitButton.enabled = true;
			interaction.solution.removeEventListener(Event.CHANGE, onSolutionChanged);
			removeChild(planeView);
			planeView = null;
		}
		
		public function blockButtons():void 
		{
			regenerateButton.enabled = false;
			revertButton.enabled = false;
			submitButton.enabled = false;
		}
		
		private function onSubmitClick(...params):void 
		{
			if (!interaction.solution.isValid())
			{				
				feedbackLabel.text = "All points must be connected!";
			}
			manager.submit();
		}
		
		private function onRevertClick(...params):void 
		{
			manager.revert();
		}
		
		private function onRegenerateClick(...params):void 
		{
			manager.regenerate();
		}
		
		private function getPanelView(interaction:BaseInteraction):BasePlaneView 
		{
			if (interaction is RubberInteraction)
				return new RubberPlaneView(interaction as RubberInteraction);
			if (interaction is PencilInteraction)
				return new PencilPlaneView(interaction as PencilInteraction);
			if (interaction is TransInteraction)
				return new TransPlaneView(interaction as TransInteraction, this);
			return null;
		}
	}
}