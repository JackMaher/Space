package;

import flixel.FlxG;
import flixel.FlxSprite;
import ShipPower;
using flixel.util.FlxSpriteUtil;
using flixel.util.FlxColor;
using ScaledSprite;

class Laser extends FlxSprite {

    public function new(xPos:Int,yPos:Int, team:Team) {
        super();

        makeGraphic(14,5,0x00000000,true);

        this.drawLine(0,height,width,0,{color:FlxColor.CYAN,thickness:3});
        scaleUp();

        x = xPos * ScaledSprite.Scale;
        y = yPos * ScaledSprite.Scale;

        if(team == ENEMY) {
            velocity.x = -width * 200;
            velocity.y = height * 200;
        }
        else {
            x -= width * ScaledSprite.Scale;
            velocity.x = width * 200;
            velocity.y = -height * 200;
        }
    }

}
