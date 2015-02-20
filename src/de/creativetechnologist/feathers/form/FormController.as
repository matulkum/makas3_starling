/**
 * Created by mak on 18.02.15.
 */
package de.creativetechnologist.feathers.form {
import feathers.controls.Check;
import feathers.controls.IRange;
import feathers.controls.Label;
import feathers.controls.Radio;
import feathers.controls.TextInput;
import feathers.core.FeathersControl;
import feathers.core.IToggle;
import feathers.core.ToggleGroup;
import feathers.events.FeathersEventType;

import flash.utils.Dictionary;

import starling.events.Event;

public class FormController {

	private var _dataModel: *;

	private var inputs: Vector.<TextInput>;

	private var propertyName_to_label: Dictionary;
	private var propertyName_to_textInput: Dictionary;
	private var propertyName_to_toggle: Dictionary;
	private var propertyName_to_range: Dictionary;

	// radio
	private var groupName_to_toggleGroup: Dictionary;

	// validators
	private var control_to_validators: Dictionary;

	private var _invalids: Vector.<FeathersControl>;
	public function get invalids(): Vector.<FeathersControl> {return _invalids;}

	private var invalids_to_errorMessage: Dictionary;


	// for Fethare Themes
	public static const STYLE_INVALID: String = 'STYLE_INVALID';



	public function FormController(dataModel: Object = null) {
		this._dataModel = dataModel;
		_invalids = new <FeathersControl>[];
	}


	public function dispose(): void {
		if( control_to_validators ) {
			for(var control: FeathersControl in control_to_validators ) {
				control.removeEventListener(Event.CHANGE, onControlChangeWhileInvalid);
			}
			control_to_validators = null;
		}

		propertyName_to_label = null;
		propertyName_to_textInput = null;
		propertyName_to_toggle = null;
		groupName_to_toggleGroup = null;
		invalids_to_errorMessage = null;

		var i: int;
		var length: int = inputs.length;
		for (i = 0; i < length; i++) {
			inputs[i].removeEventListener(FeathersEventType.ENTER, onTextInputEnter);
		}
	}


	public function get dataModel(): * {return _dataModel;}

	public function set dataModel(value: *): void {
		if( value == _dataModel )
			return;

		_dataModel = value;
		applyDataModelToUI();
	}



	// texts


	public function addLabel(label: Label, propertyName: String): void {
		addLabelToDataModel(label, propertyName);
	}


	public function addTextInput(input: TextInput, propertyName: String = null, validators: Vector.<IValidator> = null): TextInput {
		addTextInputToDataModel(input, propertyName);
		if( validators ) {
			if( !control_to_validators ) {
				control_to_validators = new Dictionary();
			}
			control_to_validators[input] = validators;
		}

		if( !inputs )
			inputs = new <TextInput>[];
		inputs.push(input);
		input.addEventListener(FeathersEventType.ENTER, onTextInputEnter);
		return input;
	}

	protected function onTextInputEnter(event: Event): void {
		var input: TextInput = event.target as TextInput;
		var index: int = inputs.indexOf(input);
		if( index < inputs.length-1)
			inputs[index+1].setFocus();
	}


	// Toggles

	public function addCheck(toggle: Check, dataModelProperty: String = null): Check {
		if( dataModelProperty )
			addToggleToDataModel(toggle, dataModelProperty);
		return toggle;
	}


	public function addRadio(radio: Radio, groupName: String, dataModelProperty: String = null): Radio {
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


	// ranges

	public function addRange(range: IRange, propertyName: String = null): IRange {
		if( propertyName ) {
			addRangeToDataModel(range, propertyName);
		}
		return range;
	}




	// adding to datamodel

	public function addLabelToDataModel(label: Label, propertyName: String): Label {
		if( !propertyName )
			return label;

		if( !propertyName_to_label )
			propertyName_to_label = new Dictionary();

		propertyName_to_label[propertyName] = label;
		if( _dataModel) {
			try {
				label.text = _dataModel[propertyName];
			}
			catch(e: Error) {
				trace("WARNING, propertyName "+propertyName+" could not be applied to field"  );
			}
		}
		return label;
	}

	public function addTextInputToDataModel(input: TextInput, propertyName: String): TextInput {
		if( !propertyName )
			return input;

		if( !propertyName_to_textInput )
			propertyName_to_textInput = new Dictionary();

		propertyName_to_textInput[propertyName] = input;
		if( _dataModel) {
			try {
				input.text = _dataModel[propertyName];
			}
			catch(e: Error) {
				trace("WARNING, propertyName "+propertyName+" could not be applied to field"  );
			}
		}
		return input;
	}


	public function addToggleToDataModel(toggle: IToggle, propertyName: String): IToggle {
		if( !propertyName_to_toggle )
			propertyName_to_toggle = new Dictionary();

		propertyName_to_toggle[propertyName] = toggle;
		if( _dataModel ) {
			try {
				toggle.isSelected = Boolean(_dataModel[propertyName]);
			}
			catch(e: Error) {
				trace("addTextInputToDataModel() :: WARNING, propertyName "+propertyName+" could not be applied to field"  );
			}
		}
		return toggle;
	}


	public function addRangeToDataModel(range: IRange, propertyName: String): IRange {
		if( !propertyName_to_range )
			propertyName_to_range = new Dictionary();

		propertyName_to_range[propertyName] = range;
		if( _dataModel ) {
			try {
				range.value = Number(_dataModel[propertyName]);
			}
			catch(e: Error) {
				trace("addRangeToDataModel() :: WARNING, propertyName "+propertyName+" could not be applied to field"  );
			}
		}
		return range;
	}


	public function validate(): Boolean {
		invalids_to_errorMessage = new Dictionary();
		invalids.length = 0;
		var i: int;
		var length: int;
		var allValid: Boolean = true;
		for( var control: FeathersControl in control_to_validators ) {
			var validators: Vector.<IValidator> = control_to_validators[control];
			if( validators ) {
				length = validators.length;
				for(i = 0; i < length; i++) {
					var value: *;
					if( control is TextInput )
						value = TextInput(control).text;

					if( !validators[i].validate(value) ) {
						invalids_to_errorMessage[control] = validators[i].getInvalidMessage();
						invalids.push(control);
						addInvalidStyleToControl(control);
						allValid = false;
					}
				}

			}

		}
		return allValid;
	}


	private function addInvalidStyleToControl(control: FeathersControl): FeathersControl {
		control.styleNameList.add(FormController.STYLE_INVALID);
		control.addEventListener(Event.CHANGE, onControlChangeWhileInvalid);
		return control;
	}


	private function onControlChangeWhileInvalid(event: Event): void {
		var control: FeathersControl = event.target as FeathersControl;
		control.removeEventListener(Event.CHANGE, onControlChangeWhileInvalid);
		control.styleNameList.remove(FormController.STYLE_INVALID);
	}


	public function getErrorMessageFor(control: FeathersControl): String {
		if( !invalids_to_errorMessage )
			return null;

		return invalids_to_errorMessage[control];
	}


	// applying datamodel
	public function applyToDataModel(): void {
		if( !_dataModel )
			return;

		var propertyName: String;
		for(propertyName in propertyName_to_textInput) {
			_dataModel[propertyName] = TextInput(propertyName_to_textInput[propertyName]).text;
		}
		for(propertyName in propertyName_to_toggle) {
			_dataModel[propertyName] = Boolean(IToggle(propertyName_to_toggle[propertyName]).isSelected);
		}
		for(propertyName in propertyName_to_range) {
			_dataModel[propertyName] = Number(IRange(propertyName_to_range[propertyName]).value);
		}
	}


	public function applyDataModelToUI(): void {
		if( !_dataModel )
			return;

		var propertyName: String;
		for(propertyName in propertyName_to_label) {
			Label(propertyName_to_label[propertyName]).text = _dataModel[propertyName];
		}
		for(propertyName in propertyName_to_textInput) {
			TextInput(propertyName_to_textInput[propertyName]).text = _dataModel[propertyName];
		}
		for(propertyName in propertyName_to_toggle) {
			IToggle(propertyName_to_toggle[propertyName]).isSelected = Boolean(_dataModel[propertyName]);
		}
		for(propertyName in propertyName_to_range) {
			IRange(propertyName_to_range[propertyName]).value = Number(_dataModel[propertyName]);
		}
	}

}
}
