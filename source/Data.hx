package;

import haxe.ds.Either;

class Data {

    public static var CurrentLocation:Either<Planet, SpaceStation> = Left(PLANET_1);
    public static var Fuel(default,set):Int = 25;

    public static var MaxFuel = 25;

    public static var Cash(default,default):Int = 350;

    public static function set_Fuel(F) {
        Fuel = F;
        if(Fuel > MaxFuel) Fuel = MaxFuel;
        if(Fuel < 0)       Fuel = 0;

        return Fuel;
    }

    public static var Cargo = new Storage<Item>();

    public static var ItemDetails = [
        COW => "Cow details",
        PORN => "Porn details"
    ];

}

enum Planet {
    PLANET_1;
}

enum SpaceStation {
    SPACE_STATION;
}

enum Item {
    COW;
    PORN;
}
