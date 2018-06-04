package;

import flixel.FlxG;
import flixel.FlxSprite;
using ScaledSprite;

class FrontScene extends FlxSprite {

    override public function new() {

        super();

        reload();

    }

    public function reload() {

        var path = 'assets/images/';
        var loc = Data.CurrentLocation;

        switch(Data.Info[loc].type) {
            case Planet:
                path += "planet-scenes/";
                path += loc.toLowerCase() + ".png";
            case SpaceStation:
                path += "spacestation-scenes/";
                path += loc.toLowerCase() + ".png";
        }

        loadGraphic(path);
        scaleUp();

    }

}
