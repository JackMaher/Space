package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.text.FlxText;

class FuelGauge extends FlxGroup {

    public static var MaxWidth:Int = 170;
    public static var FuelColor:Int = 0xffffffff;

    var timeTotal:Float = 0;

    var gauge:FlxSprite;
    var text:FlxText;
    var internalFuel:Float = Data.Fuel;
    

    override public function new() {
        super();

        gauge = new FlxSprite();
        gauge.makeGraphic(1,1,FlxColor.WHITE);

        gauge.origin.set(0,0);

        gauge.x = 760;
        gauge.y = 20;
        gauge.scale.y = 40;
        add(gauge);

        text = new FlxText(760,22,170);
        text.setFormat("assets/dseg.ttf", 32, FuelColor, RIGHT);
        text.text = Std.string(Data.Cash);

        add(text);

    }

    override public function update(elapsed:Float) {

        super.update(elapsed);
        timeTotal += elapsed;

        internalFuel += (Data.Fuel - internalFuel) / 20;

        var fuelProportion = internalFuel / Data.MaxFuel;

        if(fuelProportion <= 0.2)      gauge.color =
            Math.floor(timeTotal * 2) % 2 == 0
                ? FlxColor.RED  // Flicker between red and black over time
                : FlxColor.BLACK;
        else if(fuelProportion <= 0.6) gauge.color = FlxColor.ORANGE;
        else                           gauge.color = FlxColor.GREEN;

        gauge.scale.x = fuelProportion * MaxWidth;

        text.text = Std.string(Math.round(internalFuel));

    }

}
