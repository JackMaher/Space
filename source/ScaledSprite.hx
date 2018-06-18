package;

import flixel.FlxSprite;

class ScaledSprite {

    public static var Scale:Int = 10;

    public static function scaleUp(obj:FlxSprite) {
        obj.origin.set(0,0);
        obj.scale.set(Scale,Scale);
    }

}
