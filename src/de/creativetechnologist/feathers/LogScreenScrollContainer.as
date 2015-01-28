/**
 * Created by mak on 21.05.14.
 */
package de.creativetechnologist.feathers {
import feathers.controls.ScrollContainer;
import feathers.layout.VerticalLayout;

import starling.text.TextField;
import starling.text.TextFieldAutoSize;


public class LogScreenScrollContainer extends ScrollContainer {

	public var fontName: String = 'Verdana';
	public var fontSize: int = 12;
	public var autoScroll: Boolean = true;
	public var maxLineCount: int = 50;

	private var textFields: Vector.<TextField> = new <TextField>[];
	private var currentColor: uint = 0;
	private var lineCount: int = 0;


	public function LogScreenScrollContainer() {
		super();
		layout = new VerticalLayout();
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

		validate();
		if( autoScroll ) {
			verticalScrollPosition = maxVerticalScrollPosition;
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
