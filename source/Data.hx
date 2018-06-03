package;

import haxe.ds.Either;

class Data {

    public static var CurrentGalaxy = PROTECTED;
    public static var PlottedLocation:Either<Planet,SpaceStation> = null;
    public static var CurrentLocation:Either<Planet, SpaceStation> = Left(PLANET_1);

    public static var Fuel(default,set):Int;
    public static var MaxFuel;
    public static var Cargo = new Storage<Item>();
    public static var Cash(default,default):Int;

    public static function Start() {
        MaxFuel = 25;
        Cash = 250;
        Fuel = 25;

        // Set the stock of everywhere to 0
        for(loc in Type.allEnums(Planet)) {
            Stock[Left(loc)] = new Storage<Item>();
        }
        for(loc in Type.allEnums(SpaceStation)) {
            Stock[Right(loc)] = new Storage<Item>();
        }

        // Add stock to planets here!

        //Example
        Stock[Left(PLANET_1)].setAmount(COW, 10);

    }

    public static function set_Fuel(F) {
        Fuel = Std.int(F);
        if(Fuel > MaxFuel) Fuel = MaxFuel;
        if(Fuel < 0)       Fuel = 0;

        return Fuel;
    }

    public static var ItemDetails = [
        COW => "Moo goes the Cow. Moo indeed. The Hickzoids are known to use cows as their brides, however such pratices are frown upon in space society today.",
        PORN => "Mucky Mags have been a stable of intergalactic top shelf reststop scene. However, since the galactic police banned them in the protected zone they've become highly saught after by protected space truckers alike."
    ];

    public static var MapInfo = [
        PROTECTED => [
            // X and Y positions on the whole screen
            Left(PLANET_1) => {
                x: 20,
                y: 20
            },
            Left(PLANET_2) => {
                x:70,
                y:35
            },
            Right(SPACE_STATION) => {
                x: 90,
                y: 20
            }
        ]
    ];

    public static var Prices = [
        Left(PLANET_1) => [
            COW => 5,
            PORN => 10
        ],
        Left(PLANET_2) => [
            COW => 10,
            PORN => 5
        ],
        Right(SPACE_STATION) => [
            FUEL => 5
        ]
    ];

    public static var Stock:Map<Either<Planet, SpaceStation>, Storage<Item>> = new Map();

    public static function FuelCost(
            l1: Either<Planet, SpaceStation>,
            l2: Either<Planet, SpaceStation>) {

        var p1 = MapInfo[CurrentGalaxy][l1];
        var p2 = MapInfo[CurrentGalaxy][l2];

        if(p1 == null) throw '${Std.string(l1)} doesn\'t have a location in this galaxy!';
        if(p2 == null) throw '${Std.string(l2)} doesn\'t have a location in this galaxy!';

        var dx = p2.x - p1.x;
        var dy = p2.y - p1.y;

        var distance = Math.sqrt(dx*dx+dy*dy);
        return Std.int(Math.max(1, distance/10));

    }

}

enum Galaxy {
    PROTECTED;
}

enum Planet {
    PLANET_1;
    PLANET_2;
}

enum SpaceStation {
    SPACE_STATION;
}

enum Item {
    COW;
    PORN;
    FUEL;
}
