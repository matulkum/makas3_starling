/**
 * Created by mak on 04.05.14.
 */
package de.creativetechnologist.feathers {
import feathers.controls.Button;
import feathers.controls.Label;
import feathers.controls.LayoutGroup;
import feathers.controls.TextInput;
import feathers.controls.ToggleButton;
import feathers.controls.ToggleSwitch;
import feathers.core.IToggle;
import feathers.layout.HorizontalLayout;
import feathers.layout.VerticalLayout;

import flash.utils.Dictionary;

import starling.display.DisplayObjectContainer;
import starling.events.Event;
import starling.text.TextField;
import starling.text.TextFieldAutoSize;

public class RapidFeathers {

	public var targetContainer: DisplayObjectContainer;
	public var dataModel: *;

	private var textFields: Vector.<TextField>;
	private var propertyName_to_textInput: Dictionary;
	private var propertyName_to_toggle: Dictionary;

	public static const C_PINK: uint = 0xff00ff;
	public static const C_RED: uint = 0xff0000;
	public static const C_RED_LIGHT: uint = 0xffacac;
	public static const C_ORANGE: uint = 0xffa200;
	public static const C_BLUE_NEON: uint = 0x00ffff;
	public static const C_BLUE_LIGHT: uint = 0x96beff;
	public static const C_YELLOW: uint = 0xffff00;
	public static const C_GREEN: uint = 0x00ff00;
	public static const C_GREEN_LIGHT: uint = 0xcaffca;

	public function RapidFeathers(targetContainer: DisplayObjectContainer) {
		this.targetContainer = targetContainer;
		textFields = new <TextField>[];
	}


	public function createBtn(label: String): Button {
		return RapidFeathers.createBtn(targetContainer, label, null);
	}


	public function createLabel(text: String = ''): Label {
		return RapidFeathers.createLabel(targetContainer, text);
	}


	public function createTextField(text: String = '', color: uint = 0, dataModelProperty: String = null): TextField {
		var textField: TextField = RapidFeathers.createTextField(targetContainer, text, color);
		if( dataModelProperty ) {
			try {
				textField.text = dataModel[dataModelProperty];
			}
			catch(e: Error) {
				trace("Rapid->addTextInputToDataModel() :: WARNING, propertyName "+dataModelProperty+" not found on dataModel"  );
			}
		}
		return  textField;
	}


	public function createTextInput(text: String, dataModelProperty: String = null): TextInput {
		var textInput: TextInput = RapidFeathers.createTextInput(targetContainer, text);
		if( dataModelProperty ) {
			addTextInputToDataModel(textInput, dataModelProperty );
			if( dataModel && dataModel[dataModelProperty] )
				textInput.text = dataModel[dataModelProperty];
		}
		return textInput;
	}

	public function createTextInputWithLabel(labelText: String, text: String, dataModelProperty: String = null): TextInputWithLabel {
		var textInputWithLabel: TextInputWithLabel = RapidFeathers.createTextInputWithLabel(targetContainer, labelText, text);
		if( dataModelProperty ) {
			addTextInputToDataModel(textInputWithLabel.textInput, dataModelProperty );
			if( dataModel && dataModel[dataModelProperty] )
				textInputWithLabel.text = dataModel[dataModelProperty];
		}
		return  textInputWithLabel;
	}


	public function createToggleSwitch(offText: String, onText: String, isSelected: Boolean = false, dataModelProperty: String = null): ToggleSwitch {
		var toogle: ToggleSwitch = RapidFeathers.createToggleSwitch( targetContainer, offText, onText, isSelected);
		addToggleToDataModel(toogle, dataModelProperty);
		return toogle;
	}


	private function addTextInputToDataModel(input: TextInput, propertyName: String): void {
		if( !propertyName_to_textInput )
			propertyName_to_textInput = new Dictionary();

		propertyName_to_textInput[propertyName] = input;
		if( dataModel) {
			try {
				input.text = dataModel[propertyName];
			}
			catch(e: Error) {
				trace("Rapid->addTextInputToDataModel() :: WARNING, propertyName "+propertyName+" could not be applied to field"  );
			}
		}
	}


	private function addToggleToDataModel(toggle: IToggle, propertyName: String): void {
		if( !propertyName_to_toggle )
			propertyName_to_toggle = new Dictionary();

		propertyName_to_toggle[propertyName] = toggle;
		if( dataModel ) {
			try {
				toggle.isSelected = Boolean(dataModel[propertyName]);
			}
			catch(e: Error) {
				trace("Rapid->addTextInputToDataModel() :: WARNING, propertyName "+propertyName+" could not be applied to field"  );
			}
		}
	}


	public function applyToDataModel(): void {
		if( !dataModel )
			return;

		var propertyName: String;
		for(propertyName in propertyName_to_textInput) {
			dataModel[propertyName] = TextInput(propertyName_to_textInput[propertyName]).text;
		}
		for(propertyName in propertyName_to_toggle) {
			dataModel[propertyName] = Boolean(IToggle(propertyName_to_toggle[propertyName]).isSelected);
		}
	}


	public function applyDataModelToUI(): void {
		if( !dataModel )
			return;

		var propertyName: String;
		for(propertyName in propertyName_to_textInput) {
			TextInput(propertyName_to_textInput[propertyName]).text = dataModel[propertyName];
		}
		for(propertyName in propertyName_to_toggle) {
			IToggle(propertyName_to_toggle[propertyName]).isSelected = Boolean(dataModel[propertyName]);
		}
	}




	// statics

	// text

	public static function createBtn(parent: DisplayObjectContainer, label: String, triggerHandler: Function = null): Button {
		var button: Button = new Button();
		button.label = label;
		if( parent ) {
			parent.addChild(button);
		}
		if( triggerHandler )
			button.addEventListener(Event.TRIGGERED, triggerHandler);
		return button;
	}

	public static function createLabel(parent: DisplayObjectContainer, text: String = ''): Label {
		var label: Label = new Label();
		if( text != '')
			label.text = text;
		parent.addChild(label);
		return label;
	}

	public static function createTextField(parent: DisplayObjectContainer, text: String = '', color: uint = 0): TextField {
		var txt: TextField = new TextField(14,14, text);
		txt.color = color;
		txt.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
		parent.addChild(txt);
		return txt;
	}

	public static function createTextInput(parent: DisplayObjectContainer, text: String): TextInput {
		var input:TextInput = new TextInput();
		input.text = text;

		if( parent )
			parent.addChild(input);

		return input
	}

	public static function createTextInputWithLabel(parent: DisplayObjectContainer, labelText: String, text: String): TextInputWithLabel {
		var r: TextInputWithLabel = new TextInputWithLabel(labelText, text);
		if( parent )
			parent.addChild(r);

		return r;
	}


	// Toggles

	public static function createToggleButton(parent: DisplayObjectContainer, isSelected: Boolean = false): ToggleButton {
		var toggle: ToggleButton = new ToggleButton();
		parent.addChild(toggle);
		toggle.isSelected = isSelected;
		return toggle;
	}


	public static function createToggleSwitch(parent: DisplayObjectContainer, offText: String, onText: String, isSelected: Boolean = false): ToggleSwitch {
		var toggle: ToggleSwitch = new ToggleSwitch();
		parent.addChild(toggle);
		toggle.onText = onText;
		toggle.offText = offText;
		toggle.isSelected = isSelected;
		return toggle;
	}

	// static layouts
	public static function createHorizontalLayout(gap: int, padding: int = NaN): HorizontalLayout {
		var layout: HorizontalLayout = new HorizontalLayout();
		layout.gap = gap;
		if( padding )
			layout.padding = padding;
		return layout;
	}

	public static function createVerticalLayout(gap: int, padding: int = NaN): VerticalLayout {
		var layout: VerticalLayout = new VerticalLayout();
		layout.gap = gap;
		if( padding )
			layout.padding = padding;
		return layout;
	}

	public static function createHorizontalGroup(gap: int, padding: int = NaN): LayoutGroup {
		var group: LayoutGroup = new LayoutGroup();
		group.layout = RapidFeathers.createHorizontalLayout(gap, padding);
		return group;
	}
	public static function createVerticalGroup(gap: int, padding: int = NaN): LayoutGroup {
		var group: LayoutGroup = new LayoutGroup();
		group.layout = RapidFeathers.createVerticalLayout(gap, padding);
		return group;
	}

}
}
