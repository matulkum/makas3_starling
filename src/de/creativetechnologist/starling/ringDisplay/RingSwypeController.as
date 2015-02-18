/**
 * Created by mak on 10.09.14.
 */
package de.creativetechnologist.starling.ringDisplay {
import de.creativetechnologist.util.Utils;

import flash.geom.Point;

import starling.animation.Transitions;
import starling.core.Starling;
import starling.events.Event;
import starling.events.EventDispatcher;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class RingSwypeController extends EventDispatcher {

	private var _ringDisplay: RingDisplay;
	private var _width: int;

	private var currentIndex: int;
	private var currentItem: RingDisplayItem;
	private var currentTouch: Touch;
	private var touchStartX: Number;
	private var lastTouchStartX: Number;


	public function get ringDisplay(): RingDisplay { return _ringDisplay;}


	public function RingSwypeController(ringDisplay: RingDisplay) {
		this._ringDisplay = ringDisplay;
		this._width = ringDisplay.width;
		ringDisplay.index = 0;
		currentIndex = 0;
		setCurrentItem(ringDisplay.items[0]);
	}


	public function setIndex(index: int, tween: Boolean = true): void {
		currentIndex = index;
		var newItem: RingDisplayItem = _ringDisplay.items[Utils.normalizeIndexToLength(index, _ringDisplay.items.length)];
		var didItemChange: Boolean = currentItem != newItem;
		setCurrentItem(newItem);
		if( tween ) {
			Starling.juggler.tween(_ringDisplay, .5, {
				index: index,
				transition: Transitions.EASE_OUT,
				onComplete: didItemChange ? onSetIndexTweenComplete : null
			});
		}
		else {
			_ringDisplay.index = index;
		}
		dispatchEventWith(Event.CHANGE);
	}


	private function onSetIndexTweenComplete(): void {
		currentItem.onShow();
	}



	public function getIndex(): int {
		return currentIndex;
	}


	private function setCurrentItem(item: RingDisplayItem): void {
		if( item == currentItem )
			return;
		if( currentItem ) {
			currentItem.getTouchTarget().removeEventListener(TouchEvent.TOUCH, onViewTouched);
			currentItem.onHide();
		}
		currentItem = item;
		currentItem.getTouchTarget().addEventListener(TouchEvent.TOUCH, onViewTouched);
	}


	private function onViewTouched(event: TouchEvent): void {
		var touches: Vector.<Touch>;
		if( !currentTouch ) {
			touches = event.getTouches(_ringDisplay, TouchPhase.BEGAN);
			if( touches.length > 0) {
				currentTouch = touches[0];
				touchStartX = currentTouch.getLocation(_ringDisplay).x;
				lastTouchStartX = touchStartX;
				Starling.juggler.removeTweens(_ringDisplay);
			}
			return;
		}
		else {
			touches = event.getTouches(_ringDisplay);
			var i: int;
			var length: int = touches.length;
			for (i = 0; i < length; i++) {
				if( !currentTouch || touches[i].id != currentTouch.id )
					return;

				var location: Point = touches[i].getLocation(_ringDisplay);
				var moveRatio: Number = ((lastTouchStartX - location.x)) / _width;
				if( touches[i].phase == TouchPhase.MOVED) {
					_ringDisplay.index = _ringDisplay.index + moveRatio ;

					lastTouchStartX = location.x;
				}
				else if( touches[i].phase == TouchPhase.ENDED) {
					currentTouch = null;
					moveRatio = ((touchStartX - location.x)) / _width;
					if( Math.abs(moveRatio) > .05 ) {
						if( moveRatio > 0 )
							setIndex(Math.ceil(_ringDisplay.index));
						else
							setIndex(Math.floor(_ringDisplay.index));

					}
					else {
						setIndex(currentIndex);
					}
				}
			}
		}
	}
}
}
