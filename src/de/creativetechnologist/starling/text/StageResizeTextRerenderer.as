/**
 * Created by mak on 09/03/15.
 */
package de.creativetechnologist.starling.text {

import starling.display.Stage;
import starling.events.ResizeEvent;
import starling.text.TextField;

public class StageResizeTextRerenderer {

    private static var txts: Vector.<TextField>

    public function StageResizeTextRerenderer() {
    }

    public static function init(stage: Stage):void {
        if( txts ) {
            trace('WARINING: ignoring init() because initialized already!');
            return;
        }

        txts = new <TextField>[];
        stage.addEventListener(ResizeEvent.RESIZE, onStageResize);
    }

    public static function addTextfield(textfield: TextField): TextField {
        txts.push(textfield);
        return textfield;
    }

    private static function onStageResize(event:ResizeEvent):void {
        var i:int;
        var length: int = txts.length;
        var txt: TextField;
        var tmp: String;
        for(i=0; i < length; i++) {
            txt = txts[i];
            tmp = txt.text;
            txt.text = '';
            txt.text = tmp;
        }
    }
}
}
