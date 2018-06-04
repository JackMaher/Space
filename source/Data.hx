package;

import haxe.ds.Either;
import flixel.util.FlxColor;

class Data {

    public static var CurrentGalaxy = PROTECTED;
    public static var PlottedLocation:Either<Planet,SpaceStation> = null;
    public static var CurrentLocation:Either<Planet, SpaceStation> = Left(Dimium);

    public static var Fuel(default,set):Int;
    public static var MaxFuel;
    public static var Cargo = new Storage<Item>();
    public static var Cash(default,default):Int;

    public static function Start() {
        MaxFuel = 25;
        Cash = 250;
        Fuel = 25;

        // Add stock to planets here!

        //Example
        Info[Left(Dimium)].stock.setAmount(COW, 10);
        Info[Left(Zemroid)].stock.setAmount(COW, 15);

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

    public static var Info:Map<Either<Planet,SpaceStation>,PlanetInfo> = [

        Right(SPACE_STATION) => {
            galaxy: PROTECTED,
            mapPosition: {
                x: 85,
                y: 20
            },
            stock: new Storage(),
            prices: [ FUEL => 5 ],
            talk: {
                name: "Bubba",
                message: "Hey what's going on YouTube my name is Bubba and on today's unboxing video we're going to be opening a portal to Hell. \n\n Don't forget to destroy that like button!",
                color:FlxColor.ORANGE
            }
        },

        Left(Dimium) => {
            galaxy: PROTECTED,
            mapPosition: {
                x : 33,
                y : 16
            },
            stock: new Storage(),
            prices: [
                COW => 10,
                PORN => 5
            ],
            talk: {
                name: "Bubba",
                message: "Hey what's going on YouTube my name is Bubba and on today's unboxing video we're going to be opening a portal to Hell. \n\n Don't forget to destroy that like button!",
                color:FlxColor.ORANGE
            }

        },
        Left(Rilsuk) => {
            galaxy: PROTECTED,
            mapPosition: {
                x: 28,
                y: 29
            },
            stock: new Storage(),
            prices: [
                COW  => 15,
                PORN => 5
            ],
            talk: {
                name: "Bubba",
                message: "Hey what's going on YouTube my name is Bubba and on today's unboxing video we're going to be opening a portal to Hell. \n\n Don't forget to destroy that like button!",
                color:FlxColor.ORANGE
            }
        },
        Left(Zemroid) => {
            galaxy: PROTECTED,
            mapPosition: {
                x: 38,
                y: 34
            },
            stock: new Storage(),
            prices: [
                COW  => 15,
                PORN => 5
            ],
            talk: {
                name: "Johnny",
                message: "Did you know it apperently tradition for Hickzoid to marry their cows?",
                color:FlxColor.ORANGE
            }
        },
        Left(Amutlis) => {
            galaxy: PROTECTED,
            mapPosition: {
                x: 50,
                y: 24
            },
            stock: new Storage(),
            prices: [
                COW  => 15,
                PORN => 5
            ],
            talk: {
                name: "Bubba",
                message: "Hey what's going on YouTube my name is Bubba and on today's unboxing video we're going to be opening a portal to Hell. \n\n Don't forget to destroy that like button!",
                color:FlxColor.ORANGE
            }
        },
       Left(Smega9) => {
            galaxy: PROTECTED,
            mapPosition: {
                x: 70,
                y: 18
            },
            stock: new Storage(),
            prices: [
                COW  => 15,
                PORN => 5
            ],
            talk: {
                name: "Bubba",
                message: "Hey what's going on YouTube my name is Bubba and on today's unboxing video we're going to be opening a portal to Hell. \n\n Don't forget to destroy that like button!",
                color:FlxColor.ORANGE
            }
        },
       Left(Nomusroid) => {
            galaxy: PROTECTED,
            mapPosition: {
                x: 83,
                y: 38
            },
            stock: new Storage(),
            prices: [
                COW  => 15,
                PORN => 5
            ],
            talk: {
                name: "Bubba",
                message: "Hey what's going on YouTube my name is Bubba and on today's unboxing video we're going to be opening a portal to Hell. \n\n Don't forget to destroy that like button!",
                color:FlxColor.ORANGE
            }
        },
    ];


    // Calculate the cost to get from one location to another
    public static function FuelCost(
            l1: Either<Planet, SpaceStation>,
            l2: Either<Planet, SpaceStation>) {

        var p1 = Info[l1].mapPosition;
        var p2 = Info[l2].mapPosition;

        if(p1 == null) throw '${Std.string(l1)} doesn\'t have a location in this galaxy!';
        if(p2 == null) throw '${Std.string(l2)} doesn\'t have a location in this galaxy!';

        var dx = p2.x - p1.x;
        var dy = p2.y - p1.y;

        var distance = Math.sqrt(dx*dx+dy*dy);
        return Std.int(Math.max(1, distance/10));

    }

}

typedef PlanetInfo = {
    galaxy:Galaxy,
    mapPosition:{ x:Int, y:Int },
    stock:Storage<Item>,
    prices:Map<Item, Int>,
    talk:{ name:String, message:String, color:Int }
}

enum Galaxy {
    PROTECTED;
}

enum Planet {
    Dimium;
    Rilsuk;
    Zemroid;
    Amutlis;
    Smega9;
    Nomusroid;
}

enum SpaceStation {
    SPACE_STATION;
}

enum Item {
    COW;
    PORN;
    FUEL;
}
