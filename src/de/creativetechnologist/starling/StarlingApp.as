/**
 * Created by mak on 21.02.15.
 */
package de.creativetechnologist.starling {
import flash.display.Sprite;
import flash.display.Stage;
import flash.display3D.Context3DProfile;
import flash.events.UncaughtErrorEvent;
import flash.geom.Rectangle;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.events.Event;
import starling.events.ResizeEvent;

public class StarlingApp extends Sprite {

    public static var PROFILE: String;
	public static var flashStage: Stage;

	protected var starlingRootClass: Class;

	public static var starling: Starling;
	public static var starlingRoot: DisplayObject;


	public function StarlingApp(starlingRootClass: Class) {
		super();
        if( !PROFILE )
            PROFILE = Context3DProfile.BASELINE_EXTENDED;

		this.starlingRootClass = starlingRootClass;
//		loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUnhandledErrors);

		setupFlashStage();
		setupStarling( starlingRootClass, createStarlingViewport());
		starling.start();
	}


	protected function setupFlashStage(): void {
		flashStage = stage;
		stage.frameRate = 60;
		stage.color = 0;
	}

	protected function createStarlingViewport(): Rectangle {
		return new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);
	}


	protected function setupStarling( rootClass: Class, viewPort: Rectangle): void {
		starling = new Starling(rootClass, stage, viewPort, null, 'auto', PROFILE);
//		starling.stage.stageWidth = 768;
//		starling.stage.stageHeight = 1024;
		starling.addEventListener(Event.ROOT_CREATED, onRootCreated);
		starling.stage.addEventListener(ResizeEvent.RESIZE, onStarlingStageResize);
	}


	protected function onRootCreated(event: Event): void {
		starlingRoot = Starling.current.root;
	}


	protected function onStarlingStageResize(event: ResizeEvent): void {
//		trace('e', event.width, event.height);
//		trace('s', stage.stageWidth, stage.stageHeight);
//		trace('f', stage.fullScreenWidth, stage.fullScreenHeight);
//		trace(' - ');
		starling.viewPort.width = event.width;
		starling.viewPort.height = event.height;
		starling.stage.stageWidth = starling.viewPort.width;
		starling.stage.stageHeight = starling.viewPort.height;
	}

	protected function onUnhandledErrors(event: UncaughtErrorEvent): void {

	}
}
}
