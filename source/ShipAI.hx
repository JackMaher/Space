package;

import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import ShipPower;

class ShipAI extends ShipPower {

    // What the AI will do next; and what power level to use.
    public var nextMove:Move;
    public var nextEnergy:Int;
    var mode: AIMode = GAINING;

    public function new() {
        super(-300,3,92,29,0xffff0000,
        new Shield(740, 100,"attackshipshield"), ENEMY);

        chooseNext();
    }

    function chooseNext() {
        if(Math.random() < 0.5)
            nextMove = FIRE;
        else
            nextMove = SHIELD;

        nextEnergy = Math.floor(Math.random()*maxEnergy)+1;

        trace('intending $nextMove at power $nextEnergy');
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        if(mode == GAINING) {
            if(energy >= nextEnergy) {
                powerUpType = nextMove;
                new FlxTimer().start((nextEnergy+0.5) * powerUpPeriod,function(_){
                    mode = GAINING;
                    powerUpType = NONE;

                    chooseNext();
                });
                mode = CHARGING;
            }
        }

    }

}

enum AIMode {
    GAINING;
    CHARGING;
}
