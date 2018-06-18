package;

import flixel.FlxG;
import flixel.FlxSprite;
using flixel.util.FlxSpriteUtil;
using flixel.util.FlxColor;
using ScaledSprite;

class Laser extends FlxSprite {

    public function new() {
        super();

        makeGraphic(14,7,0x00000000,true);

        this.drawLine(0,height,width,0,{color:FlxColor.CYAN,thickness:3});

        scaleUp();
    }

}
