package minigames.navgraph 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class NavView extends Sprite 
	{
		public static const SIZE:int = 20;
		public var needsUpdate:Boolean;
		
		private var model:NavSpace;
		
		public function NavView(model:NavSpace) 
		{
			super();
			this.model = model;
			
			render();
			addEventListener(Event.ENTER_FRAME, onFrame);
			needsUpdate = true;
		}
		
		private function onFrame(e:Event):void 
		{
			render();
		}
		
		public function render():void 
		{
			if (!needsUpdate)
				return;
			graphics.clear();
			graphics.lineStyle(1, 0, 0);
			graphics.beginFill(0, 0.05);
			graphics.drawRect(0, 0, NavSpace.SIZE_X * SIZE, NavSpace.SIZE_Y * SIZE);
			graphics.endFill();
			var k:int;
			
			/*
			var meshPadding:int = 2;			
			for (var k:int = 0; k < model.meshes.length; k++) 
			{
				graphics.lineStyle(1, 0, 0);
				graphics.beginFill(0x00ff00, 0.4);
				graphics.drawRect(model.meshes[k].x * SIZE + meshPadding, model.meshes[k].y * SIZE + meshPadding, 
					model.meshes[k].width * SIZE - meshPadding * 2, model.meshes[k].height * SIZE - meshPadding * 2);
				graphics.endFill();
				
				for (var m:int = 0; m < model.meshes[k].linkage.length; m++) 
				{
					graphics.lineStyle(1, 0x0000ff, 0.5);
					graphics.moveTo(SIZE * (model.meshes[k].x + model.meshes[k].width / 2), 
									SIZE * (model.meshes[k].y + model.meshes[k].height / 2));
					graphics.lineTo(SIZE * (model.meshes[k].linkage[m].x + model.meshes[k].linkage[m].width / 2), 
									SIZE * (model.meshes[k].linkage[m].y + model.meshes[k].linkage[m].height / 2));
					
				}
			}*/
			graphics.lineStyle(1, 0, 0);
			
			for (var j:int = 0; j < model.cellMatrix.length; j++) 
			{
				for (var i:int = 0; i < model.cellMatrix[j].length; i++) 
				{
					if (model.cellMatrix[j][i].isObstacle)
					{
						graphics.beginFill(0xcccccc, 1);
						graphics.drawRect(i * SIZE, j * SIZE, SIZE, SIZE);
						graphics.endFill();
					}/*
					else
					{
						if (model.cellMatrix[j][i].nearestNodes.length == 0)
							continue;
						graphics.lineStyle(1, 0x0, 0);
						graphics.beginFill(model.cellMatrix[j][i].nearestNodes.length > 1 ? 0xffffff : model.cellMatrix[j][i].nearestNodes[0].debugColor);
						graphics.drawRect(i * SIZE + 2, j * SIZE + 2, SIZE - 4, SIZE - 4);
						graphics.endFill();
					}*/
				}
			}
			/*
			for (i = 0; i < model.cellMatrix.length; i++) 
			{
				for (j = 0; j < model.cellMatrix[i].length; j++) 
				{
					if (model.cellMatrix[j][i].nearestNodes.length != 1)
						continue;
					graphics.lineStyle(1, 0xffffff, 1);
					graphics.moveTo(i * SIZE + SIZE / 2, j * SIZE + SIZE / 2);
					graphics.lineTo(model.cellMatrix[j][i].nearestNodes[0].cell.x * SIZE + SIZE / 2, 
									model.cellMatrix[j][i].nearestNodes[0].cell.y * SIZE + SIZE / 2);
				}
			}*/
			/*
			for (i = 0; i < model.cellMatrix.length; i++) 
			{
				for (j = 0; j < model.cellMatrix[i].length; j++) 
				{
					if (isWithinFrontier(model.cellMatrix[j][i]))
					{
						graphics.lineStyle(1, 0x0, 1);
						graphics.beginFill(0, 0);
						graphics.drawRect(i * SIZE + 5, j * SIZE + 5, SIZE - 10, SIZE - 10);
						graphics.endFill();
					}
				}
			}*/
			/*
			for (k = 0; k < model.edges.length; k++) 
			{
				graphics.lineStyle(1, 0x0000ff, 0.5);
				graphics.moveTo(SIZE * model.edges[k].p1.x, SIZE * model.edges[k].p1.y); 
				graphics.lineTo(SIZE * model.edges[k].p2.x, SIZE * model.edges[k].p2.y); 
			}
			
			for (k = 0; k < model.checkedCells.length; k++) 
			{
				graphics.lineStyle(1, 0x0, 0);
				graphics.beginFill(model.color, 0.4);
				graphics.drawRect(model.checkedCells[k].x * SIZE + 1, model.checkedCells[k].y * SIZE + 1, SIZE - 2, SIZE - 2);
				graphics.endFill();
			}
			
			for (k = 0; k < model.debugPoints.length; k++) 
			{
				graphics.lineStyle(1, 0x0, 1);
				graphics.drawCircle(model.debugPoints[k].x * SIZE, model.debugPoints[k].y * SIZE, 1);
				graphics.moveTo(SIZE * model.debugPoints[k].x, SIZE * model.debugPoints[k].y); 
				graphics.lineTo(SIZE * model.debugPoints2[k].x, SIZE * model.debugPoints2[k].y); 
			}
			var m:int;
			
			for (k = 0; k < model.nodes.length; k++) 
			{
				graphics.lineStyle(3, 0xaaaa00, 1);
				graphics.beginFill(0xaaaa00, 0);
				graphics.drawCircle(SIZE * model.nodes[k].point.x, SIZE * model.nodes[k].point.y, 1); 
				graphics.endFill();
				
				for (m = 0; m < model.nodes[k].links.length; m++) 
				{
					graphics.lineStyle(2, 0xff5533, 1);
					graphics.moveTo(SIZE * (model.nodes[k].cell.x + 0.5), 
									SIZE * (model.nodes[k].cell.y + 0.5));
					graphics.lineTo(SIZE * (model.nodes[k].links[m].cell.x + 0.5), 
									SIZE * (model.nodes[k].links[m].cell.y + 0.5));
					
				}
			}*/
			/*
			for (m = 0; m < model.debugEdges.length; m++) 
			{
				graphics.lineStyle(1, 0x0, 0.5);
				graphics.moveTo(SIZE * (model.debugEdges[m].p1.x), 
								SIZE * (model.debugEdges[m].p1.y));
				graphics.lineTo(SIZE * (model.debugEdges[m].p2.x), 
								SIZE * (model.debugEdges[m].p2.y));
				//trace(model.debugEdges[m].p1.x.toFixed(1), model.debugEdges[m].p1.y.toFixed(1), model.debugEdges[m].p2.x.toFixed(1), model.debugEdges[m].p2.y.toFixed(1));
				
			}*/
			/*
			graphics.lineStyle(4, 0xff5555, 1);
			graphics.drawCircle(model.from.x * SIZE, model.from.y * SIZE, 2);
			graphics.lineStyle(4, 0x990000, 1);
			graphics.drawCircle(model.to.x * SIZE, model.to.y * SIZE, 1);*/
			/*
			if (model.path)
			{
				for (var l:int = 1; l < model.path.length; l++) 
				{
					graphics.lineStyle(1, 0xdddd00, 1);
					graphics.moveTo(model.path[l - 1].x * SIZE, model.path[l - 1].y * SIZE);
					graphics.lineTo(model.path[l].x * SIZE, model.path[l].y * SIZE);
					if (l < model.path.length - 1)
					{
						graphics.lineStyle(3, 0xdddd00, 1);
						graphics.drawCircle(model.path[l].x * SIZE, model.path[l].y * SIZE, 1);
					}
				}
			}*/
		}
	
		private function isWithinFrontier(cell:CellData):Boolean
		{
			for (var i:int = 0; i < model.nodes.length; i++) 
			{
				if (model.nodes[i].frontier && model.nodes[i].frontier.indexOf(cell) != -1)
					return true;
			}
			return false;
		}
		
	}

}