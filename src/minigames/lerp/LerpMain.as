package minigames.lerp 
{
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Quad;
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import components.Label;
	import flash.display.CapsStyle;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	import util.EnterFramer;
	import util.HMath;
	
	public class LerpMain extends Sprite 
	{
		
		private var steps:* = { };
		private var currentStep:int = -1;
		
		
		public function LerpMain() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			EnterFramer.addEnterFrameUpdate(mess);
			
			var tweenObject:Object = { };
			
			var color:uint = 0x5522ff;
			var thickness:int = 12;
			
			var serverY:int = 200;
			var clientY:int = 500;
			
			graphics.lineStyle(thickness, color);
			graphics.moveTo(100, serverY);
			graphics.lineTo(1500, serverY);
			
			graphics.moveTo(100, clientY);
			graphics.lineTo(1500, clientY);
			
			var serverLabel:Label = new Label();
			serverLabel.text = S.format.black(48) + "Сервер";
			addChild(serverLabel);
			serverLabel.x = 1300;
			serverLabel.y = serverY - 55;
			
			var clientLabel:Label = new Label();
			clientLabel.text = S.format.black(48) + "Клиент";
			addChild(clientLabel);
			clientLabel.x = 1300;
			clientLabel.y = clientY - 55;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onDOnw);
			
			steps[-1] = function():void{};
			steps[0] = drawKey;
			steps[1] = drawClientLine;
			steps[2] = drawToServer;
			steps[3] = drawServerLine;
			steps[4] = drawFromServer;
			steps[5] = highlight1;
			steps[6] = highlight2;
			steps[7] = drawRsult;/**/
			steps[8] = hideResult;
			steps[9] = oldInput;/**/
			steps[10] = oldInputFull;/**/
			steps[11] = oldInputClear;/**/
			
			var inputColor:uint = 0xff4422;
			var inputColor2:uint = 0xff8855;
			var locInit:Point = new Point(650, clientY);
				
			var locServer:Point = new Point();
			var finalLoc:Point = new Point();
			
			var resultSprite:Sprite;
			var round1Sprite:Sprite;
			var round2Sprite:Sprite;
			
			var oldInputSprite1:Sprite;
			var oldInputSprite2:Sprite;
			var oldInputSprite3:Sprite;
			
			function drawKey():void
			{
				tweenObject.radius = 0;
				var sprite:Sprite = new Sprite();
				sprite.x = locInit.x;
				sprite.y = locInit.y;
				addChild(sprite);
				
				TweenLite.to(tweenObject, 1, { radius:18, onUpdate:drawKey, ease:Elastic.easeOut} );
				TweenLite.delayedCall(0.5, addLabel);
				round1Sprite = sprite;
				
				function drawKey():void
				{
					sprite.graphics.clear();
					sprite.graphics.beginFill(inputColor, 1);
					sprite.graphics.drawCircle(0, 0, tweenObject.radius);
					sprite.graphics.endFill();					
				}
				
				function addLabel():void
				{
					var inpLabel:Label = new Label();
					inpLabel.text = S.format.black(52) + "W";
					addChild(inpLabel);
					inpLabel.x = locInit.x - inpLabel.width / 2;
					inpLabel.y = clientY + 30;
					
					inpLabel.parent.setChildIndex(inpLabel, 0);
				}
			}
			
			function drawClientLine():void
			{
				tweenObject.length = 0;
				
				var sprite:Sprite = new Sprite();
				addChild(sprite);
				
				TweenLite.to(tweenObject, 1, { length:40, onUpdate:drawLine, onComplete:drawMark } );
				
				function drawLine():void
				{
					sprite.graphics.clear();
					sprite.graphics.lineStyle(thickness, inputColor);					
					sprite.graphics.moveTo(locInit.x, locInit.y);
					sprite.graphics.lineTo(locInit.x + tweenObject.length, locInit.y);
				}
				
				function drawMark():void
				{
					sprite.graphics.lineStyle(thickness, inputColor, 1, false, "normal", CapsStyle.SQUARE);
					sprite.graphics.moveTo(locInit.x + tweenObject.length + 3, locInit.y - 15);
					sprite.graphics.lineTo(locInit.x + tweenObject.length + 3, locInit.y + 15);
				}
				
			}
			
			function drawToServer():void
			{
				tweenObject.ratio = 0;
				var delta:int = 230;
				
				var sprite:Sprite = new Sprite();
				addChild(sprite);
				
				TweenLite.to(tweenObject, 2.5, { ratio:1, onUpdate:drawLine, ease:Quad.easeIn } );
				
				function drawLine():void
				{
					var resultingPoint:Point = new Point(HMath.linearInterp(0, 0, 1, delta, tweenObject.ratio), HMath.linearInterp(0, 0, 1, serverY - clientY, tweenObject.ratio));
					
					sprite.graphics.clear();
					sprite.graphics.lineStyle(thickness, inputColor);					
					sprite.graphics.moveTo(locInit.x + tweenObject.length, locInit.y);
					sprite.graphics.lineTo(locInit.x + tweenObject.length + resultingPoint.x, locInit.y + resultingPoint.y);
					
					locServer.setTo(locInit.x + tweenObject.length + resultingPoint.x, serverY);
				}
			}
			
			function drawServerLine():void
			{
				tweenObject.length = 0;
				
				var sprite:Sprite = new Sprite();
				addChild(sprite);
				
				TweenLite.to(tweenObject, 1, { length:50, onUpdate:drawLine, onComplete:drawMark } );
				
				function drawLine():void
				{
					sprite.graphics.clear();
					sprite.graphics.lineStyle(thickness, inputColor);					
					sprite.graphics.moveTo(locServer.x, locServer.y);
					sprite.graphics.lineTo(locServer.x + tweenObject.length, locServer.y);
				}
				
				function drawMark():void
				{
					sprite.graphics.lineStyle(thickness, inputColor, 1, false, "normal", CapsStyle.SQUARE);
					sprite.graphics.moveTo(locServer.x + tweenObject.length + 3, locServer.y - 15);
					sprite.graphics.lineTo(locServer.x + tweenObject.length + 3, locServer.y + 15);
				}
				
			}
			
			function drawFromServer():void
			{
				tweenObject.ratio = 0;
				var delta:int = 250;
				
				var sprite:Sprite = new Sprite();
				addChild(sprite);
				
				round2Sprite = new Sprite();
				addChild(round2Sprite);
				
				TweenLite.to(tweenObject, 2.5, { ratio:1, onUpdate:drawLine, ease:Quad.easeIn, onComplete:drawCircle } );
				
				function drawLine():void
				{
					var resultingPoint:Point = new Point(HMath.linearInterp(0, 0, 1, delta, tweenObject.ratio), HMath.linearInterp(0, 0, 1, clientY - serverY, tweenObject.ratio));
					
					sprite.graphics.clear();
					sprite.graphics.lineStyle(thickness, inputColor);					
					sprite.graphics.moveTo(locServer.x + tweenObject.length, locServer.y);
					sprite.graphics.lineTo(locServer.x + tweenObject.length + resultingPoint.x, locServer.y + resultingPoint.y);
					
					finalLoc.setTo(locServer.x + tweenObject.length + resultingPoint.x, clientY);
				}
				
				
				function drawCircle():void
				{
					round2Sprite.x = finalLoc.x;
					round2Sprite.y = finalLoc.y;
					tweenObject.radius = 0;
					TweenLite.to(tweenObject, 0.3, { radius:18, onUpdate:drawKey} );
						
					function drawKey():void
					{
						round2Sprite.graphics.clear();
						round2Sprite.graphics.beginFill(inputColor, 1);
						round2Sprite.graphics.drawCircle(0, 0, tweenObject.radius);
						round2Sprite.graphics.endFill();					
					}
				}
				
			}
			
			function highlight1():void
			{
				
				tweenObject.radius = 18;
				
				var timeLine:TimelineLite = new TimelineLite();
				timeLine.append(TweenLite.to(tweenObject, 0.5, { radius:36, onUpdate:drawKey, ease:Elastic.easeOut} ));
				timeLine.append(TweenLite.to(tweenObject, 0.5, { radius:18, onUpdate:drawKey, ease:Elastic.easeOut} ));
				
				function drawKey():void
				{
					round1Sprite.graphics.clear();
					round1Sprite.graphics.beginFill(inputColor, 1);
					round1Sprite.graphics.drawCircle(0, 0, tweenObject.radius);
					round1Sprite.graphics.endFill();					
				}
			}
			
			function highlight2():void
			{
				
				tweenObject.radius = 18;
				
				var timeLine:TimelineLite = new TimelineLite();
				timeLine.append(TweenLite.to(tweenObject, 0.5, { radius:36, onUpdate:drawKey, ease:Elastic.easeOut} ));
				timeLine.append(TweenLite.to(tweenObject, 0.5, { radius:18, onUpdate:drawKey, ease:Elastic.easeOut} ));
				
				function drawKey():void
				{
					round2Sprite.graphics.clear();
					round2Sprite.graphics.beginFill(inputColor, 1);
					round2Sprite.graphics.drawCircle(0, 0, tweenObject.radius);
					round2Sprite.graphics.endFill();					
				}
			}
			
			function drawRsult():void
			{
				tweenObject.ratio = 0;
				
				var sprite:Sprite = new Sprite();
				addChild(sprite);
				resultSprite = sprite;
				TweenLite.to(tweenObject, 2, { ratio:1, onUpdate:drawLine, ease:Cubic.easeIn} );
				
				function drawLine():void
				{
					var dy:int = 100;
					
					
					var resultingPoint:Point = new Point(HMath.linearInterp(0, locInit.x, 1, finalLoc.x, tweenObject.ratio), 
														HMath.linearInterp(0, locInit.y, 1, finalLoc.y, tweenObject.ratio));
					
					sprite.graphics.clear();
					sprite.graphics.lineStyle(thickness - 2, inputColor);					
					sprite.graphics.moveTo(locInit.x, locInit.y + dy);
					sprite.graphics.lineTo(resultingPoint.x, resultingPoint.y + dy);
					
					sprite.graphics.moveTo(locInit.x - 1, locInit.y - 15 + dy);
					sprite.graphics.lineTo(locInit.x - 1, locInit.y + 15 + dy);
					
					sprite.graphics.moveTo(resultingPoint.x + 1, resultingPoint.y - 15 + dy);
					sprite.graphics.lineTo(resultingPoint.x + 1, resultingPoint.y + 15 + dy);
					
				}
				
			}
			
			function hideResult():void
			{
				TweenLite.to(resultSprite, 0.5, { alpha:0 } ); 
			}
			
			function oldInput():void
			{
				tweenObject.ratio = 0;
				var delta:int = 300;
				
				var partRatio:Number = 0.25;
				
				var sprite:Sprite = new Sprite();
				addChild(sprite);
				sprite.parent.setChildIndex(sprite, 0);
				
				var sprite2:Sprite = new Sprite();
				addChild(sprite2);
				sprite.parent.setChildIndex(sprite2, 0);
				
				oldInputSprite1 = sprite;
				oldInputSprite3 = sprite2;
				
				TweenLite.to(tweenObject, 0.7, { ratio:1, onUpdate:drawLine, ease:Quad.easeIn, onComplete:drawCircle } );
				
				function drawLine():void
				{
					var resultingPoint:Point = new Point(HMath.linearInterp(0, locInit.x + 120 - delta, 1, locInit.x + 120, (1 - partRatio) + tweenObject.ratio * partRatio), 
														HMath.linearInterp(0, serverY, 1, clientY, (1 - partRatio) + tweenObject.ratio * partRatio));
														
					var resultingPoint2:Point = new Point(HMath.linearInterp(0, locInit.x + 120 - delta, 1, locInit.x + 120, (1 - partRatio)), 
														HMath.linearInterp(0, serverY, 1, clientY, (1 - partRatio)));
					
					sprite.graphics.clear();
					sprite.graphics.lineStyle(thickness, inputColor2);					
					sprite.graphics.moveTo(resultingPoint2.x, resultingPoint2.y);
					sprite.graphics.lineTo(resultingPoint.x, resultingPoint.y);
				}
				
				
				function drawCircle():void
				{
					sprite2.x = locInit.x + 120;
					sprite2.y = clientY;
					tweenObject.radius = 0;
					TweenLite.to(tweenObject, 0.3, { radius:18, onUpdate:drawKey} );
						
					function drawKey():void
					{
						sprite2.graphics.clear();
						sprite2.graphics.beginFill(inputColor2, 1);
						sprite2.graphics.drawCircle(0, 0, tweenObject.radius);
						sprite2.graphics.endFill();					
					}
				}
			}
			
			
			
			function oldInputFull():void
			{
				tweenObject.ratio = 0;
				var delta:int = 300;
				
				var partRatio:Number = 0.25;
				
				var sprite:Sprite = new Sprite();
				addChild(sprite);
				sprite.parent.setChildIndex(sprite, 0);
				oldInputSprite2 = sprite;
				TweenLite.to(tweenObject, 0.7, { ratio:1, onUpdate:drawLine, ease:Quad.easeIn, onComplete:drawMark } );
				var resultingPoint2:Point;				
				var resultingPoint:Point;
				
				function drawLine():void
				{			
					resultingPoint2 = new Point(HMath.linearInterp(0, locInit.x + 120 - delta, 1, locInit.x + 120, (1 - partRatio)), 
														HMath.linearInterp(0, serverY, 1, clientY, (1 - partRatio)));
					
					resultingPoint = new Point(HMath.linearInterp(0, resultingPoint2.x, 1, locInit.x + 120 - delta, tweenObject.ratio), 
														HMath.linearInterp(0, resultingPoint2.y, 1, serverY, tweenObject.ratio));
											
					sprite.graphics.clear();
					sprite.graphics.lineStyle(thickness, inputColor2);					
					sprite.graphics.moveTo(resultingPoint2.x, resultingPoint2.y);
					sprite.graphics.lineTo(resultingPoint.x, resultingPoint.y);
				}
				
				
				function drawMark():void
				{
					
					sprite.graphics.lineStyle(thickness, inputColor2, 1, false, "normal", CapsStyle.SQUARE);
					sprite.graphics.moveTo(resultingPoint.x -1, serverY - 15);
					sprite.graphics.lineTo(resultingPoint.x -1, serverY + 15);
				}
			}
			
			function oldInputClear():void
			{
				TweenLite.to(oldInputSprite1, 0.5, { alpha:0 } ); 
				TweenLite.to(oldInputSprite2, 0.5, { alpha:0 } ); 
				TweenLite.to(oldInputSprite3, 0.5, { alpha:0 } ); 
			}
			
		}
		
		private function mess(e:Event):void 
		{
			var spr:Sprite = new Sprite();
			addChild(spr);
			spr.x = 10 * (getTimer() % 100);
			spr.y = 900;
			
			spr.graphics.beginFill(0, 1);
			spr.graphics.drawCircle(0, 0, 1);
			spr.graphics.endFill();
		}
		
		private function onDOnw(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.F8)
				return;
			if (steps[currentStep] != null)
			{
				steps[currentStep]();
				currentStep++;				
			}
		}
		
	}

}