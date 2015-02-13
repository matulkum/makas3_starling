/**
 * Created with IntelliJ IDEA.
 * User: mak
 * Date: 20.07.13
 * Time: 19:25
 * To change this template use File | Settings | File Templates.
 */
package de.creativetechnologist.starling.video {

import de.creativetechnologist.video.LocalNetStream;

import flash.display.Stage;
import flash.events.AsyncErrorEvent;
import flash.events.NetStatusEvent;
import flash.geom.Rectangle;
import flash.media.StageVideo;
import flash.net.NetStream;

import org.osflash.signals.Signal;

public class SimpleStageVideo {

	private var flashStage: Stage;

	protected var netStream: NetStream;

	private var _signal: Signal;

    private var _loop:Boolean = false;

    private var  currentUrl: String;

	public static const EVT_PLAY: String = 'EVT_PLAY';
	public static const EVT_STOP: String = 'EVT_STOP';

	public function get signal(): Signal {return _signal;}



	public function SimpleStageVideo( flashStage: Stage, netStream: NetStream = null) {
        this.flashStage = flashStage;
		this.netStream = netStream ? netStream : new LocalNetStream();

		this.netStream.addEventListener(NetStatusEvent.NET_STATUS, onStreamNetStatus);
		this.netStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onStreamAsyncError);
		this.netStream.client = this;

		_signal = new Signal();
	}


	public function play(url: String, viewPort: Rectangle, loop: Boolean = false): NetStream {

        currentUrl = url;
        _loop = loop;

		var video: StageVideo = flashStage.stageVideos[0];

        video.viewPort = viewPort;
//		if ( !video.viewPort ) {
//            video.viewPort = viewPort;
//        }
//        else {
//            video.viewPort.x = viewPort.x;
//            video.viewPort.y = viewPort.y;
//            video.viewPort.width = viewPort.width;
//            video.viewPort.height = viewPort.height;
//        }
		video.attachNetStream(netStream);
		netStream.play(url, 0);
		signal.dispatch(this, EVT_PLAY);

		return netStream;
	}

    public function onMetaData(info: Object): void {}

    public function onPlayStatus(info: Object): void {
//        trace("78:: SimpleStageVideo->onPlayStatus(): " );
        if (_loop && info.code == "NetStream.Play.Complete") {
			netStream.play(currentUrl, 0);
        }
    }

    public function onXMPData(info: Object): void {}
    public function onImageData(info: Object): void {}

    public function onTextData(info: Object): void {}

    public function onSeekPoint(info: Object): void {}


    public function onCuePoint(info: Object):void {
        trace("79:: SimpleStageVideo->onCuePoint(): " );
    }


    public function stop(): void {
        flashStage.stageVideos[0].attachNetStream(null);
		netStream.close();
		signal.dispatch(this, EVT_STOP);
    }

    public function destroy(): void {
		netStream.dispose();
    }

	private function onStreamNetStatus(event:NetStatusEvent):void {
        if (event.info.code == "NetStream.Play.Stop") {
            signal.dispatch(this, EVT_STOP);
        }
	}

	private function onStreamAsyncError(event:AsyncErrorEvent):void {
        trace("62:: SimpleStageVideo->onStreamAsyncError(): ", event );

	}

}
}
