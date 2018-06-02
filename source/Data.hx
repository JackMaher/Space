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
        COW => "Moo goes the Cow. Moo indeed. The Hickzoids are known to use cows as their brides, however such pratices are frown upon in space socitity today.",
        PORN => "Mucky Mags have been a stable of intergalactic top shelf reststop scene. However, since the galactic police banned them in the protected zone they've become highly saught after by protected space truckers alike."
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
