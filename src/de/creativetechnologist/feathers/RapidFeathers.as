/**
 * Created by mak on 04.05.14.
 */
package de.creativetechnologist.feathers {
import feathers.controls.Button;
import feathers.controls.Check;
import feathers.controls.Label;
import feathers.controls.LayoutGroup;
import feathers.controls.NumericStepper;
import feathers.controls.Radio;
import feathers.controls.TextInput;
import feathers.controls.ToggleButton;
import feathers.controls.ToggleSwitch;
import feathers.core.IToggle;
import feathers.core.ToggleGroup;
import feathers.events.FeathersEventType;
import feathers.layout.HorizontalLayout;
import feathers.layout.TiledRowsLayout;
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
	private var propertyName_to_label: Dictionary;
	private var propertyName_to_textInput: Dictionary;
	private var propertyName_to_toggle: Dictionary;

	// radio
	private var groupName_to_toggleGroup: Dictionary;

	public static const C_PINK: uint = 0xff00ff;
	public static const C_RED: uint = 0xff0000;
	public static const C_RED_LIGHT: uint = 0xffacac;
	public static const C_ORANGE: uint = 0xffa200;
	public static const C_BLUE_NEON: uint = 0x00ffff;
	public static const C_BLUE_LIGHT: uint = 0x96beff;
	public static const C_YELLOW: uint = 0xffff00;
	public static const C_GREEN: uint = 0x00ff00;
	public static const C_GREEN_LIGHT: uint = 0xcaffca;

	public function RapidFeathers(targetContainer: DisplayObjectContainer, dataModel: * = null) {
		this.targetContainer = targetContainer;
		this.dataModel = dataModel;
		textFields = new <TextField>[];
	}


	public function createBtn(label: String): Button {
		return RapidFeathers.createBtn(targetContainer, label, null);
	}



	// texts
	public function createLabel(text: String = '', dataModelProperty: String = null): Label {
		var label: Label = RapidFeathers.createLabel(targetContainer, text);
		if( dataModelProperty ) {
			try {
				if( dataModel && dataModel[dataModelProperty] )
					label.text = dataModel[dataModelProperty];
			}
			catch(e: Error) {
				trace("Rapid->addTextInputToDataModel() :: WARNING, propertyName "+dataModelProperty+" not found on dataModel"  );
			}

			if( !propertyName_to_label )
				propertyName_to_label = new Dictionary();
			propertyName_to_label[dataModelProperty] = label;
		}
		return label;
	}


	public function createTextInput(text: String, dataModelProperty: String = null): TextInput {
		var textInput: TextInput = RapidFeathers.createTextInput(targetContainer, text);
		if( dataModelProperty ) {
			addTextInputToDataModel(textInput, dataModelProperty );
			if( dataModel && dataModel[dataModelProperty] )
				textInput.text = dataModel[dataModelProperty];
		}
		textInput.addEventListener(FeathersEventType.ENTER, onTextInputEnter);
		textInput.padding = 0;
		textInput.gap = 0;
		return textInput;
	}


	public function createTextInputWithLabel(labelText: String, text: String, dataModelProperty: String = null): TextInputWithLabel {
		var textInputWithLabel: TextInputWithLabel = RapidFeathers.createTextInputWithLabel(targetContainer, labelText, text);
		if( dataModelProperty ) {
			addTextInputToDataModel(textInputWithLabel.textInput, dataModelProperty );
			if( dataModel && dataModel[dataModelProperty] )
				textInputWithLabel.text = dataModel[dataModelProperty];
		}
		textInputWithLabel.textInput.addEventListener(FeathersEventType.ENTER, onTextInputEnter);
		return  textInputWithLabel;
	}


	protected function onTextInputEnter(event: Event): void {
		trace("RapidFeathers->onTextInputEnter() :: " );
		TextInput(event.target).clearFocus();
	}


	// toggles
	public function createToggleSwitch(offText: String, onText: String, isSelected: Boolean = false, dataModelProperty: String = null): ToggleSwitch {
		var toogle: ToggleSwitch = RapidFeathers.createToggleSwitch( targetContainer, offText, onText, isSelected);
		if( dataModelProperty )
			addToggleToDataModel(toogle, dataModelProperty);
		return toogle;
	}

	public function createCheck(label: String, isSelected: Boolean = false, dataModelProperty: String = null): Check {
		var toggle: Check = RapidFeathers.createCheck( targetContainer, label, isSelected);
		if( dataModelProperty )
			addToggleToDataModel(toggle, dataModelProperty);
		return toggle;
	}




	public function createRadio(label: String, groupName: String, isSelected: Boolean = false, dataModelProperty: String = null): Radio {
		var radio: Radio = RapidFeathers.createRadio( targetContainer, label, isSelected);

		if( groupName ) {
			var group: ToggleGroup;
			if( !groupName_to_toggleGroup )
				groupName_to_toggleGroup = new Dictionary();

			group = groupName_to_toggleGroup[groupName];
			if( !group ) {
				group = new ToggleGroup();
				groupName_to_toggleGroup[groupName] = group;
			}
			radio.toggleGroup = group;
		}
		if( dataModelProperty )
			addToggleToDataModel(radio, dataModelProperty);

		return radio;
	}


	// adding to datamodel
	protected function addTextInputToDataModel(input: TextInput, propertyName: String): void {
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


	protected function addToggleToDataModel(toggle: IToggle, propertyName: String): void {
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


	// applying datamodel
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
		for(propertyName in propertyName_to_label) {
			Label(propertyName_to_label[propertyName]).text = dataModel[propertyName];
		}
		for(propertyName in propertyName_to_textInput) {
			TextInput(propertyName_to_textInput[propertyName]).text = dataModel[propertyName];
		}
		for(propertyName in propertyName_to_toggle) {
			IToggle(propertyName_to_toggle[propertyName]).isSelected = Boolean(dataModel[propertyName]);
		}
	}




	// statics

	// text

	public static function createBtn(parent: DisplayObjectContainer, label: String, triggerHandler: Function = null, styleName: String = null): Button {
		var button: Button = new Button();
		button.label = label;
		if( parent ) {
			parent.addChild(button);
		}
		if( triggerHandler )
			button.addEventListener(Event.TRIGGERED, triggerHandler);

		if( styleName )
			button.styleNameList.add(styleName);
		return button;
	}

	public static function createLabel(parent: DisplayObjectContainer, text: String = '', styleName: String = null): Label {
		var label: Label = new Label();
		if( text != '')
			label.text = text;

		if( styleName )
			label.styleNameList.add(styleName);
		if( parent )
			parent.addChild(label);
		return label;
	}

	public static function createTextField(parent: DisplayObjectContainer, text: String = '', color: uint = 0): TextField {
		var txt: TextField = new TextField(14,14, text);
		txt.color = color;
		txt.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
		if( parent )
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

	public static function createToggleButton(parent: DisplayObjectContainer, label: String, isSelected: Boolean = false): ToggleButton {
		var toggle: ToggleButton = new ToggleButton();
		toggle.label = label;
		toggle.isSelected = isSelected;
		if( parent )
			parent.addChild(toggle);
		return toggle;
	}


	public static function createToggleSwitch(parent: DisplayObjectContainer, offText: String, onText: String, isSelected: Boolean = false): ToggleSwitch {
		var toggle: ToggleSwitch = new ToggleSwitch();
		toggle.onText = onText;
		toggle.offText = offText;
		toggle.isSelected = isSelected;
		if( parent )
			parent.addChild(toggle);
		return toggle;
	}

	public static function createCheck(parent: DisplayObjectContainer, label: String, isSelected: Boolean = false): Check {
		var toggle: Check = new Check();
		toggle.label = label;
		toggle.isSelected = isSelected;
		if( parent )
			parent.addChild(toggle);
		return toggle;
	}

	public static function createRadio(parent: DisplayObjectContainer, label: String, isSelected: Boolean = false): Radio {
		var radio: Radio = new Radio();
		radio.label = label;
		radio.isSelected = isSelected;
		if( parent )
			parent.addChild(radio);
		return radio;
	}

	// ranges
	public static function createNumericStepper(parent: DisplayObjectContainer, min: Number, max: Number, step: Number): NumericStepper {
		var stepper: NumericStepper = new NumericStepper();
		stepper.minimum = min;
		stepper.maximum = max;
		stepper.step = step;
		if( parent )
			parent.addChild(stepper);
		return stepper;
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

	public static function createTiledRowsLayout(gap: int, padding: int = NaN): TiledRowsLayout {
		var layout: TiledRowsLayout = new TiledRowsLayout();
		layout.gap = gap;
		layout.padding = padding;
		return layout;
	}


	// static layoutGroups
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

	public static function createTiledRowsGroup(gap: int, padding: int = NaN, colCount: int = NaN): LayoutGroup {
		var group: LayoutGroup = new LayoutGroup();
		var layout: TiledRowsLayout = RapidFeathers.createTiledRowsLayout(gap, padding);
		layout.requestedColumnCount = colCount;
		group.layout = layout;
		return group;
	}


}
}
