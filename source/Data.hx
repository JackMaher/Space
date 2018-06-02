package;

import haxe.ds.Either;

class Data {

    public static var CurrentLocation:Either<Planet, SpaceStation> = Left(PLANET_1);
    public static var Fuel = 5;
    public static var MaxFuel = 25;

}

enum Planet {
    PLANET_1;
}

enum SpaceStation {
    SPACE_STATION;
}
