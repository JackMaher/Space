package;

import flixel.FlxSprite;
import flixel.FlxG;
import Data;
import flixel.group.FlxGroup;
import haxe.ds.Either;
using ScaledSprite;
import flixel.util.FlxColor;
using flixel.util.FlxSpriteUtil;
import flixel.text.FlxText;

class MapDialog extends FlxGroup {

    var totElapsed:Float = 0;
    var bg:FlxSprite;
    var selected:FlxSprite;

    public function new() {

        super();

        FlxG.stage.quality = flash.display.StageQuality.LOW;
        FlxG.camera.antialiasing = false;

        bg = new FlxSprite("assets/images/mapback.png");
        bg.scaleUp();
        add(bg);

        var planetSet = Data.MapInfo[Data.CurrentGalaxy];

        for(p in planetSet.keys()) {
            var planet = planetSet[p];


            var pSpr = new FlxSprite(planet.x*10, planet.y*10);
            var cg = Std.string(Data.CurrentGalaxy).toLowerCase();
            var pn;
            switch(p) {
                case Left(p):
                    pn = Std.string(p).toLowerCase();
                case Right(ss):
                    pn = Std.string(ss).toLowerCase();
            }
            pSpr.loadGraphic('assets/images/${cg}map/${pn}.png');
            pSpr.scaleUp();

            var pHl = new FlxSprite();
            pHl.antialiasing = false;
            pHl.makeGraphic(Std.int(pSpr.width+2), Std.int(pSpr.width+2), 0x00000000, true);
            for(x in 0...20) {
            pHl.drawCircle(Std.int(pSpr.width/2)+1.5, Std.int(pSpr.width/2)+1.5,
                    pSpr.width/2, 0x00ffffff, {color:0xffffffff, thickness:1} , {smoothing:false});
            }
            pHl.scaleUp();
            pHl.x = pSpr.x + (pSpr.width/2 - pHl.width/2)*10;
            pHl.y = pSpr.y + (pSpr.height/2 - pHl.height/2)*10;
            pHl.visible = false;
            add(pHl);

            add(pSpr);


            var butt = new ShipButton(
                Std.int(planet.x), Std.int(planet.y),
                Std.int(pSpr.width), Std.int(pSpr.height),
                Std.int(planet.x)-3, Std.int(planet.y)-8,
                pn, pickPlanet.bind(p, pHl)
            );
            add(butt);
            var len = pn.length;
            butt.text.text += '\n ${Data.FuelCost(p, Data.CurrentLocation)} Fuel';
            butt.text.addFormat(new FlxTextFormat(FlxColor.ORANGE), len+1, 1000);

            if(Data.CurrentLocation == p) {
                pHl.visible = true;
            }
            if(Data.PlottedLocation == p) {
                pickPlanet(p,pHl);
            }

        }


    }

    function pickPlanet(planet:Either<Planet,SpaceStation>, planetHighlight:FlxSprite) {
        if(planet == Data.CurrentLocation) return;
        if(selected != null) {
            selected.visible = false;
            selected.color = 0xffff0000;
        }
        planetHighlight.color = 0xffff0000;
        planetHighlight.visible = true;
        selected = planetHighlight;
        Data.PlottedLocation = planet;
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        totElapsed += elapsed;
        var mpos = FlxG.mouse.getScreenPosition();

        if(totElapsed < 0.1) return;
        if(FlxG.mouse.justPressed &&
               (mpos.y < 60 || mpos.y > 540 )) {
            kill();
            ShipScreen.CurrentMode = NORMAL;
        }

    }


}
