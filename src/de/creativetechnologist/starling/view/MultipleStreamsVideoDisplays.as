/**
 * Created by mak on 16/04/15.
 */
package de.creativetechnologist.starling.view {
import flash.net.NetStream;

import starling.display.Sprite;

public class MultipleStreamsVideoDisplays extends Sprite {

	private var streams: Vector.<NetStream>;
	private var streamsLength: int = 0;

	private var displays: Vector.<VideoDisplay>;
	private var currentDisplay: VideoDisplay;


	private var ii: int;


	public function MultipleStreamsVideoDisplays(streams: Vector.<NetStream>, width: int, height: int) {
		super();
		this.streams = streams;
		streamsLength = streams.length;

		displays = new <VideoDisplay>[];
		for(ii = 0; ii < streamsLength; ii++) {
			var videoDisplay: VideoDisplay = new VideoDisplay(streams[ii], width, height);
			videoDisplay.signalTextureReady.add(onTextureReady);
			displays.push(videoDisplay);
		}
	}

	private function onTextureReady(target: VideoDisplay): void {
		if( currentDisplay )
			removeChild(currentDisplay);
		currentDisplay = target;
		addChild(currentDisplay);
	}

}
}
