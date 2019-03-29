package;

import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.system.FlxSound;

class ShipButton extends FlxGroup {

    var area:FlxSprite;
    public var text:FlxText;
    var callback:Void->Void;
    public var down:Bool;
    public var bleep:FlxSound;

    override public function new(X,Y,W,H,TX,TY,TText, Callback=null) {

        super();

        area = new FlxSprite();
        area.makeGraphic(W*ScaledSprite.Scale, H*ScaledSprite.Scale, FlxColor.RED);
        area.alpha = 0;
        add(area);

        area.x = X * ScaledSprite.Scale;
        area.y = Y * ScaledSprite.Scale;

        text = new FlxText();
        text.x = TX * ScaledSprite.Scale;
        text.y = TY * ScaledSprite.Scale;

        text.text = " " + TText.toUpperCase();
        text.setFormat("assets/pixelade.ttf", 40, FlxColor.WHITE);
        text.setBorderStyle(OUTLINE, FlxColor.BLACK, 4);

        add(text);

        callback = Callback;


    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        var over = area.overlapsPoint(FlxG.mouse.getScreenPosition());

        text.visible = over;
        if(FlxG.mouse.justPressed && over)
            if(callback != null){
             callback();
             bleep = FlxG.sound.play("assets/bleep.wav");
         }

            
        down = FlxG.mouse.pressed && over;

    }

}
