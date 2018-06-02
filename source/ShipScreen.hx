package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;

class ShipScreen extends FlxState {

    override public function create() {

        // Background

        var front = new FrontScene();
        add(front);

        // Main HUD group

        var hud = new HUD();
        add(hud);

        // Map view group

    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
    }

}
