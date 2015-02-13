/**
 * Created by mak on 13.02.15.
 */
package de.creativetechnologist.feathers.scene {
import feathers.controls.Screen;

import starling.display.Stage;
import starling.events.ResizeEvent;

public class SceneController {

	internal var _owner: SceneNavigator;
	public function get owner(): SceneNavigator {return _owner;}

	protected var _screen: Screen;
	public function get screen(): Screen {return _screen;}


	protected var starlingStage: Stage;


	public function SceneController(screen: Screen) {
		this._screen = screen;
	}


	public function dispose(): void {
		if( starlingStage )
			starlingStage.removeEventListener(ResizeEvent.RESIZE, onStarlingStageResize);
	}


	public function setFullscreen(starlingStage: Stage, autoOrient: Boolean = true): void {
		this.starlingStage = starlingStage;
		onStarlingStageResize(null);

		if( autoOrient ) {
			starlingStage.addEventListener(ResizeEvent.RESIZE, onStarlingStageResize);
		}
	}


	public function onShow(): void {
		trace("SceneController->onShow() :: " );
	}


	private function onStarlingStageResize(event: ResizeEvent): void {
		_screen.width = starlingStage.stageWidth;
		_screen.height = starlingStage.stageHeight;
		_screen.validate();
	}


}
}
