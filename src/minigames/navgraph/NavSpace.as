package minigames.navgraph
{
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import minigames.navgraph.Edge;
	
	public class NavSpace extends EventDispatcher
	{
		public var checkedCells:Vector.<CellData>;
		public static const SIZE_X:int = 40;
		public static const SIZE_Y:int = 30;
		public static const UNIT_SIZE:Number = 0.4;
		
		public var cellMatrix:Vector.<Vector.<CellData>>;
		public var cells:Vector.<CellData>;
		public var meshes:Vector.<Mesh>;
		public var edges:Vector.<Edge>;
		public var nodes:Vector.<NavNode>;
		public var debugEdges:Vector.<Edge>;
		public var debugPoints:Vector.<Point>;
		public var debugPoints2:Vector.<Point>;
		public var pathFinder:PathFinder;
		public var path:Array;
		public var from:Point;
		public var to:Point;
		public var edgeQuadTree:QuadNode;
		public var edgesOnChecks:Vector.<int>;
		;
		public var color:uint;
		
		public function NavSpace()
		{
			restart();
		/*
		   var cell1:CellData = new CellData();
		   cell1.x = 10;
		   cell1.y = 2;
		
		
		   var cell2:CellData = new CellData();
		   cell2.x = 10;
		   cell2.y = 12;
		
		 isNodeVisible(new NavNode(cell1), new NavNode(cell2), UNIT_SIZE);*/
		}
		
		public function restart():void
		{
			cellMatrix = new Vector.<Vector.<CellData>>();
			cells = new Vector.<CellData>();
			edges = new Vector.<Edge>();
			for (var i:int = 0; i < SIZE_Y; i++)
			{
				cellMatrix.push(new Vector.<CellData>());
				for (var j:int = 0; j < SIZE_X; j++)
				{
					var cell:CellData = new CellData();
					cell.x = j;
					cell.y = i;
					cell.isObstacle = i == 0 || i == SIZE_Y - 1 || j == 0 || j == SIZE_X - 1;
					cellMatrix[i].push(cell);
					cells.push(cell);
				}
			}
			
			var numObstacles:int = 0;
			for (var l:int = 0; l < numObstacles; l++)
			{
				cell = null;
				while (!cell || cellMatrix[cell.y][cell.x].isObstacle)
					cell = cellMatrix[int(Math.random() * SIZE_Y)][int(Math.random() * SIZE_X)];
				edges.push(new Edge(new Point(cell.x, cell.y), new Point(cell.x + 1, cell.y)));
				edges.push(new Edge(new Point(cell.x + 1, cell.y), new Point(cell.x + 1, cell.y + 1)));
				edges.push(new Edge(new Point(cell.x + 1, cell.y + 1), new Point(cell.x, cell.y + 1)));
				edges.push(new Edge(new Point(cell.x, cell.y + 1), new Point(cell.x, cell.y)));
				cell.isObstacle = true;
				
			}
			/*
			   var obstacleCells:Vector.<CellData> = new <CellData>[cellMatrix[3][3], cellMatrix[2][2],
			   cellMatrix[2][7]];
			   for (var k:int = 0; k < obstacleCells.length; k++)
			   {
			   cell = obstacleCells[k];
			   cell.isObstacle = true;
			 }*/
			while (!cell || cell.isObstacle)
				cell = cells[int(Math.random() * cells.length)];
			to = new Point(cell.x + Math.random(), cell.y + Math.random());
			
			cell = null;
			while (!cell || cell.isObstacle)
				cell = cells[int(Math.random() * cells.length)];
			from = new Point(cell.x + Math.random(), cell.y + Math.random());
			
			pathFinder = new PathFinder(this);
			refresh();
		}
		
		public function addObstacle(x:int, y:int):void
		{
			cellMatrix[y][x].isObstacle = true;
			
			refresh();
		}
		
		public function removeObstacle(x:int, y:int):void
		{
			cellMatrix[y][x].isObstacle = false;
			
			refresh();
		}
		
		public function toggleObstacle(x:int, y:int):void
		{
			cellMatrix[y][x].isObstacle = !cellMatrix[y][x].isObstacle;
			
			refresh();
		}
		
		public function linkNodes():void
		{
			for (var i:int = 0; i < nodes.length; i++)
			{
				for (var j:int = i + 1; j < nodes.length; j++)
				{
					if (isDirectlyVisible(nodes[i].point, nodes[j].point, UNIT_SIZE))
					{
						nodes[i].addLink(nodes[j]);
						nodes[j].addLink(nodes[i]);
					}
				}
			}
		}
		
		private function refresh():void
		{
			//trace("refresh-------------------------------------------------");
			var time:int = getTimer();
			clearCells();
			//trace("clearCells", getTimer() - time);
			
			time = getTimer();
			createEdges();
			//trace("createEdges", getTimer() - time);
			
			trace("num  edges", edges.length);
			
			time = getTimer();
			createMeshes();
			//trace("createMeshes", getTimer() - time);
			
			time = getTimer();
			createNodes();
			//trace("createNodes", getTimer() - time);
			
			time = getTimer();
			floodFill();
			//trace("flood fill", getTimer() - time);
			
			time = getTimer();
			linkNodes();
			trace("linkNodes", getTimer() - time);
			//debugEdges = new Vector.<Edge>();
			edgesOnChecks = new Vector.<int>();
			edgeQuadTree.traceStats();
		/*
		   time = getTimer();
		   pathFinder = new PathFinder(this);
		 path = pathFinder.getPath(from, to);*/
			 //trace("path actual length", getPathLength(path));
			 //trace("pathFind", getTimer() - time);
		}
		
		public static function getPathLength(path:Array):Number
		{
			var length:Number = 0;
			for (var i:int = 1; path && i < path.length; i++)
			{
				length += Math.sqrt((path[i - 1].x - path[i].x) * (path[i - 1].x - path[i].x) + (path[i - 1].y - path[i].y) * (path[i - 1].y - path[i].y));
			}
			return length;
		}
		
		private function clearCells(withObstacles:Boolean = false):void
		{
			for (var i:int = 0; i < cells.length; i++)
			{
				cells[i].node = null;
				cells[i].nearestNodes = new Vector.<NavNode>();
				cells[i].mesh = null;
				cells[i].meshes = new Vector.<Mesh>();
				if (withObstacles)
					cells[i].isObstacle = false;
			}
		}
		
		public function floodFill():void
		{
			var hasFrontier:Boolean = nodes.length > 0;
			for (var i:int = 0; i < nodes.length; i++)
			{
				nodes[i].frontier = new Vector.<CellData>();
				nodes[i].frontier.push(nodes[i].cell);
				nodes[i].cell.nearestNodes.push(nodes[i]);
				nodes[i].cell.nearestPathElements.push(new Vector.<PathElement>());
			}
			while (hasFrontier)
			{
				hasFrontier = expand();
			}
		}
		
		public function expand():Boolean
		{
			var i:int;
			var hasFrontier:Boolean = false;
			for (i = 0; i < nodes.length; i++)
			{
				if (nodes[i].frontier)
				{
					hasFrontier = true;
					var newFrontier:Vector.<CellData> = new Vector.<CellData>();
					for (var j:int = 0; j < nodes[i].frontier.length; j++)
					{
						var cell:CellData = nodes[i].frontier[j];
						var expansionBanned:Boolean = cell.nearestNodes.length > 1;
						var neighbours:Vector.<CellData> = new <CellData>[cellMatrix[cell.y + 1][cell.x], cellMatrix[cell.y - 1][cell.x], cellMatrix[cell.y][cell.x + 1], cellMatrix[cell.y][cell.x - 1]];
						for (var k:int = 0; k < neighbours.length; k++)
						{
							if (neighbours[k].isObstacle || neighbours[k].nearestNodes.indexOf(nodes[i]) != -1 || neighbours[k].node)
								continue;
							neighbours[k].nearestNodes.push(nodes[i]);
							neighbours[k].nearestPathElements.push(new Vector.<PathElement>());
							if (neighbours[k].nearestNodes.length == 1 && newFrontier.indexOf(neighbours[k]) == -1)
								newFrontier.push(neighbours[k]);
						}
					}
					nodes[i].frontier = newFrontier.length > 0 ? newFrontier : null;
				}
			}
			return hasFrontier;
		}
		
		private function createEdges():void
		{
			edges = new Vector.<Edge>();
			edgeQuadTree = new QuadNode(0, 3, 0, 0, SIZE_X, SIZE_Y);
			for (var i:int = 0; i < cellMatrix.length - 1; i++)
			{
				var edgeStarted:Boolean = false;
				for (var j:int = 0; j < cellMatrix[i].length; j++)
				{
					if (cellMatrix[i][j].isObstacle != cellMatrix[i + 1][j].isObstacle)
					{
						if (edgeStarted)
						{
							edge.p2.x = cellMatrix[i][j].x + 1;
						}
						else
						{
							edgeStarted = true;
							var edge:Edge = new Edge(new Point(cellMatrix[i][j].x, cellMatrix[i][j].y + 1), new Point(cellMatrix[i][j].x + 1, cellMatrix[i][j].y + 1));
						}
					}
					else
					{
						if (edgeStarted)
						{
							edgeStarted = false;
							edge.updateLength();
							edges.push(edge);
						}
					}
				}
				if (edgeStarted)
				{
					edgeStarted = false;
					edge.updateLength();
					edges.push(edge);
				}
			}
			
			for (j = 0; j < SIZE_X - 1; j++)
			{
				edgeStarted = false;
				for (i = 0; i < SIZE_Y; i++)
				{
					if (cellMatrix[i][j].isObstacle != cellMatrix[i][j + 1].isObstacle)
					{
						if (edgeStarted)
						{
							edge.p2.y = cellMatrix[i][j].y + 1;
						}
						else
						{
							edgeStarted = true;
							edge = new Edge(new Point(cellMatrix[i][j].x + 1, cellMatrix[i][j].y), new Point(cellMatrix[i][j].x + 1, cellMatrix[i][j].y + 1));
						}
					}
					else
					{
						if (edgeStarted)
						{
							edgeStarted = false;
							edge.updateLength();
							edges.push(edge);
						}
					}
				}
				if (edgeStarted)
				{
					edgeStarted = false;
					edge.updateLength();
					edges.push(edge);
				}
			}
			
			for (var k:int = 0; k < edges.length; k++)
			{
				edgeQuadTree.push(edges[k]);
			}
		
		/*
		   for (var i:int = 0; i < cells.length; i++)
		   {
		   if (cells[i].isObstacle)
		   {
		   if (cells[i].y > 0 && !cellMatrix[cells[i].y - 1][cells[i].x].isObstacle)
		   edges.push(new Edge(new Point(cells[i].x, cells[i].y), new Point(cells[i].x + 1, cells[i].y)));
		   if (cells[i].x < SIZE_X - 1 && !cellMatrix[cells[i].y][cells[i].x + 1].isObstacle)
		   edges.push(new Edge(new Point(cells[i].x+1, cells[i].y), new Point(cells[i].x+1, cells[i].y+1)));
		   if (cells[i].y < SIZE_Y - 1 && !cellMatrix[cells[i].y + 1][cells[i].x].isObstacle)
		   edges.push(new Edge(new Point(cells[i].x + 1, cells[i].y + 1), new Point(cells[i].x, cells[i].y + 1)));
		   if (cells[i].x > 0 && !cellMatrix[cells[i].y][cells[i].x - 1].isObstacle)
		   edges.push(new Edge(new Point(cells[i].x, cells[i].y+1), new Point(cells[i].x, cells[i].y)));
		   }
		 }*/
		}
		
		private function createNodes():void
		{
			nodes = new Vector.<NavNode>();
			debugEdges = new Vector.<Edge>();
			
			for (var i:int = 0; i < SIZE_Y; i++)
			{
				for (var j:int = 0; j < SIZE_X; j++)
				{
					if (isCorner(i, j))
					{
						var node:NavNode = new NavNode(cellMatrix[i][j]);
						nodes.push(node);
						cellMatrix[i][j].node = node;
					}
				}
			}
		}
		
		private function isCorner(y:int, x:int):Boolean
		{
			if (!cellMatrix[y][x].isObstacle)
			{
				if (!cellMatrix[y - 1][x].isObstacle)
				{
					if (!cellMatrix[y][x - 1].isObstacle && cellMatrix[y - 1][x - 1].isObstacle)
						return true;
					if (!cellMatrix[y][x + 1].isObstacle && cellMatrix[y - 1][x + 1].isObstacle)
						return true;
				}
				if (!cellMatrix[y + 1][x].isObstacle)
				{
					if (!cellMatrix[y][x - 1].isObstacle && cellMatrix[y + 1][x - 1].isObstacle)
						return true;
					if (!cellMatrix[y][x + 1].isObstacle && cellMatrix[y + 1][x + 1].isObstacle)
						return true;
				} /**/
			}
			return false;
		}
		
		private function createMeshes():void
		{
			meshes = new Vector.<Mesh>();
			
			var numRandom:int = 150;
			for (var k:int = 0; k < numRandom; k++)
			{
				var randomCell:CellData = cells[int(Math.random() * cells.length)];
				if (!randomCell.isObstacle && !randomCell.mesh)
					createMesh(randomCell.x, randomCell.y);
			}
			
			for (var i:int = 0; i < SIZE_Y; i++)
			{
				for (var j:int = 0; j < SIZE_X; j++)
				{
					if (!cellMatrix[i][j].isObstacle && cellMatrix[i][j].mesh == null)
						createMesh(j, i);
				}
			}
			
			for each (var mesh:Mesh in meshes)
			{
				for (var m:int = 0; m < mesh.width; m++)
				{
					var cell:CellData = cellMatrix[mesh.y - 1][mesh.x + m];
					if (cell.mesh && mesh.linkage.indexOf(cell.mesh) == -1)
						mesh.linkage.push(cell.mesh);
					
					cell = cellMatrix[mesh.y + mesh.height][mesh.x + m];
					if (cell.mesh && mesh.linkage.indexOf(cell.mesh) == -1)
						mesh.linkage.push(cell.mesh);
				}
				for (m = 0; m <= mesh.height; m++)
				{
					cell = cellMatrix[mesh.y + m][mesh.x - 1];
					if (cell.mesh && mesh.linkage.indexOf(cell.mesh) == -1)
						mesh.linkage.push(cell.mesh);
					
					cell = cellMatrix[mesh.y + m][mesh.x + mesh.width];
					if (cell.mesh && mesh.linkage.indexOf(cell.mesh) == -1)
						mesh.linkage.push(cell.mesh);
				}
			}
		}
		
		private function createMesh(x:int, y:int):void
		{
			var mesh:Mesh = new Mesh(x, y, 1, 1);
			cellMatrix[y][x].mesh = mesh;
			meshes.push(mesh);
			var top:Boolean = true;
			var bot:Boolean = true;
			var left:Boolean = true;
			var right:Boolean = true;
			var i:int;
			
			while (top || bot || left || right)
			{
				if (top)
				{
					for (i = 0; i < mesh.width; i++)
					{
						if (cellMatrix[mesh.y - 1][mesh.x + i].mesh || cellMatrix[mesh.y - 1][mesh.x + i].isObstacle)
						{
							top = false;
							break;
						}
						
					}
					if (top)
					{
						mesh.y--;
						mesh.height++;
						for (i = 0; i < mesh.width; i++)
						{
							cellMatrix[mesh.y][mesh.x + i].mesh = mesh;
						}
					}
				}
				if (right)
				{
					for (i = 0; i < mesh.height; i++)
					{
						if (cellMatrix[mesh.y + i][mesh.x + mesh.width].mesh || cellMatrix[mesh.y + i][mesh.x + mesh.width].isObstacle)
						{
							right = false;
							break;
						}
						
					}
					if (right)
					{
						mesh.width++;
						for (i = 0; i < mesh.height; i++)
						{
							cellMatrix[mesh.y + i][mesh.x + mesh.width - 1].mesh = mesh;
						}
					}
				}
				if (bot)
				{
					for (i = 0; i < mesh.width; i++)
					{
						if (cellMatrix[mesh.y + mesh.height][mesh.x + i].mesh || cellMatrix[mesh.y + mesh.height][mesh.x + i].isObstacle)
						{
							bot = false;
							break;
						}
						
					}
					if (bot)
					{
						mesh.height++;
						for (i = 0; i < mesh.width; i++)
						{
							cellMatrix[mesh.y + mesh.height - 1][mesh.x + i].mesh = mesh;
						}
					}
				}
				if (left)
				{
					for (i = 0; i < mesh.height; i++)
					{
						if (cellMatrix[mesh.y + i][mesh.x - 1].mesh || cellMatrix[mesh.y + i][mesh.x - 1].isObstacle)
						{
							left = false;
							break;
						}
						
					}
					if (left)
					{
						mesh.x--;
						mesh.width++;
						for (i = 0; i < mesh.height; i++)
						{
							cellMatrix[mesh.y + i][mesh.x].mesh = mesh;
						}
					}
				}
			}
		}
		
		public function isDirectlyVisible(point1:Point, point2:Point, width:Number):Boolean
		{
			var angle:Number = Math.atan2(point2.y - point1.y, point2.x - point1.x);
			var perpAngle1:Number = angle + Math.PI / 2;
			var perpAngle2:Number = angle - Math.PI / 2;
			
			var p11:Point = new Point(point1.x + Math.cos(perpAngle1) * width, point1.y + Math.sin(perpAngle1) * width);
			var p12:Point = new Point(point1.x + Math.cos(perpAngle2) * width, point1.y + Math.sin(perpAngle2) * width);
			var p21:Point = new Point(point2.x + Math.cos(perpAngle1) * width, point2.y + Math.sin(perpAngle1) * width);
			var p22:Point = new Point(point2.x + Math.cos(perpAngle2) * width, point2.y + Math.sin(perpAngle2) * width);
			
			debugEdges.push(new Edge(p11, p21));
			debugEdges.push(new Edge(p12, p22));
			
			checkedCells = new Vector.<CellData>();
			debugPoints = new Vector.<Point>();
			debugPoints2 = new Vector.<Point>();
			return !DDAVisible(p11, p21) && !DDAVisible(p12, p22);
		/*
		   var queryPoint1:Point = new Point(Math.min(Math.min(p11.x, p12.x), Math.min(p21.x, p22.x)),
		   Math.min(Math.min(p11.y, p12.y), Math.min(p21.y, p22.y)));
		   var queryPoint2:Point = new Point(Math.max(Math.min(p11.x, p12.x), Math.max(p21.x, p22.x)),
		   Math.max(Math.min(p11.y, p12.y), Math.max(p21.y, p22.y)));
		
		   var edgeArray:Array = edgeQuadTree.query(queryPoint1, queryPoint2);
		 return !intersectsEdges(p11, p21, edgeArray) && !intersectsEdges(p12, p22, edgeArray);	*/
		}
		
		private function DDAVisible(p1:Point, p2:Point):Boolean
		{
			var dx:Number = Math.abs(p2.x - p1.x);
			var dy:Number = Math.abs(p2.y - p1.y);
			var xStep:Number = (p1.x < p2.x ? +1 : -1);
			var yStep:Number = (p1.y < p2.y ? +1 : -1);
			var lastCellX:int = p1.x;
			var lastCellY:int = p1.y;
			
			if (dx > dy)
			{
				var shift:int = (xStep > 0 ? 1 : 0);
				var iter:int = lastCellX + shift;
				var slope:Number = (p2.y - p1.y) / (p2.x - p1.x);
				var elevation:Number = p1.y - p1.x * slope;
				var numChecks:int = Math.abs(int(p1.x) - int(p2.x));
				for (var i:int = 0; i <= numChecks; i++) 
				{
					var thisY:int = slope * iter + elevation;
					if (i < numChecks)
					{
						//debugPoints.push(new Point(iter, thisY));
						//checkedCells.push(cellMatrix[int(thisY)][int(iter - shift)]);
						//debugPoints2.push(new Point(checkedCells[checkedCells.length -1].x + 0.5, checkedCells[checkedCells.length -1].y + 0.5));
						if (cellMatrix[thisY][iter - shift].isObstacle)
							return true;
					}					
					if (lastCellY != thisY)
					{
						//checkedCells.push(cellMatrix[lastCellY][int(iter - shift)]);
						//checkedCells.push(cellMatrix[lastCellY][int(iter - shift)]);
						if (cellMatrix[lastCellY][iter - shift].isObstacle)
							return true;
						lastCellY = thisY;
					}
					iter += xStep;
				}
			}
			else
			{
				shift = (yStep > 0 ? 1 : 0);
				iter = lastCellY + shift;
				slope = (p2.x - p1.x) / (p2.y - p1.y);
				elevation = p1.x - p1.y * slope;
				numChecks = Math.abs(int(p1.y) - int(p2.y));
				for (i = 0; i <= numChecks; i++) 
				{
					var thisX:int = slope * iter + elevation;
					if (i < numChecks)
					{
						//debugPoints.push(new Point(thisX, iter));
						//checkedCells.push(cellMatrix[int(iter - shift)][int(thisX)]);
						//debugPoints2.push(new Point(checkedCells[checkedCells.length -1].x + 0.5, checkedCells[checkedCells.length -1].y + 0.5));
						if (cellMatrix[iter - shift][thisX].isObstacle)
							return true;
					}					
					if (lastCellX != thisX)
					{
						//checkedCells.push(cellMatrix[int(iter - shift)][lastCellX]);
						//checkedCells.push(cellMatrix[int(iter - shift)][lastCellX]);
						if (cellMatrix[iter - shift][lastCellX].isObstacle)
							return true;
						lastCellX = thisX;
					}	
					iter += yStep;
				}
			}
			return false;
		}
		
		private var traceEnabled:Boolean;/*
		private function collidesByFloatingBresenham(p1:Point, p2:Point):Boolean
		{
			var dx:Number = Math.abs(p2.x - p1.x);
			var dy:Number = Math.abs(p2.y - p1.y);
			var xCeil:Number = Math.abs(int(p1.x) + (p1.x < p2.x ? 1 : 0) - p1.x);
			var yCeil:Number = Math.abs(int(p1.x) + (p1.y < p2.y ? 1 : 0) - p1.y);
			
			var intx:int = p1.x;
			var inty:int = p1.y;
			var targetX:int = p2.x;
			var targetY:int = p2.y;
			var x:Number = p1.x;
			var y:Number = p1.y;
			
			while (intx != targetX || inty != targetY)
			{
				checkedCells.push(cellMatrix[inty][intx]);
				if (cellMatrix[inty][intx].isObstacle)
					return true;
				if (dx / xCeil > dy / yCeil)
				{
					if (traceEnabled)
					trace("X*", "dx, xceil:", dx.toFixed(2), xCeil.toFixed(2), (dx / xCeil).toFixed(2), ">",
								"dy, yceil:", dy.toFixed(2), yCeil.toFixed(2), (dy / yCeil).toFixed(2));
					dx -= Math.abs(xStep);
					x += xStep;
					intx = x;
				}
				else
				{
					if (traceEnabled)
					trace("Y*", "dx, xceil:", dx.toFixed(2), xCeil.toFixed(2), (dx / xCeil).toFixed(2), "<",
								"dy, yceil:", dy.toFixed(2), yCeil.toFixed(2), (dy / yCeil).toFixed(2));
					dy -= Math.abs(yStep);
					y += yStep;
					inty = y;
				}
			}
			return false;
		}*/
		
		/*
		private function thickCollides(int x0, int y0, int x1, int y1, float wd)
		{ 
		   int dx = abs(x1-x0), sx = x0 < x1 ? 1 : -1; 
		   int dy = abs(y1-y0), sy = y0 < y1 ? 1 : -1; 
		   int err = dx-dy, e2, x2, y2;                         
		   float ed = dx+dy == 0 ? 1 : sqrt((float)dx*dx+(float)dy*dy);
		   
		   for (wd = (wd+1)/2; ; ) {                                   
			  setPixelColor(x0,y0,max(0,255*(abs(err-dx+dy)/ed-wd+1));
			  e2 = err; x2 = x0;
			  if (2*e2 >= -dx) {                                           
				 for (e2 += dy, y2 = y0; e2 < ed*wd && (y1 != y2 || dx > dy); e2 += dx)
					setPixelColor(x0, y2 += sy, max(0,255*(abs(e2)/ed-wd+1));
				 if (x0 == x1) break;
				 e2 = err; err -= dy; x0 += sx; 
			  } 
			  if (2*e2 <= dy) {                                            
				 for (e2 = dx-e2; e2 < ed*wd && (x1 != x2 || dx < dy); e2 += dy)
					setPixelColor(x2 += sx, y0, max(0,255*(abs(e2)/ed-wd+1));
				 if (y0 == y1) break;
				 err += dx; y0 += sy; 
			  }
		   }
		}*/
		
		private function DDACollides(p1:Point, p2:Point):Boolean
		{
			var i:int
			var n:int;
			
			var a:Number;
			var a0:Number;
			var a1:Number;
			var aa:Number;
			var b:Number;
			var d:Number;
			var x0:Number = p1.x;
			var x1:Number = p2.x;
			var y0:Number = p1.y;
			var y1:Number = p2.y;
			
			// end-points
			//pnt(x0,y0,col);
			//pnt(x1,y1,col);
			// x-axis pixel cross
			a0 = 1;
			a1 = 0;
			n = 0;
			
			if (x0 < x1)
			{
				a0 = Math.ceil(x0);
				a1 = Math.floor(x1);
				d = (y1 - y0) / (x1 - x0);
				a = a0;
				b = y0 + (a0 - x0) * d;
				n = Math.abs(a1 - a0);
			}
			else if (x0 > x1)
			{
				a0 = Math.ceil(x1);
				a1 = Math.floor(x0);
				d = (y1 - y0) / (x1 - x0);
				a = a0;
				b = y1 + (a0 - x1) * d;
				n = Math.abs(a1 - a0);
			}
			if (a0 <= a1)
			{
				aa = a;	
				for (i = 0; i <= n; i++)
				{
					checkedCells.push(cellMatrix[int(b)][int(aa)]);
					if (cellMatrix[int(b)][int(aa)].isObstacle)
						return true;
					checkedCells.push(cellMatrix[int(b)][int(a)]);
					if (cellMatrix[int(b)][int(a)].isObstacle)
						return true;
					aa = a; 
					a++; 
					b += d;
				}
			}
			// y-axis pixel cross
			
			a0 = 1;
			a1 = 0;
			n = 0;
			
			if (y0 < y1)
			{
				a0 = Math.ceil(y0);
				a1 = Math.floor(y1);
				d = (x1 - x0) / (y1 - y0);
				a = a0;
				b = x0 + (a0 - y0) * d;
				n = Math.abs(a1 - a0);
			}
			else if (y0 > y1)
			{
				a0 = Math.ceil(y1);
				a1 = Math.floor(y0);
				d = (x1 - x0) / (y1 - y0);
				a = a0;
				b = x1 + (a0 - y1) * d;
				n = Math.abs(a1 - a0);
			}
			if (a0 <= a1)
			{		
				aa = a;
				for (i = 0; i <= n; i++)
				{
					
					checkedCells.push(cellMatrix[int(b)][int(aa)]);
					if (cellMatrix[int(aa)][int(b)].isObstacle)
						return true;
					checkedCells.push(cellMatrix[int(b)][int(a)]);
					if (cellMatrix[int(a)][int(b)].isObstacle)
						return true;
					aa = a;
					a++;
					b += d;
				}
			}
			return false;
		}
		
		private function brazCollides(p1:Point, p2:Point):Boolean
		{
			
			var xDist:Number = Math.abs(p2.x - p1.x);
			var yDist:Number = -Math.abs(p2.y - p1.y);
			var xStep:Number = (p1.x < p2.x ? +1 : -1);
			var yStep:Number = (p1.y < p2.y ? +1 : -1);
			var error:Number = xDist + yDist;
			
			var x:Number = p1.x;
			var y:Number = p1.y;
			var tx:int = p2.x;
			var ty:int = p2.y;
			var rx:int = p1.x;
			var ry:int = p1.y;
			
			checkedCells.push(cellMatrix[ry][rx]);
			if (cellMatrix[ry][rx].isObstacle)
				return true;
			
			while (rx != tx || ry != ty)
			{
				if (2 * error - yDist > xDist - 2 * error)
				{
					error += yDist;
					x += xStep;
					rx = x;
				}
				else
				{
					error += xDist;
					y += yStep;
					ry = y;
					
				}
				checkedCells.push(cellMatrix[ry][rx]);
				if (cellMatrix[ry][rx].isObstacle)
					return true;
			}
			checkedCells.push(cellMatrix[ry][rx]);
			checkedCells.push(cellMatrix[ry][rx]);
			return false;
		}
		
		public function saveToString():String
		{
			var obj:Object = new Object();
			var obstacles:Vector.<Object> = new Vector.<Object>();
			for (var i:int = 0; i < cells.length; i++)
			{
				if (cells[i].isObstacle)
				{
					obstacles.push({x: cells[i].x, y: cells[i].y});
				}
			}
			obj.obsctacles = obstacles;
			obj.from = {x: from.x, y: from.y};
			obj.to = {x: to.x, y: to.y};
			return JSON.stringify(obj);
		}
		
		public function loadFromString(source:String):void
		{
			clearCells(true);
			var obj:Object = JSON.parse(source);
			from = new Point(obj.from.x, obj.from.y);
			to = new Point(obj.to.x, obj.to.y);
			
			for (var i:int = 0; i < obj.obsctacles.length; i++)
			{
				cellMatrix[obj.obsctacles[i].y][obj.obsctacles[i].x].isObstacle = true;
			}
			refresh();
			traceEnabled = true;
		}
		
		private function intersectsEdges(p1:Point, p2:Point, list:Array):Boolean
		{
			edgesOnChecks.push(list.length);
			var edge:Edge = new Edge(p1, p2);
			for (var i:int = 0; i < list.length; i++)
			{
				if (edge.intersects(list[i]))
					return true;
			}
			return false;
		}
	}
}