package;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.group.FlxTypedGroup;
using flixel.util.FlxSpriteUtil;

class MapHUD extends FlxTypedGroup<FlxSprite>{
    private var _sprMap:FlxSprite;


    public function new(){
        super();



        _sprMap = new FlxSprite(0,0, "assets/images/map.png");
        add(_sprMap);



        forEach(function(spr:FlxSprite){
            spr.scrollFactor.set();
        });

    }



    //public function updateHUD(Health:Int = 0, Money:Int = 0):Void{
    //}
}
