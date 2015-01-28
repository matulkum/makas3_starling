/**
 * Created by mak on 10.05.14.
 */
package de.creativetechnologist.feathers {
import feathers.controls.Label;
import feathers.controls.LayoutGroup;
import feathers.controls.TextInput;
import feathers.layout.VerticalLayout;

public class TextInputWithLabel extends LayoutGroup {

	public var labelComponent: Label;
	public var textInput: TextInput;

	public function set label(value: String): void { labelComponent.text = value;}

	public function get text(): String { return textInput.text;}
	public function set text(value: String): void { textInput.text = value;}


	public function TextInputWithLabel(labelText: String = '', text: String = '') {
		super();

		layout = new VerticalLayout();

		labelComponent = new Label();
		labelComponent.text = labelText;
		addChild(labelComponent);

		textInput = new TextInput();
		if( text != '')
			textInput.text = text;

		addChild(textInput);
	}

}
}
