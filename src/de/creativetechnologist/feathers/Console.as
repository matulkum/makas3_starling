/**
 * Created by mak on 21.02.15.
 */
package de.creativetechnologist.feathers {
import de.creativetechnologist.log.Logger;

import feathers.controls.ScrollContainer;
import feathers.layout.VerticalLayout;

import flash.utils.setTimeout;

import starling.core.Starling;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.ResizeEvent;
import starling.text.TextField;
import starling.text.TextFieldAutoSize;
import starling.utils.HAlign;

public class Console extends Sprite {

	private var starling: Starling;

	public var fontSize: int = 12;
	public var autoScroll: Boolean = true;
	public var maxLineCount: int = 50;
	public var maxTextHeight: int = 4000;

	private var scrollContainer: ScrollContainer;


	private var textFields: Vector.<TextField> = new <TextField>[];
	private var currentColor: uint = 0;
	private var lineCount: int = 0;

	private var logColors: Vector.<uint>;

	private var logger: Logger;

	private var _isOpen: Boolean;
	public function get isOpen(): Boolean {return _isOpen;}

	private var background: Quad;
	private var meassureTextfield: TextField;


	public function Console(starling: Starling) {
		this.starling = starling;

		background = new Quad(8,8, 0);
		Quad(background).alpha = .75;
		addChild(background);

		logColors = new <uint>[
			0xff0000,
			0xffff00,
			0x00ffff,
			0xffffff
		];

		scrollContainer = new ScrollContainer();
		scrollContainer.layout = new VerticalLayout();
		scrollContainer.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_ON;
		addChild(scrollContainer);

		setupSize();
		starling.stage.addEventListener(ResizeEvent.RESIZE, onStageResize);
	}


	override public function dispose(): void {
		starling.stage.removeEventListener(ResizeEvent.RESIZE, onStageResize);
		removeLogger();
		super.dispose();
	}


	public function attachLogger(logger: Logger): void {
		this.logger = logger;
		logger.signal.add(onLogger);
	}


	public function removeLogger(): void {
		if( !logger )
			return;
		logger.signal.remove(onLogger);
	}


	public function open(): void {
		trace("Console->open() :: " );
		if( _isOpen )
			return;

		_isOpen = true;

		var i: int;
		var length: int;

		if( logger && logger.stack ) {
			length = logger.stack.length;
			for (i = 0; i < length; i++) {
				addText(logger.stack[i].message, logColors[logger.stack[i].level]);
			}
		}
		starling.stage.addChild(this);
	}


	public function close(): void {
		if( !_isOpen )
			return;
		_isOpen = false;

		removeFromParent();
		clear();
	}


	public function clear(): void {
		if (meassureTextfield)
			meassureTextfield.dispose();

		var i: int;
		var length: int = textFields.length;
		for (i = 0; i < length; i++) {
			textFields[i].removeFromParent(true);
		}
		textFields.length = 0;
		currentColor = 0;
		lineCount = 0;
	}


	public function addText(text: String, color: uint = 0xffffff): void {
		if( !_isOpen )
			return;

		var textFieldsLength: uint = textFields.length;
		var messageNumLines: int = text.split('\n').length;

		var textfield: TextField;
		if( !meassureTextfield ) {
			meassureTextfield = new TextField(starling.stage.stageWidth, 1,text, 'Arial', fontSize, color);
			meassureTextfield.autoSize = TextFieldAutoSize.VERTICAL;
			meassureTextfield.hAlign = HAlign.LEFT;
		}
		else
			 meassureTextfield.text = text;

		var measuredTextHeight: int = 0;
		try {
			measuredTextHeight = meassureTextfield.height;
		}
		catch(e:*) {}
		trace(measuredTextHeight);
		if( measuredTextHeight == 0 ||  measuredTextHeight > maxTextHeight ) {
			meassureTextfield.text = 'MESSAGE IGNORED BECAUSE MAX LINE COUNT WAS EXCEEDED!';
			measuredTextHeight =  meassureTextfield.height;
		}


		if ( color == currentColor && textFieldsLength > 0) {
			var lastTextfield: TextField = textFields[textFieldsLength - 1];
			if( measuredTextHeight + lastTextfield.height <= maxTextHeight) {
				textfield = lastTextfield;
				textfield.text += '\n' + text;
			}
		}

		if( !textfield ) {
			textfield = meassureTextfield;
			meassureTextfield = null;
		}
		textFields.push(textfield);

		scrollContainer.addChild(textfield);

		currentColor = color;

		lineCount += messageNumLines;

		if( maxLineCount > 0 ) {
			if( lineCount > maxLineCount ){
				shiftLine();
				lineCount--;
			}
		}

		scrollContainer.invalidate();
		if( autoScroll ) {
			setTimeout(function(){
				scrollContainer.verticalScrollPosition = scrollContainer.maxVerticalScrollPosition;
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
			removeChild(textFields.shift()).dispose();
		}
	}


	private function setupSize(): void {
		background.width = starling.viewPort.width;
		background.height = starling.viewPort.height >> 1;
		scrollContainer.width = starling.viewPort.width;
		scrollContainer.height = starling.viewPort.height >> 1;

		var i: int;
		var length: int = textFields.length;
		for (i = 0; i < length; i++) {
			textFields[i].width = starling.viewPort.width;
		}
	}


	public function onLogger(message: String, level: uint): void {
		if( level >= logColors.length)
			level = 3;
		addText(message, logColors[level]);
	}


	private function onStageResize(event: ResizeEvent): void {
		setupSize();
	}

}
}
