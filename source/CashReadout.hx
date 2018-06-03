package;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.FlxSprite;
using ScaledSprite;

class CashReadout extends Cash {

    var internalCash:Float = Data.Cash;

    override public function new() {
        super(200,20,170);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        internalCash += (Data.Cash - internalCash)/20;
        text.text = Std.string(Math.round(internalCash));
    }

}

class Cash extends FlxSpriteGroup {

    public static var CashColor:Int = 0xffFFB600;
    public var text:FlxText;

    var totalElapsed:Float = 0;
    var newTotalCash = 350;
    var totalCash:Float = 350;

    override public function new(X, Y, Width:Int) {

        super();


        var icon = new FlxSprite("assets/images/cash.png");
        icon.scaleUp();
        icon.scale.set(4,4);
        icon.y = 6;
        icon.x = 6;
        add(icon);
        text = new FlxText(0,2,Width);
        text.setFormat("assets/dseg.ttf", 32, CashColor, RIGHT);
        text.text = Std.string(Data.Cash);
        add(text);

        x = X;
        y = Y;
    }

}

