package;

import flixel.FlxG;
import flixel.FlxSprite;
using ScaledSprite;

class FrontScene extends FlxSprite {

    override public function new() {

        super();

        var path = 'assets/images/';

        switch(Data.CurrentLocation) {
            case Left(l):
                path += "planet-scenes/";
                path += Std.string(l).toLowerCase() + ".png";
            case Right(r):
                path += "spacestation.png";
        }

        loadGraphic(path);
        scaleUp();

    }

}
