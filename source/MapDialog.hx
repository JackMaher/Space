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
using StringTools;

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

        var planets = [];
        for(loc in Data.Info.keys()) {
            var location = Data.Info[loc];
            if(location.galaxy != Data.CurrentGalaxy) continue;


            var pSpr = new FlxSprite(location.mapPosition.x*10, location.mapPosition.y*10);
            var cg = Std.string(Data.CurrentGalaxy).toLowerCase();
            var pn = loc.toLowerCase();
            pSpr.loadGraphic('assets/images/${cg}map/${pn}.png');
            pSpr.scaleUp();

            var pHl = new Highlight(pSpr);
            pHl.scaleUp();
            pHl.x = pSpr.x + (pSpr.width/2 - pHl.width/2)*10;
            pHl.y = pSpr.y + (pSpr.height/2 - pHl.height/2)*10;
            pHl.visible = false;
            add(pHl);

            add(pSpr);


            var butt = new ShipButton(
                Std.int(location.mapPosition.x), Std.int(location.mapPosition.y),
                Std.int(pSpr.width), Std.int(pSpr.height),
                Std.int(location.mapPosition.x)-3, Std.int(location.mapPosition.y)-8,
                pn.replace("_"," "), pickPlanet.bind(loc, pHl)
            );
            add(butt);
            var len = pn.length;
            butt.text.text += '\n ${Data.FuelCost(loc, Data.CurrentLocation)} Fuel';
            butt.text.addFormat(new FlxTextFormat(FlxColor.ORANGE), len+1, 1000);

            if(Data.CurrentLocation == loc) {
                pHl.visible = true;
            }
            if(Data.PlottedLocation == loc) {
                pickPlanet(loc,pHl);
            }

        }


    }

    function pickPlanet(loc:Location, planetHighlight:FlxSprite) {
        if(loc == Data.CurrentLocation) return;
        if(selected != null) {
            selected.visible = false;
            selected.color = 0xffff0000;
        }
        planetHighlight.color = 0xffff0000;
        planetHighlight.visible = true;
        selected = planetHighlight;
        Data.PlottedLocation = loc;
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

class Highlight extends FlxSprite {

    public function new(parent:FlxSprite) {

        super();
        makeGraphic(Std.int(parent.width)+2, Std.int(parent.height)+2, 0x00ffffff,true);

        function isSolid(i,j) return parent.pixels.getPixel32(i, j)>>24 != 0;

        // check if any in list of points (on parent pixels) are solid
        function anyP(xs:Array<{x:Int,y:Int}>) {
            for(x in xs) {
                if(isSolid(x.x,x.y)) return true;
            }
            return false;
        }


        function neighbours(x,y) {
            return [
                {x:x,y:y-1},
                {x:x-1,y:y},
                {x:x+1,y:y},
                {x:x,y:y+1}
            ];
        }


        for(i in 0...pixels.width) {
            for(j in 0...pixels.height) {
                if(anyP(neighbours(i-1,j-1)))
                    pixels.setPixel32(i,j,0xffffffff);
            }
        }

    }

}
