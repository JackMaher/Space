package;

import haxe.ds.Either;
import StringTools;
import thx.csv.Tsv;
import Data;
import openfl.Assets;
import flixel.util.FlxColor;

class DataReader {

    public static var LOCATIONS_FILE:String = "assets/data/locations.tsv";

    public static function Read():Void {

        var headings:Map<String, Int> = new Map();

        var decoded = Tsv.decode(Assets.getText(LOCATIONS_FILE));

        for(h in 0...decoded[0].length)
            headings[decoded[0][h]] = h;

        var itemNamesMap:Map<String,Int> = new Map();
        for(h in headings.keys()) {
            var itemRegex = ~/Item::([^:]*)::[^:]*/;
            if(itemRegex.match(h)) {
                itemNamesMap[itemRegex.matched(1)] = 1;
            }
        }
        var itemNames = [for(i in itemNamesMap.keys()) i];

        function lookup(row:Int, prop:String) {
            if(headings[prop] == null) return null;
            return decoded[row][headings[prop]];
        }

        for(loc in 1...decoded.length) {
            var pi:LocationInfo = {
                name:           lookup(loc, "Name"),
                type:           Match(LocationType, lookup(loc,"Type")),
                galaxy:         lookup(loc,"Galaxy"),
                mapPosition:    {
                                    x:Std.parseInt(lookup(loc,"Map::X")),
                                    y:Std.parseInt(lookup(loc,"Map::Y"))
                                },
                stock:          new Storage(),
                prices:         new Map(),
                items:          new Map(),
                talk:           {
                                    name:lookup(loc,"Talk::Name"),
                                    message:lookup(loc,"Talk::Message"),
                                    color:FlxColor.colorLookup[lookup(loc, "Talk::Color")]
                                }
            }


            for(n in itemNames) {
                pi.items[n] = {
                    name:n,
                    produces : ~/X/i.match(lookup(loc, 'Item::$n::Produces' )),
                    basePrice: Std.parseInt(lookup(loc, 'Item::$n::BasePrice')),
                    maxStock : Std.parseInt(lookup(loc, 'Item::$n::MaxStock')),
                    startStock:Std.parseInt(lookup(loc, 'Item::$n::StartStock'))
                }
            }

            Data.Info[pi.name] = pi;
        }

    }

    public static function Match(E:Enum<Dynamic>, S:String):Dynamic {
        for(v in Type.allEnums(E))
            if(Std.string(v) == S)
                return v;

        return null;
    }

}
