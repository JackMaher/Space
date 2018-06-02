package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxMath;


class PlayState extends FlxState
{
	private var _hud:HUD;
	private var _map:MapHUD;
	public var _universe:FlxTypedGroup<Universe>;

	override public function create():Void
	{

		_universe = new FlxTypedGroup<Universe> ();
		add(_universe);

		_hud = new HUD ();
		add(_hud);

		super.create();
	}
	

	override public function destroy():Void
	{
		super.destroy();
	}


	override public function update():Void
	{
		super.update();
	}	
}