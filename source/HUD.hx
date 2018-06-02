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

class HUD extends FlxTypedGroup<FlxSprite>{
	private var _sprTop:FlxSprite;
	private var _sprBottom:FlxSprite;
	public var _btnMap: FlxButton;
	public var _mapHUD: MapHUD;
	public var _mapActive: Bool;
	private var _sprMap:FlxSprite;
	private var _btnPlanet1: FlxButton;
	var _ps = cast(FlxG.state, PlayState);

	
	public function new(){
		super();

		_sprMap = new FlxSprite(0,0, "assets/images/map.png");
		_mapActive = true;
		add(_sprMap);

		_btnPlanet1 = new FlxButton (32,15, clickBtn1);
		_btnPlanet1.loadGraphic("assets/images/btn1-1.png");

		_btnPlanet1.onOver.callback = function (){
			_btnPlanet1.loadGraphic("assets/images/btn1.png");
		}

		_btnPlanet1.onOut.callback = function (){
			_btnPlanet1.loadGraphic("assets/images/btn1-1.png");
		}
		add(_btnPlanet1);

		_sprTop = new FlxSprite(0,0, "assets/images/hud_top.png");
		add(_sprTop);

		_sprBottom = new FlxSprite(0,0, "assets/images/hud_bottom.png");
		add(_sprBottom);

		_btnMap = new FlxButton(30,55,clickMap);
		_btnMap.loadGraphic("assets/images/mapbtn.png");
		//_btnMap.visible = true;
		add(_btnMap);



		forEach(function(spr:FlxSprite){
			spr.scrollFactor.set();
			});
 
	}	

	public function clickBtn1():Void {
		_ps._universe.planet1 ();

	}

	public function clickMap():Void{
		_mapActive;

		if (_mapActive == true){
			_sprMap.visible = false;
			_mapActive = false;
			_btnPlanet1.visible = false;
		}
		else if(_mapActive == false){
			_sprMap.visible = true;
			_mapActive = true;
			_btnPlanet1.visible = true;
		}

		//_sprMap.visible = true;
	}

		override public function update():Void
	{
		super.update();
	}	

	//public function updateHUD(Health:Int = 0, Money:Int = 0):Void{
	//}
}