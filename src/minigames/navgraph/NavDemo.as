package minigames.navgraph 
{
	import flash.geom.Point;
	import flash.utils.getTimer;
	import util.HMath;
	
	public class NavDemo 
	{
		public static var nodeCount:int;
		public static var pathCount:int;
		public static var frameCount:int;
		public static var targetNodeCount:int = 2*30 * 150 * 10;
		public static var targetPathCount:int = 2*33 * 150;
		public static var targetframeCount:int = 2*40 * 25;
		
		public var creepoozles:Vector.<Creepoozle>;
		private var space:NavSpace;
		private var view:NavDemoView;
		private var started:Boolean;
		private var startTime:int;
		
		
		public function NavDemo(space:NavSpace, view:NavDemoView) 
		{
			this.view = view;
			this.space = space;
			var numCreepoozles:int = 300;
			var numTargets:int = 150;
			
			creepoozles = new Vector.<Creepoozle>()
			for (var i:int = 0; i < numCreepoozles; i++) 
			{
				var targets:Vector.<Point> = new Vector.<Point>();
				for (var j:int = 0; j < numTargets; j++) 
				{
					var target:Point = null;
					while (!target || isBadTarget(target))
						target = new Point(NavSpace.SIZE_X * Math.random(), NavSpace.SIZE_Y * Math.random());
					targets.push(target);
				}
				
				var creep:Creepoozle = new Creepoozle(targets, space.pathFinder);
				creepoozles.push(creep);
			}
		}
		
		public function onFrame(timePassed:int):void 
		{
			if (!started)
				start();
			frameCount++;
			for (var i:int = 0; i < creepoozles.length; i++) 
			{
				creepoozles[i].update(timePassed);
			}
			if (nodeCount >= targetNodeCount)
			{
				targetNodeCount = int.MAX_VALUE;
				trace("NODE OBJECTIVE COMPLETE IN", getTimer() - startTime);
			}
			if (pathCount >= targetPathCount)
			{
				targetPathCount = int.MAX_VALUE;
				trace("PATH OBJECTIVE COMPLETE IN", getTimer() - startTime);
			}
			if (frameCount >= targetframeCount)
			{
				targetframeCount = int.MAX_VALUE;
				trace("FRAME OBJECTIVE COMPLETE IN", getTimer() - startTime);
			}
			if (frameCount == 4000)
			{
				var countPaths:int = 0;
				var valuePaths:Number = 0;
				var countNodes:int = 0;
				var nodesPerPath:Number = 0;
				var lengthPerPath:Number = 0;
				var stdPathLength:Number = 0;
				var stdNodesPerPath:Number = 0;
				var badPaths:int = 0;
				for (var j:int = 0; j < creepoozles.length; j++) 
				{
					countPaths += creepoozles[j].pathLengths.length;
					for (var k:int = 0; k < creepoozles[j].pathLengths.length; k++) 
					{
						valuePaths+= creepoozles[j].pathLengths[k];
					}
					badPaths += creepoozles[j].badPaths;
					
					for (k = 0; k < creepoozles[j].nodeCounts.length; k++) 
					{
						countNodes+=creepoozles[j].nodeCounts[k];
					}
				}
				nodesPerPath = countNodes / countPaths;
				lengthPerPath = valuePaths / countPaths;
				
				for (j = 0; j < creepoozles.length; j++) 
				{
					for (k = 0; k < creepoozles[j].pathLengths.length; k++) 
					{
						stdPathLength += Math.pow((lengthPerPath - creepoozles[j].pathLengths[k]), 2);						
					}
					for (k = 0; k < creepoozles[j].nodeCounts.length; k++) 
					{
						stdNodesPerPath += Math.pow((nodesPerPath - creepoozles[j].nodeCounts[k]), 2);						
					}
				}
				stdPathLength = Math.sqrt(stdPathLength / countPaths);
				stdNodesPerPath = Math.sqrt(stdNodesPerPath / countPaths);	
				
				var avgEdges:Number = 0;
				for (k = 0; k < space.edgesOnChecks.length; k++) 
				{
					avgEdges += space.edgesOnChecks[k];						
				}
				avgEdges /= space.edgesOnChecks.length;
				
				trace("paths:", countPaths, "avg path length:", lengthPerPath.toFixed(1), "+-", stdPathLength.toFixed(2));
				trace("nodes:", countNodes, "avgNodes:", nodesPerPath.toFixed(1), "+-", stdNodesPerPath.toFixed(2));
				if (badPaths > 0)
					trace("bads:", badPaths);
				trace("avg edges on visibility checks:", avgEdges.toFixed(1), "totalChecks", space.edgesOnChecks.length);
			}
		}
		
		public function refreshPaths():void 
		{
			for (var i:int = 0; i < creepoozles.length; i++) 
			{
				creepoozles[i].refreshPath();
			}
		}
		
		private function start():void 
		{
			trace("DEMO STARTED", getTimer(), "nodes:", targetNodeCount, "paths:", targetPathCount, "frames:", targetframeCount, "creeps:", creepoozles.length);
			started = true;
			startTime = getTimer();
			
		}
		
		private function isBadTarget(target:Point):Boolean 
		{
			if (space.cellMatrix[int(target.y)][int(target.x)].isObstacle)
				return true;
			var relevantEdges:Array = space.edgeQuadTree.query(new Point(target.x - NavSpace.UNIT_SIZE, target.y - NavSpace.UNIT_SIZE), new Point(target.x + NavSpace.UNIT_SIZE, target.y + NavSpace.UNIT_SIZE));
			for (var i:int = 0; i < relevantEdges.length; i++) 
			{
				if (HMath.distanceFromPointToSegment(target.x, target.y, 
						relevantEdges[i].p1.x, relevantEdges[i].p1.y, relevantEdges[i].p2.x, relevantEdges[i].p2.y) < NavSpace.UNIT_SIZE)
					return true;
			}
			return false;
		}
	}

}