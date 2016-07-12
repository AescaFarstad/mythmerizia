package minigames.quad 
{
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getDefinitionByName;
	import util.Arrow;
	import util.HMath;
	
	public class QuadView extends Sprite
	{
		public var model:QuadModel;
		
		private var quads:Vector.<SingleQuadView> = new Vector.<SingleQuadView>();
		private var arrowSprite:Sprite = new Sprite();
		private var inputAllowed:Boolean = true;
		
		private var tf:TextField;
		
		public function QuadView()
		{
			super();
			
			graphics.beginFill(0, 0.0);
			graphics.drawCircle(0, 0, SingleQuadView.SIZE * 5);
			graphics.endFill();
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			arrowSprite = new Sprite();
			addChild(arrowSprite);
			
			tf = new TextField();
			tf.autoSize = TextFieldAutoSize.LEFT;
			addChild(tf);
			tf.scaleX = 0.55;
			tf.scaleY = 0.55;
			tf.alpha = 0.4;
			tf.y = 242;
			tf.x = -250;
			tf.text = "--";
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			if (!inputAllowed)
				return;
			//trace(e.localX);
			var p:Point = globalToLocal(new Point(e.stageX, e.stageY));
			var nearestQuad:SingleQuadView = findNearestQuad(new Point(e.localX, e.localY));			
			var direction:int = nearestQuad.onMouseMove(new Point(e.localX - nearestQuad.x, e.localY - nearestQuad.y));
			
			for (var i:int = 0; i < quads.length; i++)
			{
				if (quads[i] != nearestQuad)
					quads[i].hideArrow();
			}
			arrowSprite.graphics.clear();
			if (direction)
			{
				var arrowp1:Point = new Point();
				arrowp1.x = SingleQuadView.pointByIndex(nearestQuad.quad.index, model.numVert, SingleQuadView.SIZE * (3 + model.numVert * 0.25)).x;
				arrowp1.y = SingleQuadView.pointByIndex(nearestQuad.quad.index, model.numVert, SingleQuadView.SIZE * (3 + model.numVert * 0.25)).y;
				
				var index2:int = (nearestQuad.quad.index + direction + model.numVert) % model.numVert;
				var arrowp2:Point = new Point();
				arrowp2.x = SingleQuadView.pointByIndex(index2, model.numVert, SingleQuadView.SIZE * (3 + model.numVert * 0.25)).x;
				arrowp2.y = SingleQuadView.pointByIndex(index2, model.numVert, SingleQuadView.SIZE * (3 + model.numVert * 0.25)).y;
				arrowSprite.graphics.lineStyle(6, 0x23e993, 1);				
				Arrow.drawArrow(arrowSprite.graphics, arrowp1, arrowp2, 30, Math.PI / 6);
			}
		}
		
		private function findNearestQuad(point:Point):SingleQuadView
		{
			var nearestDistance:Number = Number.POSITIVE_INFINITY;
			var bestQuad:SingleQuadView;
			for (var i:int = 0; i < quads.length; i++)
			{
				var distance:Number = HMath.distance(quads[i], point);
				if (distance < nearestDistance)
				{
					nearestDistance = distance;
					bestQuad = quads[i];
				}
			}
			return bestQuad;
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			if (!inputAllowed)
				return;
			var nearestQuad:SingleQuadView = findNearestQuad(new Point(e.localX, e.localY));
			if (nearestQuad.onMouseDown(new Point(e.localX - nearestQuad.x, e.localY - nearestQuad.y)))
			{
				inputAllowed = false;
				update();
			}
		}
		
		private function update():void
		{
			for (var i:int = 0; i < quads.length; i++)
			{
				quads[i].update();
				var loc:Point = SingleQuadView.pointByIndex(model.quads.indexOf(quads[i].quad), model.numVert, SingleQuadView.SIZE * (1.25 + model.numVert * 0.25));
				TweenLite.to(quads[i], 1, { x:loc.x, y:loc.y } );
				TweenLite.delayedCall(1, clearArrows);
			}
		}
		
		private function clearArrows():void
		{
			arrowSprite.graphics.clear();
			for (var i:int = 0; i < quads.length; i++)
			{
				quads[i].hideArrow();
			}
			if (!model.isWin)
				inputAllowed = true;
			tf.text = model.solution.substr(model.solution.indexOf("->") + 3, 2);
		}
		
		public function load(model:QuadModel):void
		{
			this.model = model;
			quads = new Vector.<SingleQuadView>();
			for (var i:int = 0; i < model.numVert; i++)
			{
				var view:SingleQuadView = new SingleQuadView(model.numVert);
				addChild(view);
				quads.push(view);
				
				view.x = SingleQuadView.pointByIndex(i, model.numVert, SingleQuadView.SIZE * (1.25 + model.numVert * 0.25)).x;
				view.y = SingleQuadView.pointByIndex(i, model.numVert, SingleQuadView.SIZE * (1.25 + model.numVert * 0.25)).y;
				
				view.load(model.quads[i], model);
			}
			tf.text = model.solution.substr(model.solution.indexOf("->") + 3, 2);
			
			/*
			var cl:Class = getDefinitionByName("flash.display.Sprite") as Class;
			var spr:* = new cl();
			stage.addChild(spr);
			spr.graphics.lineStyle(5, 0);
			
			for (var j:int = 0; j < 10; j++)
			{
				var rndPoint:Point = new Point(800 * Math.random(), 600 * Math.random());
				var rndPoint2:Point = new Point(800 * Math.random(), 600 * Math.random());
				Arrow.drawArrow(spr.graphics, rndPoint, rndPoint2, 15, Math.PI / 5);				
			}*/
		}
		
	}
}