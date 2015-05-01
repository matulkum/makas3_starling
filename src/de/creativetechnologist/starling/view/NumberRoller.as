/**
 * Created by mak on 07/04/15.
 */
package de.creativetechnologist.starling.view {
import de.creativetechnologist.starling.view.SingleNumberRoller;

import feathers.controls.text.TextBlockTextRenderer;

import flash.text.engine.ElementFormat;
import flash.utils.setInterval;

import starling.display.Sprite;
import starling.filters.BlurFilter;

public class NumberRoller extends Sprite {

	private var numberRollers: Vector.<SingleNumberRoller>;
	private var decimalCount: int;

	public function NumberRoller(elementFormat: ElementFormat, decimalCount: int = 3) {
		super();
		this.decimalCount = decimalCount;

		numberRollers = new <SingleNumberRoller>[];
		var numberRoller: SingleNumberRoller;
		for(var i:int = 0; i < decimalCount; i++) {
			numberRoller  = new SingleNumberRoller(this, elementFormat, 0
			);
			numberRoller.rowSprite.x = (numberRoller.rowSprite.width + 2) * i;
			numberRollers.push(numberRoller);
		}

//		var value: int = 5;
//		setInterval(function(): void {
//			setValue(Math.random() * 200);
//		}, 2000);

	}


	public function setValue(value: int, tween: Boolean = true): NumberRoller {
		var length: int = value.toString().length;
		if( length > decimalCount) {
			trace('WARNING: value is to big!');
			return this;
		}

		var i:int;


		var temp: int = value;

		for(i = decimalCount-1; i >= 0; i--) {
			numberRollers[i].showZero((decimalCount - i) < (length));
			numberRollers[i].animateToValue(temp % 10);
			temp /= 10;
		}

		return this;
	}


	public function move(x: int, y: int): NumberRoller {
		this.x = x;
		this.y = y;
		return this;
	}
}
}
