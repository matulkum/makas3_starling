/**
 * Created by mak on 01/04/15.
 */
package de.creativetechnologist.starling.classic {
import flash.display.MovieClip;

import starling.animation.IAnimatable;
import starling.animation.Juggler;
import starling.core.Starling;
import starling.events.Event;
import starling.events.EventDispatcher;

public class FlaMovieClipAnimator extends EventDispatcher implements IAnimatable{

	public var clip: MovieClip;
	private var fps: int;
	private var juggler: Juggler;

	private var _isPlaying: Boolean = false;
	public function get isPlaying(): Boolean { return _isPlaying; }


	public function FlaMovieClipAnimator(movieClip: MovieClip, fps: int = 60, juggler: Juggler = null) {
		movieClip.gotoAndStop(0);
		this.clip = movieClip;
		this.fps = fps;

		if( ! juggler )
			this.juggler = Starling.juggler;


	}

	public function play(): void {
		if( _isPlaying )
			return;
		_isPlaying = true;

		clip.gotoAndStop(1);
		juggler.add(this);
	}

	public function pause(): void {
		_isPlaying = false;
		juggler.remove(this);
	}

	public function stop(): void {
		if( !_isPlaying )
			return;
		pause();
		clip.gotoAndStop(1);
	}


	public function set currentFrame(value: int): void {
		clip.gotoAndStop(value);
	}
	public function get currentFrame(): int {
		return clip.currentFrame;
	}


	public function advanceTime(time: Number): void {
		if( !_isPlaying)
			return;

		var nextFrame: int = clip.currentFrame + Math.ceil(time * fps);

		if( nextFrame >= clip.totalFrames ) {
			clip.gotoAndStop(clip.totalFrames);
			pause();
			dispatchEventWith(Event.COMPLETE);
			return;
		}

		clip.gotoAndStop(nextFrame);
	}
}
}
