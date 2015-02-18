/**
 * Created by mak on 18.02.15.
 */
package de.creativetechnologist.feathers.components {
import feathers.core.FeathersControl;

public class VideoImage extends FeathersControl {

	private var url: String;

	public function VideoImage(url: String) {
		this.url = url;
		_minWidth = 100;
		_minHeight = 75;
		super();
	}


	override protected function initialize(): void {
		trace("VideoImage->initialize() :: " );
		super.initialize();
	}


	override protected function setSizeInternal(width: Number, height: Number, canInvalidate: Boolean): Boolean {
		trace("VideoImage->setSizeInternal() :: ", width, height, canInvalidate );
		return super.setSizeInternal(width, height, canInvalidate);
	}


	override protected function draw(): void {
		trace("VideoImage->draw() :: ", explicitWidth, _minWidth );
		super.draw();
	}

}
}
