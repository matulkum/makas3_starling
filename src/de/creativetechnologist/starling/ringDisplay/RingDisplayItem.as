/**
 * Created by mak on 10.09.14.
 */
package de.creativetechnologist.starling.ringDisplay {
import starling.display.DisplayObject;

public class RingDisplayItem  {

	public var view: DisplayObject;
	protected var _ownsView: Boolean;

	protected var _index: int = 0;
	protected var _ringDisplay: RingDisplay;
	protected var displayed: Boolean = false;
	protected var _width;
	protected var _numItems: int;

	public function getIndex(): int {return _index;}


	/**
	 *
	 * @param view
	 * @param ownsView If true the dispose() will be called on the view also when disposing
	 */
	public function RingDisplayItem(view: DisplayObject, ownsView: Boolean = true) {
		super();
		this.view = view;
		_ownsView = ownsView;
		_width = view.width;
	}


	public function dispose(): void {
		if( _ownsView ) {
			view.removeFromParent();
			view.dispose();
		}
	}



	public function getTouchTarget(): DisplayObject {
		return view;
	}


	public function onShow(): void {
	}


	public function onHide(): void {
	}


	/**
	 * will be called to remove item from view
	 */
	protected function stash(): void {
		_ringDisplay.removeChild(view);
	}

	/**
	 * will be called to add item back to view
	 */
	protected function unStash(): void {
		_ringDisplay.addChild(view);
	}


	internal function addToRingDisplay(ringDisplay: RingDisplay, atIndex: int): void {
		this._index = atIndex;
		this._ringDisplay = ringDisplay;
		_numItems = ringDisplay.numPictures;
	}


	[Inline]
	public function setDisplayIndex(displayIndex: Number): void {
		displayIndex = displayIndex % (_numItems);

		if( displayIndex < 0)
			displayIndex = _numItems + displayIndex;

		var slideRatio: Number;
		if( _index == 0 && int(displayIndex) == _numItems-1  )
			slideRatio = 1 - (displayIndex % 1);
		else
			slideRatio = _index - displayIndex;

		if( !displayed ) {
			if( Math.abs(slideRatio) < 1 ) {
				displayed = true;
				updateViewTranslation(slideRatio);
				unStash();
			}
		}
		else {
			if( Math.abs(slideRatio) > 1 ) {
				displayed = false;
				stash();
				return;
			}
			else
				updateViewTranslation(slideRatio);
		}

	}


	[Inline]
	protected function updateViewTranslation(slideRatio: Number): void {
		view.x = Math.round(_ringDisplay.width * slideRatio);
	}

}
}
