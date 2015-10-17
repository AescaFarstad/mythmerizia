package minigames.navgraph 
{
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.security.CertificateStatus;
	import flash.ui.Keyboard;
	
	public class Editor 
	{
		[Embed(source = "saveDemo.json", mimeType = "application/octet-stream")]
		public static var Save:Class;
		
		private var model:NavSpace;
		private var view:NavView;
		public var expansionAlled:Boolean = false;
		private var lastCell:CellData;
		private var demo:NavDemo;
		
		public function Editor(model:NavSpace, view:NavView, demo:NavDemo) 
		{
			this.demo = demo;
			this.view = view;
			this.model = model;
			
			view.addEventListener(MouseEvent.CLICK, onClick);
			view.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			view.stage.addEventListener(Event.ENTER_FRAME, onFrame);
			
		}
		
		private function onFrame(e:Event):void 
		{
			if (expansionAlled)
			{
				expansionAlled = false;
				model.expand();
			}
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			//expansionAlled = true;
			if (e.keyCode == Keyboard.ENTER)
				model.loadFromString(new Save());
		}
		
		private function onClick(e:MouseEvent):void 
		{
			var cell:CellData = model.cellMatrix[int(e.localY / NavView.SIZE)][int(e.localX / NavView.SIZE)];
			if (cell.x > 0 && cell.y > 0 && cell.x < NavSpace.SIZE_X - 1 && cell.y < NavSpace.SIZE_Y - 1)
			{
				if (!model.cellMatrix[cell.y][cell.x].isObstacle)
				{
					model.addAsObstacle(new Rectangle(cell.x, cell.y, 1, 1));
				}
				else				
					model.toggleObstacle(cell.x, cell.y);
			}
			Clipboard.generalClipboard.clear(); 
			Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, model.saveToString(), false); 
			if (demo)
				demo.refreshPaths();
			/*model.removeNodeAt(cell.x, cell.y);*/
			/*model.debugEdges = new Vector.<Edge>();
			model.from = model.to;			
			model.to = new Point(e.localX / NavView.SIZE, e.localY / NavView.SIZE);
			model.color = model.isDirectlyVisible(model.from, model.to, NavSpace.UNIT_SIZE) ? 0x22ff22 : 0xff2222;*/
			view.needsUpdate = true;
		}
		
	}

}