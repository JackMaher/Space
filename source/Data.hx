package;

import haxe.ds.Either;
import flixel.util.FlxColor;

class Data {

    public static var CurrentGalaxy = "PROTECTED";
    public static var PlottedLocation:Location = null;
    public static var CurrentLocation:Location = "Smega9";

    public static var Fuel(default,set):Int;
    public static var MaxFuel;
    public static var Cargo = new Storage<Item>();
    public static var Cash(default,default):Int;

    public static function Start() {
        DataReader.Read();

        for(l in Info) {
            for(i in l.items.keys()) {
                l.stock.setAmount(i, l.items[i].startStock);
                l.prices[i] = l.items[i].basePrice;
            }
        }

        MaxFuel = 25;
        Cash = 250;
        Fuel = 25;

        /*
        Info[Left(Dimium)].stock.setAmount(COW, 10);
        Info[Left(Zemroid)].stock.setAmount(COW, 15);
        Info[Left(Rilsuk)].stock.setAmount(LUMIS, 15);
        */

        CalculatePrices();
    }

    public static function set_Fuel(F) {
        Fuel = Std.int(F);
        if(Fuel > MaxFuel) Fuel = MaxFuel;
        if(Fuel < 0)       Fuel = 0;

        return Fuel;
    }

    public static var ItemDetails = [
        "COW" => "Moo goes the Cow. Moo indeed. The Hickzoids are known to use cows as their brides, however such pratices are frown upon in space society today.",
        "PORN" => "Mucky Mags have been a stable of intergalactic top shelf reststop scene. However, since the galactic police banned them in the protected zone they've become highly saught after by protected space truckers alike.",
        "LUMIS" => "Cute, and delious!",
    ];

    public static var Info:Map<Location,LocationInfo> = new Map();
/*
        Right(SPACE_STATION) => {
            galaxy: PROTECTED,
            mapPosition: {
                x: 85,
                y: 20
            },
            stock: new Storage(),
            prices: new Map(),
            items: [
                FUEL => {basePrice: 5, maxStock: 10},
            ],
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
            prices: new Map(),
            items: [
                COW  => {basePrice: 15, maxStock: 10},
                PORN => {basePrice: 5, maxStock: 5}
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
<<<<<<< Updated upstream
            prices: [
                COW  => 15,
                LUMIS => 5
=======
            prices: new Map(),
            items: [
                COW  => {basePrice: 15, maxStock: 10},
                PORN => {basePrice: 5, maxStock: 5}
>>>>>>> Stashed changes
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
            prices: new Map(),
            items: [
                COW  => {basePrice: 15, maxStock: 10},
                PORN => {basePrice: 5, maxStock: 5}
            ],
            talk: {
                name: "Johnny",
                message: "Did you know it apperently tradition for the Hickzoid to marry their cows?",
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
            prices: new Map(),
            items: [
                COW  => {basePrice: 15, maxStock: 10},
                PORN => {basePrice: 5, maxStock: 5}
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
            prices: new Map(),
            items: [
                COW  => {basePrice: 15, maxStock: 10},
                PORN => {basePrice: 5, maxStock: 5}
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
            prices: new Map(),
            items: [
                COW  => {basePrice: 15, maxStock: 10},
                PORN => {basePrice: 5, maxStock: 5}
            ],
            talk: {
                name: "Bubba",
                message: "Hey what's going on YouTube my name is Bubba and on today's unboxing video we're going to be opening a portal to Hell. \n\n Don't forget to destroy that like button!",
                color:FlxColor.ORANGE
            }
        },*/


    // Calculate the cost to get from one location to another
    public static function FuelCost( l1: Location, l2: Location) {

        var p1 = Info[l1].mapPosition;
        var p2 = Info[l2].mapPosition;

        if(p1 == null) throw '$l1 doesn\'t exist';
        if(p2 == null) throw '$l2 doesn\'t exist';

        var dx = p2.x - p1.x;
        var dy = p2.y - p1.y;

        var distance = Math.sqrt(dx*dx+dy*dy);
        return Std.int(Math.max(1, distance/10));

    }

    public static function AddStock() {

        for(loc in Data.Info) {
            var itemOptions = [];
            for(item in loc.items) {
                trace(item);
                if( item.produces
                    && item.maxStock > loc.stock.getAmount(item.name))
                    itemOptions.push(item.name);
            }
            trace(itemOptions);

            if(itemOptions.length == 0) continue;

            loc.stock.add((new flixel.math.FlxRandom()).getObject(itemOptions), 1);
        }

    }

    public static function CalculatePrices() {

        var DemandMultiplier:Float = 2;

        function priceFunc(currentStock:Int,maxStock:Int,basePrice:Int):Int {
            if(basePrice == null) return -1;
            if(maxStock == null) return basePrice;

            var res = (DemandMultiplier-1) * basePrice * Math.sin(
                    (Math.min(maxStock, (currentStock-1)) / maxStock + 2)
                    * Math.PI / 2
                    ) + DemandMultiplier * basePrice;
            return Std.int(res);
        }

        for(loc in Info) {

            if(loc.type == SpaceStation) continue;

            loc.prices = new Map();

            for(itemName in loc.items.keys()) {
                var item = loc.items[itemName];

                var price = priceFunc(
                        loc.stock.getAmount(itemName),
                        item.maxStock,
                        item.basePrice
                        );

                loc.prices[itemName] = price;

            }

        }
    }


}

typedef LocationInfo = {
    name:String,
    type:LocationType,
    galaxy:String,
    mapPosition:{ x:Int, y:Int },
    stock:Storage<Item>,
    prices:Map<Item, Int>,
    items:Map<Item, {
        name:Item,
        produces:Bool,
        basePrice:Int,
        maxStock:Int,
        startStock:Int
    }>,
    talk:{
        name:String,
        message:String,
        color:Int
    }
}

enum LocationType {
    Planet;
    SpaceStation;
}
typedef Location = String;
typedef Item = String;
