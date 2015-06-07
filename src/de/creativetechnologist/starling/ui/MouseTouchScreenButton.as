/**
 * Created by mak on 16/04/15.
 */
package de.creativetechnologist.starling.ui {
import flash.geom.Rectangle;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.Texture;

[Event(name="triggered", type="starling.events.Event")]

public class MouseTouchScreenButton extends Sprite {

	protected var upImage: Image;
	protected var downImage: Image;
	protected var _isHovering: Boolean = false;
	protected var mTriggerBounds: Rectangle;

	protected var upImageWidth: Number;
	protected var upImageHeight: Number;

	public function MouseTouchScreenButton(upTexture: Texture, downTexture: Texture) {
		super();
		upImage = new Image(upTexture);
		upImageWidth = upImage.width;
		addChild(upImage);

		if (downTexture) {
			downImage = new Image(downTexture);
			downImage.visible = false;
			addChildAt(downImage, 0);
		}

		layout();

		addEventListener(TouchEvent.TOUCH, onTouched);
	}



	protected function layout(): void {
		upImage.alignPivot();
		upImageWidth = upImage.width;
		upImageHeight = upImage.height;
		upImage.x = upImageWidth >> 1;
		upImage.y = upImageHeight >> 1;

		if( downImage ) {
			downImage.alignPivot();
			downImage.x = upImage.x;
			downImage.y = upImage.y;
		}
	}


	public function updateImageTextures(upTexture: Texture, downTexture: Texture): void {
		upImage.texture = upTexture;
		upImage.readjustSize();
		if( downImage ) {
			downImage.texture = downTexture;
			downImage.readjustSize();
		}
		else {
			downImage = new Image(downTexture);
			addChildAt(downImage, 0);
		}
		layout();
	}


	private var decisionTimeOutID: uint;
	private function onTouched(event: TouchEvent): void {
		var touch:Touch = event.getTouch(this);
		//trace(touch);
		if( !touch ) {
			isHovering = false;
			clearTimeout(decisionTimeOutID);
			return;
		}

		if( touch.phase == TouchPhase.BEGAN ) {
			mTriggerBounds = getBounds(stage, mTriggerBounds);
			isHovering = true;
		}
		else if( touch.phase == TouchPhase.ENDED) {
			if( mTriggerBounds && mTriggerBounds.contains(touch.globalX, touch.globalY))
				dispatchEventWith(Event.TRIGGERED);
			setTimeout(function():void{
			    isHovering = false;
			}, 100);
			clearTimeout(decisionTimeOutID);
		}
		else if( touch.phase == TouchPhase.HOVER) {
			isHovering = true;
			clearTimeout(decisionTimeOutID);
			decisionTimeOutID = setTimeout(function():void{
			    isHovering = false;
			}, 2000);
		}
		else if( touch.phase == TouchPhase.MOVED) {
			if( !mTriggerBounds || !mTriggerBounds.contains(touch.globalX, touch.globalY)) {
				clearTimeout(decisionTimeOutID);
				isHovering = false;
			}
		}

	}

	public function set isHovering(value: Boolean): void {
		if( _isHovering == value )
			return;
		_isHovering = value;

		if( !downImage )
			return;

		if( value ) {
			downImage.visible = true;
			upImage.visible = false;
		}
		else {
			downImage.visible = false;
			upImage.visible = true;
		}
	}
}
}
