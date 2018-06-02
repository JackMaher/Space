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

class Universe extends FlxSprite {
	public var _plnt1:FlxSprite;
	
	public function new(){
		super();
		planet1 ();
	}

	public function planet1(): Void{
		_plnt1 = new FlxSprite(0,0,"assets/images/plnt1.png");
	} 
}