/**
 * Created by mak on 26.01.15.
 */
package de.creativetechnolgist.starling.ringDisplay {
import starling.display.DisplayObject;
import starling.display.Sprite3D;

public class RingDisplayItem3D extends RingDisplayItem {

	private var sprite3d: Sprite3D;

	public function RingDisplayItem3D(view: DisplayObject) {
		sprite3d = new Sprite3D();
		sprite3d.alignPivot();
		_width = view.width;
		view.x = -_width >> 1;
		sprite3d.x = -view.x;

		sprite3d.addChild(view);
		super(sprite3d);
	}


	override public function dispose(): void {
		sprite3d.dispose();
		super.dispose();
	}


	[Inline]
	override protected function updateViewTranslation(slideRatio: Number): void {
		sprite3d.x = _width*2.5 * slideRatio + _width >> 1;
		sprite3d.rotationY = Math.PI / 2 * slideRatio;
//		sprite3d.z = 800 * Math.abs(slideRatio);
	}
}
}
