package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;

class ShipScreen extends FlxState {

    public static var CurrentMode:Mode;

    override public function create() {

        CurrentMode = NORMAL;

        // Background
        var front = new FrontScene();
        add(front);

        // Main HUD group
        var hud = new HUD();
        add(hud);

        // Map view group

        // Inventory group

    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
    }

}

enum Mode {
    NORMAL;
    INVENTORY;
    MAP;
    COMMS;
    FLYING;
}
