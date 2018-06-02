package;

import Data;

@:generic
class Storage<T:EnumValue> {

    var map:Map<T,Int>;

    public function new() {
        map = new Map();
    }

    public function add(Item:T, Amount:Int) {

        if(map[Item] == null) map[Item] = 0;

        map[Item] += Amount;

    }

    public function getAmount(Item:T):Int {
        if(map[Item] == null) return 0;

        return map[Item];
    }

    public function setAmount(Item:T, Amount:Int) {
        map[Item] = Amount;
    }

    public function remove(Item:T, Amount:Int) {
        if(map[Item] == null) return false;
        if(map[Item] < Amount) return false;

        map[Item] -= Amount;

        return true;
    }

    public function allItems():Array<T> {
        var x = [];
        for(k in map.keys()) {
            x.push(k);
        }
        return x;
    }

}
