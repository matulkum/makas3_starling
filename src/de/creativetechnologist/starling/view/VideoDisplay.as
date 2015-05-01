/**
 * Created by mak on 15/04/15.
 */
package de.creativetechnologist.starling.view {
import flash.net.NetStream;

import starling.display.Image;

import starling.display.Sprite;

public class VideoDisplay extends Sprite {

	protected var videoImage: Image;

	public function VideoDisplay(netStream: NetStream, width: int, height: int) {

		this.width = width;
		this.height = height;

		netStream.client = this;


	}


	protected function onNetStreamStatus(item: Object): void {
		trace('onNetStreamStatus', item.info.code);
	}


	public function onXMPData(infoObject:Object):void {
		trace("LocalNetStream->onXMPData() :: ", infoObject );
	}


	public function onMetaData(metadata:Object): void {
		trace('onMetaData', metadata);
	}



}
}
