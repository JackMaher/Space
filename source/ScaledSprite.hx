package;

import flixel.FlxSprite;

class ScaledSprite {

    public static function scaleUp(obj:FlxSprite) {
        obj.origin.set(0,0);
        obj.scale.set(10,10);
    }

}
