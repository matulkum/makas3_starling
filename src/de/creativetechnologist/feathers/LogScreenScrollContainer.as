/**
 * Created by mak on 21.05.14.
 */
package de.creativetechnologist.feathers {
import feathers.controls.ScrollContainer;
import feathers.layout.VerticalLayout;

import flash.utils.setTimeout;

import starling.text.TextField;
import starling.text.TextFieldAutoSize;


public class LogScreenScrollContainer extends ScrollContainer {

	public var fontName: String = 'Arial';
	public var fontSize: int = 14;
	public var autoScroll: Boolean = true;
	public var maxLineCount: int = 50;

	private var textFields: Vector.<TextField> = new <TextField>[];
	private var currentColor: uint = 0;
	private var lineCount: int = 0;

	private var logColors: Vector.<uint>;


	public function LogScreenScrollContainer() {
		super();
		layout = new VerticalLayout();
		logColors = new <uint>[
			0xff0000,
			0xffff00,
			0x00ffff,
			0xffffff
		];
	}


	public function log(msg: String, level: uint = 3): void {
		if( level >= logColors.length)
			level = 3;
		addText(msg, logColors[level]);
	}

	public function addText(text: String, color: uint = 0): void {
		var textfield: TextField;
		if( textFields.length == 0 || color != currentColor ) {
			textfield = new TextField(1,1, text, fontName, fontSize, color);
			textfield.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			addChild(textfield);
			textFields.push(textfield);
		}
		else {
			textfield = textFields[textFields.length-1];
			textfield.text += '\n' + text;
		}

		currentColor = color;

		lineCount++;

		if( maxLineCount > 0 ) {
			if( lineCount > maxLineCount ){
				shiftLine();
				lineCount--;
			}
		}

		invalidate();
		if( autoScroll ) {
			setTimeout(function(){
				verticalScrollPosition = maxVerticalScrollPosition;
			}, .001)
		}
	}


	public function shiftLine(): void {
		if( textFields.length == 0 )
			return;

		var string:String = textFields[0].text;
		var indexOfLinebreak: int = string.indexOf('\n');
		if( indexOfLinebreak > -1)
			textFields[0].text = string.substr(indexOfLinebreak + 1);
		else {
			removeChild(textFields.shift());
		}

//		trace("LogScreenScrollContainer->shiftLine() [70]:: ", textFields[0].text );

	}
}
}
