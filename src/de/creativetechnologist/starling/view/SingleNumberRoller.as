/**
 * Created by mak on 07/04/15.
 */
package de.creativetechnologist.starling.view {
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.filters.BitmapFilter;
import flash.geom.Rectangle;
import flash.text.engine.ElementFormat;
import flash.text.engine.TextBaseline;
import flash.text.engine.TextBlock;
import flash.text.engine.TextElement;
import flash.text.engine.TextLine;
import flash.utils.Dictionary;

import starling.animation.Juggler;
import starling.animation.Transitions;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class SingleNumberRoller {

	private var rowImages: Vector.<DisplayObject>;
	private var _rowSprite: starling.display.Sprite;
	public function get rowSprite(): starling.display.Sprite {return _rowSprite;}

	private var textElement: TextElement;
	private var textBlock: TextBlock;
	private var textSprite: flash.display.Sprite;
	private var textureAtlas: TextureAtlas;

	private var lineHeight: int;

	private var _currentValue: Number;
	private var juggler: Juggler;

	private var _showZero: Boolean = true;

	private static var elementFormat_2_textureAtlas: Dictionary;


	public function SingleNumberRoller(target: DisplayObjectContainer, elementFormat: ElementFormat, initValue: int = 0) {
		super();

		_currentValue = initValue;

		juggler = new Juggler();
		Starling.juggler.add(juggler);

		lineHeight = int(elementFormat.fontSize + 2);

		if( elementFormat_2_textureAtlas ) {
			textureAtlas = elementFormat_2_textureAtlas[elementFormat];
		}
		else
			elementFormat_2_textureAtlas = new Dictionary();

		if( !textureAtlas ) {
			textElement = new TextElement('0\n1\n2\n3\n4\n5\n6\n7\n8\n9', elementFormat);
			textBlock = new TextBlock();
			textBlock.baselineZero = TextBaseline.ASCENT;
			textBlock.content = textElement;
			textSprite = new flash.display.Sprite();

			var textline: TextLine = textBlock.createTextLine();
			var i: int = 0;
			while( textline) {
				textline.y = (i++) * lineHeight;
				textSprite.addChild(textline);
				textline = textBlock.createTextLine(textline, 600);
			}

			var bitmapdata: BitmapData = new BitmapData(textSprite.width, textSprite.height, true, 0x00000000);
			bitmapdata.draw(textSprite);


			// TODO genrating of Texture should be "squared"
			textureAtlas = new TextureAtlas(Texture.fromBitmapData(bitmapdata));
			var region: Rectangle = new Rectangle(0,0,bitmapdata.width, lineHeight);
			for ( i = 0; i < 10; i++) {
				region.y = i * lineHeight;
				textureAtlas.addRegion(i.toString(), region);
			}
			bitmapdata.dispose();
			bitmapdata = null;
		}


		rowImages = new <DisplayObject>[];
		_rowSprite = new starling.display.Sprite();
		var rowImage: DisplayObject;
		for ( i = 0; i < 10; i++) {
			rowImage = new Image(textureAtlas.getTexture(i.toString()));

			rowImages.push(rowImage);
			rowImage.y = i * lineHeight;
			_rowSprite.addChild(rowImage);
		}

		target.addChild(_rowSprite);
		layout();

	}



	public function layout(): void {
		var rowImage: DisplayObject;
		var newAlpha: Number;
		for( var i:Number = 0; i < 10; i++) {

			rowImage = rowImages[i];
			newAlpha = Math.max(0, 1 - Math.abs(i - _currentValue));
			if( newAlpha <= 0) {
				if( _showZero || i > 0)
					rowImage.visible = false;
			}
			else {
				rowImage.alpha = newAlpha;
				if( _showZero || i > 0)
					rowImage.visible = true;
			}
			rowImage.alpha = newAlpha;
		}
		_rowSprite.y = _currentValue * -lineHeight;
	}


	public function animateToValue(value: int): void {
		if( _currentValue == value )
			return;
		juggler.tween(this, 1, {
			currentValue: value,
			transition: Transitions.EASE_OUT
		})
	}


	public function showZero(value: Boolean = true): void {
		if( _showZero == value)
			return;
		_showZero = value;
		rowImages[0].visible = value;
	}


	public function get currentValue(): Number {return _currentValue;}

	public function set currentValue(value: Number): void {
		_currentValue = value;
		layout();

	}


}
}
