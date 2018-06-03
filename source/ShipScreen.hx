package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import openfl.display.Shader;
import openfl.display.ShaderParameter;
using flixel.util.FlxSpriteUtil;
import flixel.text.FlxText;
using ScaledSprite;
using flixel.tweens.FlxTween;
import flixel.FlxCamera;
import haxe.ds.Either;
import Data;

class ShipScreen extends FlxState {

    public static var CurrentMode:Mode;
    public var backLayer:FlxGroup;

    var front:FrontScene;
    var stars:StarField;
    var starSprite:FlxSprite;

    var totElapsed:Float = 0;

    override public function create() {

        CurrentMode = NORMAL;
        FlxG.stage.quality = flash.display.StageQuality.LOW;

        starSprite = new FlxSprite();
        starSprite.makeGraphic(1140, 630, 0xff000000);
        add(starSprite);

        // Background
        front = new FrontScene();
        add(front);

        backLayer = new FlxGroup();
        add(backLayer);


        // Main HUD group
        var hud = new HUD();
        add(hud);
        var text = new FlxText(0, 0, FlxG.width, "STAR FIELD");
        text.setFormat("assets/pixelade.ttf", 100, FlxColor.WHITE, CENTER);

        starSprite.stamp(text,0,270);

        stars = new StarField();
        starSprite.shader = stars;

        stars.time.value = [0.0];

        Data.Stock[PROTECTED][Left(PLANET_1)].add(COW, 10);
        Data.Stock[PROTECTED][Left(PLANET_1)].add(PORN, 5);

    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        totElapsed += elapsed;

        if(CurrentMode == FLYING)
            stars.time.value = [totElapsed];
    }

    public function travel() {

        if(Data.PlottedLocation == null)                 return;
        if(Data.PlottedLocation == Data.CurrentLocation) return;

        CurrentMode = FLYING;

        var fuelCost = Data.FuelCost(Data.CurrentLocation,Data.PlottedLocation);
        Data.CurrentLocation = Data.PlottedLocation;
        Data.PlottedLocation = null;

        front.tween({alpha:0}, 1);
        new FlxTimer().start(1, function(_) {
            FlxG.camera.shake(0.01, 3.5);
            Data.tween({Fuel:Data.Fuel-fuelCost}, 3);
         });
        new FlxTimer().start(4, function(_) {
            front.reload();
            front.tween({alpha:1}, 1);
        });
        new FlxTimer().start(5, function(_) { CurrentMode = NORMAL; } );
    }

}

enum Mode {
    NORMAL;
    INVENTORY;
    MAP;
    COMMS;
    FLYING;
}
