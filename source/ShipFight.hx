package;

import flixel.FlxSubState;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;
using ScaledSprite;

class ShipFight extends FlxSubState {

    var bg:FlxSprite;
    var ship:FlxSprite;
    var buttons:FlxSprite;
    var totElapsed:Float = 0;
    var firing:Float = 0;
    var redBtn:ShipButton;
    var blueBtn:ShipButton;
    var nearship:FlxSprite;
    var shipShield:FlxSprite;
    var nearshipShield:FlxSprite;
    var aiShip:ShipAI;
    var rodgerShip:RodgerShip;

    public function new(onReturn:Void->Void) {
        super(FlxColor.BLACK);

        closeCallback = onReturn;

        bg = new FlxSprite(0,0,"assets/images/combat/attackbackground.png");
        add(bg);
        bg.scaleUp();

        ship = new FlxSprite(0,0,"assets/images/combat/attackship.png");
        add(ship);
        ship.scaleUp();

        buttons = new FlxSprite(0,0,"assets/images/combat/button.png");
        add(buttons);
        buttons.scaleUp();
        /* 40,56 10x7 64,56 10x7 */
        redBtn = new ShipButton(39,55,12,9,41,50,"FIRE");
        add(redBtn);
        blueBtn = new ShipButton(63,55,12,9,63,50,"SHIELD");
        add(blueBtn);

        add(aiShip = new ShipAI());

        add(rodgerShip = new RodgerShip());

        add(nearship = new FlxSprite(0,0,"assets/images/combat/playership.png"));
        nearship.scaleUp();

        add(shipShield = new FlxSprite(0,0,"assets/images/combat/attackshipshield.png"));
        shipShield.scaleUp();

        add(nearshipShield = new FlxSprite(0,0,"assets/images/combat/playershipshield.png"));
        nearshipShield.scaleUp();

    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        totElapsed += elapsed;
        firing += elapsed;

        ship.offset.x = -Math.floor(Math.sin(totElapsed*2.4)*1.4+1.4)*ship.scale.x;
        ship.offset.y = Math.floor(Math.cos(totElapsed*1.5)*1+1)*ship.scale.y;

        if(redBtn.down)
            rodgerShip.powerUpType = FIRE;
        else if(blueBtn.down)
            rodgerShip.powerUpType = SHIELD;
        else
            rodgerShip.powerUpType = NONE;

        shipShield.visible = aiShip.shields > 0;
        nearshipShield.visible = rodgerShip.shields > 0;

    }

}
