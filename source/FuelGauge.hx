package;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class FuelGauge extends FlxSprite {

    public static var MaxWidth:Int = 160;

    var timeTotal:Float = 0;

    override public function new() {
        super();

        makeGraphic(1,1,FlxColor.WHITE);

        origin.set(0,0);

        x = 760;
        y = 20;

        scale.y = 40;

    }

    override public function update(elapsed:Float) {

        super.update(elapsed);
        timeTotal += elapsed;

        var fuelProportion = Data.Fuel / Data.MaxFuel;

        if(fuelProportion <= 0.2)      color =
            Math.floor(timeTotal * 2) % 2 == 0
                ? FlxColor.RED  // Flicker between red and black over time
                : FlxColor.BLACK;
        else if(fuelProportion <= 0.6) color = FlxColor.ORANGE;
        else                           color = FlxColor.GREEN;

        scale.x = fuelProportion * MaxWidth;

    }

}
