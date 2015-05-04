/**
 * Created by mak on 09/04/15.
 */
package de.creativetechnologist.starling.view {
import fl.text.TLFTextField;

import flash.display.BitmapData;

import starling.display.Image;
import starling.textures.Texture;

public class TLFImage extends Image {

	protected var tlfTextfield: TLFTextField;

	public function TLFImage(tlfTextfield: TLFTextField) {
		this.tlfTextfield = tlfTextfield;
		super(drawTexture(tlfTextfield));
	}


	public function updateText(text: String): void {
		if( text == tlfTextfield.text )
			return;
		tlfTextfield.text = text;
		texture = drawTexture(tlfTextfield);
	}

	public function updateHTMLText(text: String): void {
		if( text == tlfTextfield.htmlText )
			return;
		tlfTextfield.htmlText = text;
		texture = drawTexture(tlfTextfield);
		readjustSize();
	}


	override public function get width(): Number {
		if( tlfTextfield )
			return tlfTextfield.textWidth;
		return super.width;
	}

	protected static function drawTexture(tlfTextfield: TLFTextField): Texture {
		var bd: BitmapData = new BitmapData(tlfTextfield.width, tlfTextfield.height, true, 0x00000000);
		bd.draw(tlfTextfield);
		var texture: Texture = Texture.fromBitmapData(bd);
		bd.dispose();
		return texture;
	}
}
}
