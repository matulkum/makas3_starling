/**
 * Created by mak on 27/04/15.
 */
package de.creativetechnologist.feathers.motion {
import starling.animation.Transitions;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.utils.HAlign;

public class ScaleTransition {

	protected static const SCREEN_REQUIRED_ERROR:String = "Cannot transition if both old screen and new screen are null.";

	public function ScaleTransition() {
	}


	public static function createUp(duration: Number = 0.5, fromX: int = -1, fromY: int = -1): Function {
		return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void {
			if(!oldScreen && !newScreen)
				throw new ArgumentError(SCREEN_REQUIRED_ERROR);

			newScreen.alpha = 0;
			newScreen.scaleX = newScreen.scaleY = 1;
			newScreen.alignPivot();
			var centerX: Number = newScreen.width >> 1;
			var centerY: Number = newScreen.height >> 1;
			newScreen.scaleX = newScreen.scaleY = .1;

			newScreen.x = fromX > -1 ? fromX : centerX;
			newScreen.y = fromY > -1 ? fromY : centerY;

			newScreen.parent.setChildIndex(newScreen, newScreen.parent.numChildren - 1);
			Starling.juggler.tween(newScreen, duration, {
				x: centerX,
				y: centerY,
				scaleX: 1,
				scaleY: 1,
				alpha: 1,
				transition: Transitions.EASE_OUT,
				onComplete: onComplete
			});
		}
	}


	public static function createDown(duration: Number = 0.5, fromX: int = -1, fromY: int = -1): Function {
		return function(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void {
			if(!oldScreen && !newScreen)
				throw new ArgumentError(SCREEN_REQUIRED_ERROR);

			oldScreen.alpha = 1;
			oldScreen.alignPivot();
			var centerX: Number = oldScreen.width >> 1;
			var centerY: Number = oldScreen.height >> 1;
			oldScreen.x = centerX;
			oldScreen.y = centerY;
			oldScreen.scaleX = oldScreen.scaleY = 1;

			var toX: int = fromX > -1 ? fromX : centerX;
			var toY: int = fromY > -1 ? fromY : centerY;

			oldScreen.parent.setChildIndex(oldScreen, oldScreen.parent.numChildren - 1);
			Starling.juggler.tween(oldScreen, duration, {
				x: toX,
				y: toY,
				scaleX: .1,
				scaleY: .1,
				alpha: 0,
				transition: Transitions.EASE_OUT,
				onComplete: function():void {
					onComplete();
					oldScreen.alpha =1;
					oldScreen.scaleX = oldScreen.scaleY = 1;
					oldScreen.pivotX = oldScreen.pivotY = 0;
					oldScreen.x = 0;
					oldScreen.y = 0;
				}
			});
		}
	}
}
}
