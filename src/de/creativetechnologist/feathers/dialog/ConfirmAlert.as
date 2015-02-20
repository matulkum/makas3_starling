/**
 * Created by mak on 20.02.15.
 */
package de.creativetechnologist.feathers.dialog {
import feathers.controls.Alert;
import feathers.data.ListCollection;

import org.osflash.signals.Signal;

import starling.events.Event;

public class ConfirmAlert {

	//(this, ok: Boolean)
	public var signal: Signal;

	public function ConfirmAlert() {
		signal = new Signal(ConfirmAlert, Boolean);
	}


	public function dispose(): void {
		signal.removeAll();
	}

	public function show(message: String, title: String = null, okLabel: String = "OK", cancelLabel: String = "Cancel"): ConfirmAlert {
		Alert.show(message, title, new ListCollection(
			[
				{
					label: okLabel,
					triggered: onOKTriggered
				},
				{
					label: cancelLabel,
					triggered: onCancelTriggered
				}
			]
		));
		return this;
	}


	public function onOKTriggered(event: Event): void {
		signal.dispatch(this, true);
	}

	public function onCancelTriggered(event: Event): void {
		signal.dispatch(this, false);
	}
}
}
