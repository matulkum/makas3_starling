/**
 * Created by mak on 26.01.15.
 */
package de.creativetechnologist.starling.gesture {
import org.osflash.signals.Signal;

import starling.display.DisplayObject;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class TouchDownGesture {

	private var _target: DisplayObject;
	protected var _currentTouchDowns: Vector.<Touch>;

	protected var isDown: Boolean;

	// (this, EVT_String)
	private var _signal: Signal;
	public static var EVT_DOWN: String = 'EVT_DOWN';
	public static var EVT_UP: String = 'EVT_UP';


	public function get signal(): Signal {return _signal;}




	public function TouchDownGesture(target: DisplayObject) {
		_target = target;
		_signal = new Signal(TouchDownGesture, String);
		_target.addEventListener(TouchEvent.TOUCH, onTargetTouched);
	}


    public function set enabled(value: Boolean): void {
        if( value )
            _target.addEventListener(TouchEvent.TOUCH, onTargetTouched);
        else
            _target.removeEventListener(TouchEvent.TOUCH, onTargetTouched);
    }


	private function onTargetTouched(event: TouchEvent): void {
		var i: int;
		var length: int;

//		var currentTouchDowns:Vector.<Touch> = _currentTouchDowns.concat();
//		length = currentTouchDowns.length;
//		for (i = 0; i < length; i++) {
//			if( currentTouchDowns[i].phase == TouchPhase.ENDED ) {
//				_currentTouchDowns.splice()
//			}
//		}

		var isTouching:Boolean = false;
		var touches: Vector.<Touch> = event.getTouches(_target);
		length = touches.length;
		for (i = 0; i < length; i++) {
			if( touches[i].phase == TouchPhase.BEGAN ) {
				isTouching = true;
//				_currentTouchDowns.push(touches[i]);
			}
			else if( touches[i].phase == TouchPhase.MOVED ) {
				isTouching = true;
				return;
			}
		}

		if( !isDown ) {
			if( isTouching ) {
				isDown = true;
				_signal.dispatch(this, EVT_DOWN);
				trace(EVT_DOWN);
			}
		}
		else {
			if( !isTouching ) {
				isDown = false;
				_signal.dispatch(this, EVT_UP);
				trace(EVT_UP);
			}
		}

	}

    public function get target():DisplayObject {
        return _target;
    }
}
}
