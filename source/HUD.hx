package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
using ScaledSprite;

class HUD extends FlxGroup {

    var shipTop   :FlxSprite;
    var shipBottom:FlxSprite;
    var fuel      :FuelGauge;

    override public function new() {
        super();

        shipTop = new FlxSprite("assets/images/hud_top.png");
        shipTop.scaleUp();
        add(shipTop);

        shipBottom = new FlxSprite("assets/images/hud_bottom.png");
        shipBottom.scaleUp();
        add(shipBottom);

        fuel = new FuelGauge();
        add(fuel);

        add(new ToolTip(75, 1, 18, 6, 75, 10, "Fuel Gauge"));

    }

}
