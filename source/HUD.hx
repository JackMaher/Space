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

        add(new ShipButton(75, 1, 19, 6, 75, 10, "Fuel Gauge"));

        add(new ShipButton(19,1,19,6,19,10,"Cash"));

        add(new ShipButton(46,49,21,12,44,40,"Communication"));

        add(new ShipButton(30,55,13,8,30,43,"Map"));

        var pressInv = function() {
            FlxG.state.add(new Inventory());
            ShipScreen.CurrentMode = INVENTORY;
        }
        add(new ShipButton(47,1,19,8,47,13,"Inventory", pressInv));

        add(new ShipButton(69,55,11,8,70,43,"Throttle"));

        add(new CashReadout());

    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        if(FlxG.keys.justPressed.X) {
            Data.Fuel--;
        }
    }

}
