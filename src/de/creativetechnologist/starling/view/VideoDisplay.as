/**
 * Created by mak on 15/04/15.
 */
package de.creativetechnologist.starling.view {
import flash.display3D.Context3DTextureFormat;
import flash.display3D.textures.VideoTexture;
import flash.events.Event;
import flash.events.NetStatusEvent;
import flash.events.StatusEvent;
import flash.net.NetStream;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import org.osflash.signals.Signal;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.ConcreteTexture;
import starling.textures.Texture;

public class VideoDisplay extends Sprite{

	protected var _netStream: NetStream;
	public function get netStream(): NetStream {return _netStream;}

	protected var videoTexture: VideoTexture;
	protected var concreteVideoTexture: ConcreteTexture;
	protected var videoImage: Image;

	public var idleImage: DisplayObject;

	public var hideOnPause: Boolean = false;

	private var _isTextureReady: Boolean;
	public var signalTextureReady: Signal;

	private var rescueTimeoutID: uint;


	public function get isTextureReady(): Boolean {return _isTextureReady;}


	public function VideoDisplay(netStream: NetStream, width: int, height: int, idleImage: DisplayObject = null) {
		super();

		this._netStream = netStream;

		signalTextureReady = new Signal();

//		this.width = width;
//		this.height = height;

		videoTexture = Starling.context.createVideoTexture();
		concreteVideoTexture = new ConcreteTexture(videoTexture, Context3DTextureFormat.BGRA, width, height, false, true, true);
		concreteVideoTexture.attachNetStream(netStream);

		videoImage = new Image(concreteVideoTexture);
		addChild(videoImage);

		this.idleImage = idleImage;
		if( idleImage ) {
			addChild(idleImage);
		}

		netStream.addEventListener(StatusEvent.STATUS, onNetStreamStatus);
		netStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatusEvent);

	}


	public function closeNetStream(): void {
		netStream.close();
		if( idleImage )
			removeChild(videoImage);
	}


	protected function onNetStatusEvent(event: NetStatusEvent): void {
//		trace( 'VideoDisplay -> onNetStatusEvent: ', event.info.code );
		if( event.info.code == 'NetStream.Buffer.Full') {
			_isTextureReady = false;
			if( idleImage )
				removeChild(videoImage);
			videoTexture.addEventListener(Event.TEXTURE_READY, onTextureReady);

			rescueTimeoutID = setTimeout(function():void{
			    onTextureReady(null)
			}, 2000);
		}
//		else if( event.info.code == 'NetStream.SeekStart.Notify') {
//		}
	}

	protected function onTextureReady(event: Event): void {
		clearTimeout(rescueTimeoutID);

		if( idleImage ) {
			videoImage.alpha = 0;
			addChild(videoImage);
			Starling.juggler.tween(videoImage, .25, {alpha: 1});
		}
		videoTexture.removeEventListener(Event.TEXTURE_READY, onTextureReady);
		_isTextureReady = true;
		signalTextureReady.dispatch(this);
	}


	protected function onNetStreamStatus(item: Object): void {
	}
}
}
