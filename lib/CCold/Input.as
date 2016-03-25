package minigames.clik_or_crit 
{
	import minigames.clik_or_crit.data.CCModel;
	import minigames.clik_or_crit.data.Hero;
	import minigames.clik_or_crit.view.CCView;
	

	public class Input implements IInputListener
	{
		private var view:CCView;
		private var model:CCModel;
		
		public function Input(view:CCView, model:CCModel) 
		{
			this.model = model;
			this.view = view;
			view.inputListener = this;
		}
		
		public function onHeroCLick(hero:Hero):void 
		{
			model.onHeroClick(hero);
		}
		
		public function onNextZone():void 
		{
			model.goToNextZone();
		}
		
		public function onPrevZone():void 
		{
			model.goToPrevZone();
		}
		
		
	}

}