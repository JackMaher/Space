package;

import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.FlxG;
using flixel.tweens.FlxTween;
using ScaledSprite;

class ShipPower extends FlxSpriteGroup {

    // Current energy level
    public var energy(default,set):Int = 0;

    // The shield overlay.
    public var shield:Shield;

    // Current charging level
    var power(default,set):Int = 0;

    // Maximum energy level
    public var maxEnergy:Int = 5;

    public var enemy:ShipPower;

    // How often the ship regains 1 energy.
    public var regainPeriod:Float = 1;

    // How long it takes to charge up one bar.
    public var powerUpPeriod:Float = 0.5;

    public var powerUpType:Move = NONE;
    public var _prevPowerUpType:Move = NONE;

    // Used internally.
    var _regainTimer:Float = 0;
    var _powerUpTimer:Float = 0;
    var _powerBars:Array<PowerBar> = [];

    var team:Team;

    var hp(default,set):Int = 0;
    var maxHp:Int = 15;

    var hpText:FlxText;

    var colors:Map<Move,Int> = [
        SHIELD => 0xff015be4,
        FIRE   => 0xfff60101,
        NONE   => FlxColor.WHITE
    ];

    public function new(xPos:Float, yPos:Float, hpX:Float, hpY:Float, mainColor:Int, s:Shield, t:Team) {

        super();

        for(i in 0...maxEnergy) {
            _powerBars.push(new PowerBar(i, mainColor));
            add(_powerBars[i]);

            _powerBars[i].x += xPos * ScaledSprite.Scale;
            _powerBars[i].y += yPos * ScaledSprite.Scale;

        }

        hpText = new FlxText(hpX*ScaledSprite.Scale,hpY*ScaledSprite.Scale,400,hp);
        hpText.setFormat("assets/pixelade.ttf",60,0xffc11c17);
        hpText.setBorderStyle(OUTLINE,0xff000000, 4);
        add(hpText);

        hp = maxHp;

        shield = s;
        shield.x=0;
        shield.y=0;
        add(shield);

        team = t;

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
                if(_prevPowerUpType == SHIELD){
                    trace('shield $power');
                    shield.amount += power;
                }
                if(_prevPowerUpType == FIRE) {
                    trace('pew $power');
                    if(team == ENEMY) {
                        add(new Laser(99,24,ENEMY));
                        add(new Laser(78,21,ENEMY));
                    }
                    else {
                        add(new Laser(26,51,PLAYER));
                        add(new Laser(14,47,PLAYER));
                    }

                    new FlxTimer().start(0.4,function(power,_){

                        var s = enemy.shield.amount;
                        enemy.shield.amount -= power;

                        var remainingPower = power - s;
                        trace(s);
                        trace(power);
                        trace(remainingPower);

                        if(remainingPower > 0) {
                            enemy.hp -= remainingPower;

                            FlxG.camera.shake(remainingPower*0.01,0.2);
                            FlxG.camera.flash(0xffffffff,remainingPower*0.1);
                        }

                    }.bind(power));
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

        _prevPowerUpType = powerUpType;

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


    public function set_hp(H:Int):Int {

        if(H <= 0) {
            FlxG.state.closeSubState();
            }

        trace(H);
        hp = H;

        hpText.text = Std.string(hp);

        return hp;
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
        color = C;
    }

    public function resetColor() {
        setColor(mainColor);
    }

}


class Shield extends FlxSpriteGroup {

    public var amount(default,set):Int = 0;
    public static var maxShields:Int = 5;

    var shieldImg:FlxSprite;
    var amountText:FlxText;


    public function new(xPos:Float,yPos:Float,imageFile:String) {
        super();

        shieldImg = new FlxSprite(0,0,'assets/images/combat/$imageFile.png');
        add(shieldImg);
        shieldImg.scaleUp();
        shieldImg.visible = false;

        amountText = new FlxText(xPos,yPos,400,"0");
        amountText.setFormat("assets/pixelade.ttf",60,0xff00c4c4);
        amountText.setBorderStyle(OUTLINE,0xff000000, 4);
        add(amountText);
        amountText.visible = false;
    }

    public function set_amount(S:Int):Int {
        if(S > maxShields)
            amount = maxShields;
        else if(S < 0)
            amount = 0;
        else
            amount = S;

        shieldImg.visible = amountText.visible = amount != 0;
        amountText.text = Std.string(amount);
        return amount;
    }

}



enum Move {
    FIRE;
    SHIELD;
    NONE;
}

enum Team {
    PLAYER;
    ENEMY;
}
