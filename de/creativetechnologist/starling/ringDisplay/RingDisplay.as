/**
 * Created by mak on 10.09.14.
 */
package de.creativetechnolgist.starling.ringDisplay {
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Quad;
import starling.display.Sprite;
import starling.textures.Texture;

public class RingDisplay extends DisplayObjectContainer{

	protected var _width: int;
	protected var _height: int;
	protected var _items: Vector.<RingDisplayItem>;
	protected var _ownsItems: Boolean;

	protected var back: DisplayObject;
	protected var selfCreatedBack: DisplayObject;


	protected var _index: Number = -1;


	public function get numPictures(): int { return items.length; }
	public function get index(): Number {return _index;}
	public function get items(): Vector.<RingDisplayItem> {return _items;}

	override public function get width(): Number { return _width;}
	override public function set width(value: Number): void { _width = value;}
	override public function get height(): Number { return _height;}
	override public function set height(value: Number): void { _height = value;}


	public function RingDisplay(width: int, height: int, background: DisplayObject = null) {
		super();
		_width = width;
		_height = height;
		if( background ) {
			back = background;
		}
		else {
			selfCreatedBack = new Quad(width, height, 0, true);
			selfCreatedBack.alpha = 0;
			back = selfCreatedBack;
		}
		addChild(back);
	}


	override public function dispose(): void {
		removeChild(back);
		if( selfCreatedBack ) {
			selfCreatedBack.dispose();
			selfCreatedBack = null;
		}
		if( _ownsItems )
			disposeItems();
	}


	public function disposeItems(): void {
		var i: int;
		var length: int;
		length = _items.length;
		for (i = 0; i < length; i++) {
			_items[i].dispose();
		}
	}


	/**
	 *
	 * @param items
	 * @param ownsItems If true dispose() will be called on all items also when disposing
	 */
	public function initWithItems(items: Vector.<RingDisplayItem>, ownsItems: Boolean = true): void {

		_items = items;
		var i: int;
		var length: int = _items.length;
		for (i = 0; i < length; i++) {
			items[i].addToRingDisplay(this, i);
		}
		_ownsItems = ownsItems;
	}



	public function set index(index: Number): void {
		if( index == _index)
			return;
		_index = index;

		var i: int;
		var length: int = items.length;
		for (i = 0; i < length; i++) {
			_items[i].setDisplayIndex(_index);
		}
	}
}
}