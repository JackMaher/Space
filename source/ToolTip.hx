package;

import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;

class ToolTip extends FlxGroup {

    var area:FlxSprite;
    var text:FlxText;

    override public function new(X,Y,W,H,TX,TY,TText) {

        super();

        area = new FlxSprite();
        area.makeGraphic(W*10, H*10, FlxColor.RED);
        area.alpha = 0;
        add(area);

        area.x = X * 10;
        area.y = Y * 10;

        text = new FlxText();
        text.x = TX * 10;
        text.y = TY * 10;

        text.text = " " + TText.toUpperCase();
        text.setFormat("assets/pixelade.ttf", 40, FlxColor.WHITE);
        text.setBorderStyle(OUTLINE, FlxColor.BLACK, 4);
        add(text);


    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        text.visible = area.overlapsPoint(FlxG.mouse.getScreenPosition());
    }

}
