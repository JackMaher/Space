package;

import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxG;
using ScaledSprite;

class TalkDialog extends FlxSpriteGroup {

    var nameText:FlxText;
    var messageText:FlxText;
    var remText:String;
    var image:FlxSprite;
    var callback:Void->Void;
    var was:Bool = false;

    public function new(
        info:{
            name:String,
            message:String,
            color:Int
        } = null, cb:Void->Void = null) {

        if(info == null)
            info = Data.Info[Data.CurrentLocation].talk;

        super();

        remText = info.message;
        callback = cb;

        var leftPos = Math.floor(FlxG.width / 3);

        image = new FlxSprite();
        image.loadGraphic('assets/images/talk/${info.name.toLowerCase()}.png', true, 23, 23);
        image.animation.add("talk", [for (i in 0...image.animation.frames) i], 0);
        image.animation.play("talk");
        image.scaleUp();
        image.x = -image.width*10 - 10;
        add(image);

        nameText = new FlxText(0,0,FlxG.width, info.name.toUpperCase());
        nameText.setFormat("assets/pixelade.ttf", 48, FlxColor.WHITE, LEFT);
        nameText.setBorderStyle(OUTLINE, FlxColor.BLACK, 4);
        add(nameText);

        messageText = new FlxText(0,50, FlxG.width/2, "");
        messageText.setFormat("assets/pixelade.ttf", 32, info.color, LEFT);
        messageText.setBorderStyle(OUTLINE, FlxColor.BLACK, 4);
        add(messageText);

        x = Math.floor(FlxG.width /30) * 10;
        y = Math.floor(FlxG.height/40) * 10;


    }

    function toComms() {
        var ss = cast(FlxG.state, ShipScreen);
        ss.add(new Comms());
        ShipScreen.CurrentMode = COMMS;
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        if(Math.random() < 3/10 && !was && remText != "") {
            image.animation.frameIndex = Std.int(Math.random() * image.animation.frames);
            was = true;
        }
        else if(was) 
            was = false;

        if(remText == "") {
            image.animation.frameIndex = 2;
        }

        if(remText != "") {
            messageText.text += remText.charAt(0);
            remText = remText.substr(1);
        }
        else if(FlxG.mouse.justReleased) {
            kill();
            if(callback == null)
                toComms();
            else
                callback();

        }

    }

}
