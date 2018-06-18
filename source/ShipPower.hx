package;

import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.util.FlxColor;
using flixel.tweens.FlxTween;
using ScaledSprite;

class ShipPower extends FlxSpriteGroup {

    // Current energy level
    public var energy(default,set):Int = 0;

    // Current charging level
    var power(default,set):Int = 0;

    // Maximum energy level
    public var maxEnergy:Int = 5;

    // How often the ship regains 1 energy.
    public var regainPeriod:Float = 1;

    // How long it takes to charge up one bar.
    public var powerUpPeriod:Float = 0.5;

    public var powerUpType:Move = NONE;

    // Used internally.
    var _regainTimer:Float = 0;
    var _powerUpTimer:Float = 0;
    var _powerBars:Array<PowerBar> = [];

    var hp:Int;
    var maxHp:Int = 25;

    public var shields(default,set):Int;
    var maxShields:Int = 5;

    var colors:Map<Move,Int> = [
        SHIELD => 0xff015be4,
        FIRE   => 0xfff60101,
        NONE   => FlxColor.WHITE
    ];

    public function new(xPos:Float, yPos:Float, mainColor:Int) {

        super();

        for(i in 0...maxEnergy) {
            _powerBars.push(new PowerBar(i, mainColor));
            add(_powerBars[i]);
        }

        x = xPos * ScaledSprite.Scale;
        y = yPos * ScaledSprite.Scale;

        health = maxHp;

    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        if(powerUpType != NONE) {
            // Increase charge power
            _powerUpTimer += elapsed;
            if(_powerUpTimer > powerUpPeriod) {
                _powerUpTimer -= powerUpPeriod;
                power++;
            }
        }
        else {
            if(power > 0) {
                if(powerUpType == SHIELD){
                    trace('shield $power');
                    shields += power;
                }
                if(powerUpType == FIRE) {
                    trace('pew $power');
                }
                energy -= power;
                _regainTimer = 0;
                power = 0;
            }
            _powerUpTimer = 0;
        }

        // Increase energy
        _regainTimer += elapsed;
        if(_regainTimer > regainPeriod) {
            _regainTimer -= regainPeriod;
            energy++;
        }

    }

    public function set_energy(E:Int) {

        if(E > maxEnergy) return energy;

        for(i in 0..._powerBars.length) {
            if(i < E) {
                _powerBars[i].show();
            }
            else {
                _powerBars[i].hide();
            }

        }

        energy = E;
        return energy;
    }

    public function set_power(P:Int):Int {

        if(P > energy) return power;

        for(i in 0..._powerBars.length) {
            if(i < energy && i < P) {
                _powerBars[i].setColor(colors[powerUpType]);
            }
            else if(i < energy) {
                _powerBars[i].resetColor();
            }

        }

        power = P;
        return power;
    }

    public function set_shields(S:Int):Int {
        if(S > maxShields) {
            shields = maxShields;
            return shields;
        }

        if(S < 0) {
            shields = 0;
            return shields;
        }

        shields = S;
        return shields;

    }

}

class PowerBar extends FlxSprite {

    static var powerBarFile = "assets/images/combat/powerbar.png";
    var mainColor:Int;

    public function new(Index:Int, MainColor:Int) {
        super();

        loadGraphic(powerBarFile);
        scaleUp();

        x = (width+1)*scale.x*Index;

        mainColor = MainColor;

        alpha=0;

    }

    public function show() {
        if(alpha == 1) return;
        resetColor();
        //tween({alpha:1},0.25);
        alpha = 1;
    }

    public function hide() {
        if(alpha == 0) return;
        resetColor();
        //tween({alpha:0},0.25);
        alpha = 0;
    }

    public function setColor(C:Int) {
        if(color == FlxColor.WHITE) color = C;
        //FlxTween.color(this,0.25,color,C);
        color = C;
    }

    public function resetColor() {
        setColor(mainColor);
    }

}

enum Move {
    FIRE;
    SHIELD;
    NONE;
}
