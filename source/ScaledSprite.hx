package;

import flixel.FlxSprite;

class ScaledSprite {

    public static var Scale:Int = 10;

    public static function scaleUp(obj:FlxSprite, scale:Null<Int> = null) {
        obj.origin.set(0,0);
        if(scale == null) scale = Scale;
        obj.scale.set(scale,scale);
    }

}
