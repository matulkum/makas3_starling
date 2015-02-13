/**
 * Created by mak on 13.02.15.
 */
package de.creativetechnologist.feathers.scene {
import feathers.controls.ScreenNavigator;
import feathers.controls.ScreenNavigatorItem;
import feathers.events.FeathersEventType;

import flash.utils.Dictionary;

import starling.display.Sprite;
import starling.events.Event;

public class SceneNavigator extends Sprite {


	private var _screenNavigator: ScreenNavigator;
	public function get screenNavigator(): ScreenNavigator {return _screenNavigator;}

	protected var sceneControllers: Vector.<SceneController>;

	protected var id_to_sceneController: Dictionary;
	protected var screen_to_sceneController: Dictionary;

	public function SceneNavigator() {
		super();
		sceneControllers = new <SceneController>[];

		id_to_sceneController = new Dictionary();
		screen_to_sceneController = new Dictionary();

		_screenNavigator = new ScreenNavigator();
		_screenNavigator.addEventListener(FeathersEventType.TRANSITION_COMPLETE, onScreenNavigatorTransitionComplete);
	}


	private function onScreenNavigatorTransitionComplete(event: Event): void {
		var sceneController: SceneController = screen_to_sceneController[_screenNavigator.activeScreen] as SceneController	;
		if(sceneController)
			sceneController.onShow();
	}


	public function addSceneController(id: String, sceneController: SceneController): SceneController {

		try {
			_screenNavigator.addScreen(id, new ScreenNavigatorItem(sceneController.screen));
		}
		catch(e: Error ) {
			throw new Error('could not add scene! id is unique?');
			return null;
		}
		id_to_sceneController[id] = sceneController;
		screen_to_sceneController[sceneController.screen] = sceneController;
		sceneControllers.push(sceneController);
		sceneController._owner = this;
		return sceneController;
	}


	public function showSceneByID(id: String): void {
//		var sceneController: SceneController = id_to_sceneController[id];
//		if( !sceneController ) {
//			throw new Error('scene id not found!');
//			return null;
//		}
		_screenNavigator.showScreen(id);
	}

}
}
