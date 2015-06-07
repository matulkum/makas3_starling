/**
 * Created by mak on 19/03/15.
 */
package de.creativetechnologist.feathers {
import feathers.controls.text.TextBlockTextRenderer;

import starling.display.Image;
import starling.filters.BlurFilter;

public class TextBlockTextRendererWithShadow extends TextBlockTextRenderer {

	private var shadowLabel: Image;
	protected var _hasShadow: Boolean = false;

	public function TextBlockTextRendererWithShadow() {
		super();
	}


	override protected function refreshSnapshot(): void {
		var needsNewTexture: Boolean = this._needsNewTexture;
		super.refreshSnapshot();
		if( textSnapshot && needsNewTexture ) {
			if( shadowLabel )
				shadowLabel.dispose();
			shadowLabel = new Image(textSnapshot.texture);
			shadowLabel.filter = BlurFilter.createDropShadow(2, Math.PI/2,0,.5, 0);
			shadowLabel.x = textSnapshot.x;
			shadowLabel.y = textSnapshot.y;
		}
	}






	public function set hasShadow(value: Boolean): void {
		if( _hasShadow == value )
			return;
		_hasShadow = value;

		if( textSnapshot && shadowLabel ) {
			if( value ) {
				textSnapshot.removeFromParent();
				addChild(shadowLabel);
			}
			else {
				shadowLabel.removeFromParent();
				addChild(textSnapshot);
			}
		}
	}
	public function get hasShadow(): Boolean { return _hasShadow; }
}
}
