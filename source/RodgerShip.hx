package;

import ShipPower;

class RodgerShip extends ShipPower {

    public function new() {

        super(83,53,0xffE633FF, new Shield(240,360,"playershipshield"),PLAYER);

    }

}
