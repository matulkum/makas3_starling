/**
 * Created by mak on 10/03/15.
 */
package de.creativetechnologist.starling.view {
import starling.display.Quad;
import starling.display.QuadBatch;
import starling.display.Sprite;

public class SimpleProgressbar extends Sprite {

    public var color: uint;
    public var barWidth: int;
    public var barHeight: int;
    public var thickness: int;

    private var background: QuadBatch;
    private var bar: Quad;

    public function SimpleProgressbar(width: int = 100, height: int= 8, color: uint = 0xffffff, thickness: int = 2) {
        super();
        this.thickness = Math.max(1,thickness);
        this.barWidth =  Math.max(thickness*5, width);
        this.barHeight =  Math.max(thickness*5, height);
        this.color =  color;

        background = new QuadBatch();
        var quad:Quad;

        // north
        quad = new Quad(this.barWidth, this.thickness, this.color);
        background.addQuad(quad);
        // south
        quad.y = this.barHeight - this.thickness;
        background.addQuad(quad);
        //west
        quad = new Quad(this.thickness, this.barHeight, this.color);
        background.addQuad(quad);
        // east
        quad.x = this.barWidth - this.thickness;
        background.addQuad(quad);

        bar = new Quad(this.barWidth - thickness * 4, this.barHeight - thickness * 4, this.color);
        bar.x = bar.y = this.thickness * 2;

        bar.scaleX = 0;
        addChild(background);
        addChild(bar);
    }


    public function set progress(value: Number): void {bar.scaleX = value;}
    public function get progress(): Number {return bar.scaleX;}
}
}
