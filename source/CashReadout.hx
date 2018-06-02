package;

import flixel.group.FlxGroup;
import flixel.text.FlxText;

class CashReadout extends FlxGroup {

    public static var CashColor:Int = 0xffFFB600;
    var text:FlxText;

    var totalElapsed:Float = 0;
    var newTotalCash = 350;
    var totalCash:Float = 350;

    override public function new() {

        super();

        text = new FlxText(200,22,170);
        text.setFormat("assets/dseg.ttf", 32, CashColor, RIGHT);
        text.text = Std.string(Data.Cash);
        add(text);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        totalElapsed += elapsed;

        if(totalElapsed > newTotalCash / 25 - 14)
            newTotalCash += 100;

        totalCash += (newTotalCash - Data.Cash)/20;
        Data.Cash = Math.round(totalCash);

        text.text = Std.string(Data.Cash);
    }

}
