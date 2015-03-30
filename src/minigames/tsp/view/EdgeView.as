package minigames.tsp.view 
{
	import components.Label;
	import flash.display.Sprite;
	import minigames.tsp.Edge;
	
	
	public class EdgeView extends Sprite 
	{
		private var edge:Edge;
		private var label:Label;
		public var lastUpdate:int;
		
		public function EdgeView() 
		{
			super();
			label = new Label(Label.CENTER_Align);
			addChild(label);
		}
		
		public function init(edge:Edge):void
		{
			this.edge = edge;
			//<#main#15:
			var txt:String = S.format.edge(14) + edge.length.toFixed();
			label.text = txt;
			label.x = edge.center.x;
			label.y = edge.center.y;
		}
		
		public function cleanUp():void
		{
			if (parent)
				parent.removeChild(this);
		}
		
	}

}