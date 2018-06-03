package;

import flixel.FlxGame;
import openfl.display.Sprite;
import flixel.FlxG;

class Main extends Sprite
{
	public function new()
	{
		super();
                Data.Start();
                addChild(new FlxGame(1140, 630, ShipScreen));
	}
}
