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
import flixel.system.FlxSound;

class ShipScreen extends FlxState {

    public static var CurrentMode:Mode;
    public var backLayer:FlxGroup;

    var front:FrontScene;
    var stars:StarField;
    var starSprite:FlxSprite;

    var totElapsed:Float = 0;
    public var music:FlxSound;

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

        //music = FlxG.sound.play("assets/back.wav");



        // Main HUD group
        var hud = new HUD();
        add(hud);
        var text = new FlxText(0, 0, FlxG.width, "STAR FIELD");
        text.setFormat("assets/pixelade.ttf", 100, FlxColor.WHITE, CENTER);

        starSprite.stamp(text,0,270);

        stars = new StarField();
        starSprite.shader = stars;

        stars.time.value = [0.0];

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
        if(Math.random() < Data.EncounterChance) {
            var fight = new ShipFight(doTravel);

            front.tween({alpha:0}, 1);
            new FlxTimer().start(1, function(_) {
                FlxG.camera.shake(0.01, 0);
            });

            var messages = [
                "Something's pulling us out of warp.",
                "We're being tailed.",
                "I think those lovely tattooed men we passed want to have a polite discussion with us." ,
                "We got pirates! \n ... \n SPACE PIRATES!",

            ];

            var sodsMessage = messages[Math.floor(Math.random() * messages.length)];

            new FlxTimer().start(2, function(_) {
                add(new TalkDialog({
                    name: "sodsbury",
                    message: sodsMessage,
                    color:0xff00ff00
                }, openSubState.bind(fight)));
            });

        }
        else {
            doTravel();
        }

    }

    public function doTravel() {

        if(Data.PlottedLocation == null)                 return;
        if(Data.PlottedLocation == Data.CurrentLocation) return;

        CurrentMode = FLYING;
        music = FlxG.sound.play("assets/blast.wav");
        var fuelCost = Data.FuelCost(Data.CurrentLocation,Data.PlottedLocation);
        Data.CurrentLocation = Data.PlottedLocation;
        Data.PlottedLocation = null;

        front.tween({alpha:0}, 1);
        new FlxTimer().start(1, function(_) {
            FlxG.camera.shake(0.01, fuelCost+0.5);
            Data.tween({Fuel:Data.Fuel-fuelCost}, fuelCost);
         });
        new FlxTimer().start(fuelCost+1, function(_) {
            front.reload();
            front.tween({alpha:1}, 1);
        });
        new FlxTimer().start(fuelCost+2, function(_) { CurrentMode = NORMAL; } );

        for(i in 0...fuelCost) {
            Data.AddStock();
        }
        Data.CalculatePrices();

    }

}

enum Mode {
    NORMAL;
    INVENTORY;
    MAP;
    COMMS;
    FLYING;
    TALK;
}
