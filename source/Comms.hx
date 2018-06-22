package;

import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.FlxSprite;
import Data;
using ScaledSprite;
using flixel.util.FlxSpriteUtil;
import flixel.util.FlxCollision;
import haxe.ds.Either;
import flixel.FlxG;

class Comms extends FlxGroup {

    var bg:FlxSprite;
    public var selected:CommOption = null;

    var heading:FlxText;
    var warning:FlxText;
    var screenTitle:FlxText;
    var itemImg:FlxSprite;
    var inStockText:FlxText;
    var itemDesc:FlxText;
    var totElapsed:Float = 0;

    var rightItems:FlxGroup;

    override public function new() {

        super();

        selected = null;

        bg = new FlxSprite("assets/images/inven.png");
        bg.scaleUp();
        add(bg);

        var TL = {x:230,y:90};
        var TM = {x:470,y:90};

        var i = 0;

        var loc = Data.CurrentLocation;
        switch(Data.Info[loc].type) {
            case Planet:
                for(opt in [TALK,BUY,SELL]) {
                    var b = new CommsBtn(i++, opt, function() {
                        switchOption(opt);
                    });
                    add(b);
                };
            case SpaceStation:
                for(opt in [TALK, REFUEL]) {
                    var b = new CommsBtn(i++, opt, function() {
                        switchOption(opt);
                    });
                    add(b);
                }
        }

        screenTitle = new FlxText(TM.x, TM.y, 440);
        screenTitle.setFormat("assets/pixelade.ttf", 40, 0xffffffff, CENTER);
        screenTitle.text = "REMOTE COMMUNICATOR 8000";
        add(screenTitle);

        heading = new FlxText(TM.x+10, TM.y+50);
        heading.setFormat("assets/pixelade.ttf", 50, 0xffffffff);
        add(heading);

        warning = new FlxText(TM.x+10, TM.y+100);
        warning.setFormat("assets/pixelade.ttf", 30, 0xffffffff);
        add(warning);

        /*
        inStockText = new FlxText(TM.x+10, TM.y+55, 410);
        inStockText.setFormat("assets/pixelade.ttf", 32, 0xff999999, RIGHT);
        add(inStockText);

        itemImg  = new FlxSprite(650, 190);
        itemImg.visible = false;
        add(itemImg);

        itemDesc = new FlxText(TM.x+10, TM.y+220, 420);
        itemDesc.setFormat("assets/pixelade.ttf", 30, 0xffffffff);
        add(itemDesc);
        */

        rightItems = new FlxGroup();
        add(rightItems);

    }

    public function switchOption(I:CommOption) {
        selected = I;

        var name = Std.string(selected);
        heading.text = name.substr(0,1)+name.substr(1).toLowerCase();

        rightItems.clear();
        warning.text = "";

        switch(I) {
            case TALK:
                kill();
                ShipScreen.CurrentMode = TALK;
                var ss = cast(FlxG.state, ShipScreen);
                ss.add(new TalkDialog());

            case BUY:
                var stock = Data.Info[Data.CurrentLocation].stock.allItems().filter(
                        function(i) return Data.Info[Data.CurrentLocation].items[i].basePrice != null);
                if(stock.length == 0)
                    warning.text = "This location has no goods to sell.";


                var opt:Int = 0;
                for(i in stock) {
                    var b = new TradeBtn(opt++, i, BUY);
                    rightItems.add(b);
                }


            case SELL:
                var cargo = Data.Cargo.allItems().filter(
                        function(i) return Data.Info[Data.CurrentLocation].items[i].basePrice != null);
                if(cargo.length == 0)
                    warning.text = "There are no goods in cargo.";

                var opt:Int = 0;
                for(i in cargo) {
                    var b = new TradeBtn(opt++, i, SELL);
                    rightItems.add(b);
                }

            case REFUEL:
                var b = new TradeBtn(0, "FUEL", REFUEL);
                rightItems.add(b);

        }

    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        totElapsed += elapsed;
        var mpos = FlxG.mouse.getScreenPosition();

        if(totElapsed < 0.1) return;
        if(FlxG.mouse.justPressed &&
                ( mpos.x < 200
               || mpos.y < 60
               || mpos.x > 930
               || mpos.y > 540 )) {
            kill();
            ShipScreen.CurrentMode = NORMAL;
        }

    }

}

class CommsBtn extends FlxSpriteGroup {

    var TextColor:Int   = 0xffffffff;
    var CountColor:Int  = 0xffffffff;
    var BorderColor:Int = 0xff238f00;
    var SelColor:Int    = 0xff164700;
    var ButtonWidth     = 230;
    var ButtonHeight    =  80;
    var TopLeft         = {x:230, y:90};

    var bg:FlxSprite;
    var itemLabel:FlxText;
    var countBg:FlxSprite;
    var countLabel:FlxText;
    var callback:Void->Void;
    var thumb:FlxSprite;

    var index:Int;
    public var option:CommOption;

    override public function new(Index:Int, Option:CommOption, Callback:Void->Void) {

        super();

        option = Option;
        index = Index;

        bg = new FlxSprite();
        bg.makeGraphic(ButtonWidth, ButtonHeight, SelColor);
        bg.drawRect(0,ButtonHeight-10,ButtonWidth,10,BorderColor);
        add(bg);

        var name = Std.string(Option);

        thumb = new FlxSprite('assets/images/commthumbnail/${name.toLowerCase()}.png');
        add(thumb);
        thumb.x = 10;
        thumb.y = 10;
        thumb.scaleUp();

        itemLabel = new FlxText(80,12);
        itemLabel.setFormat("assets/pixelade.ttf", 40, TextColor);
        itemLabel.text = name.substr(0,1)+name.substr(1).toLowerCase();
        add(itemLabel);

        x = TopLeft.x;
        y = TopLeft.y + ButtonHeight * index;

        callback = Callback;

    }

    override public function update(elapsed:Float) {

        super.update(elapsed);

        if(FlxG.mouse.justPressed && bg.overlapsPoint(FlxG.mouse.getScreenPosition()))
            callback();


    }

}

class TradeBtn extends FlxSpriteGroup {

    var TextColor:Int   = 0xffffffff;
    var CountColor:Int  = 0xffffffff;
    var BorderColor:Int = 0xff000000;
    var SelColor:Int    = 0xff164700;
    var ButtonWidth     = 430;
    var ButtonHeight    =  80;
    var TopLeft         = {x:470, y:200};

    var bg:FlxSprite;
    var itemLabel:FlxText;
    var countBg:FlxSprite;
    var countLabel:FlxText;
    var thumb:FlxSprite;

    var name:String;

    var stockLabel:FlxText;

    var costLabel:CashReadout.Cash;

    var index:Int;
    var type:CommOption;
    public var item:Item;
    public var stock:Int;
    public var cost:Int;

    override public function new(Index:Int, Item:Item, Type:CommOption) {

        super();

        item = Item;
        index = Index;
        type = Type;

        bg = new FlxSprite();
        bg.makeGraphic(ButtonWidth, ButtonHeight, SelColor);
        bg.drawRect(0,ButtonHeight-10,ButtonWidth,10,BorderColor);
        add(bg);

        name = Std.string(item);

        thumb = new FlxSprite('assets/images/itemthumbnail/${name.toLowerCase()}.png');
        add(thumb);
        thumb.x = 10;
        thumb.y = 10;
        thumb.scaleUp(5);

        var info = Data.Info[Data.CurrentLocation];
        cost = (type == SELL || type == REFUEL)
            ? info.items[item].basePrice
            : info.prices[item];

        var costBg = new FlxSprite(ButtonWidth-230, 10).makeGraphic(80,50, 0xff000000, true);
        add(costBg);

        costLabel = new CashReadout.Cash(ButtonWidth-230, 15, 80);
        costLabel.text.text = Std.string(cost);
        add(costLabel);

        itemLabel = new FlxText(80,12);
        itemLabel.setFormat("assets/pixelade.ttf", 40, TextColor);
        itemLabel.text = name.substr(0,1)+name.substr(1).toLowerCase();

        itemLabel.addFormat(new FlxTextFormat(0xff666666), name.length, 1000);
        add(itemLabel);

        updateStock();

        var tradeFunc = [
            BUY => buyStock,
            SELL => sellStock,
            REFUEL => buyFuel
        ][type];

        var x1 = new TradeAmtButton(1, tradeFunc.bind(item), this);
        x1.x = ButtonWidth-140;
        x1.y = 10;
        add(x1);

        var x10 = new TradeAmtButton(10, tradeFunc.bind(item), this);
        x10.x = ButtonWidth-70;
        x10.y = 10;
        add(x10);

        x = TopLeft.x;
        y = TopLeft.y + ButtonHeight * index;


    }

    function buyFuel(Item:Item, Amount:Int) {
        if(type != REFUEL) return;

        if(Amount * cost > Data.Cash) return;
        if(stock < Amount) return;

        Data.Fuel += Amount;
        Data.Cash -= Amount * cost;

    }

    function buyStock(Item:Item, Amount:Int) {
        if(type != BUY) return;
        if(stock <  Amount) return;
        if(Amount * cost > Data.Cash) return;

        Data.Cash -= Amount * cost;

        Data.Cargo.add(Item, Amount);
        Data.Info[Data.CurrentLocation].stock.remove(Item, Amount);
    }

    function sellStock(Item:Item, Amount:Int) {
        if(type != SELL) return;
        if(stock < Amount) return;

        Data.Cash += Amount * cost;

        Data.Cargo.remove(Item, Amount);
        Data.Info[Data.CurrentLocation].stock.add(Item, Amount);
    }

    function updateStock() {

        itemLabel.text = name.substr(0,1)+name.substr(1).toLowerCase();

        switch(type) {
            case BUY:    stock = Data.Info[Data.CurrentLocation].stock.getAmount(item);
            case SELL:   stock = Data.Cargo.getAmount(item);
            case REFUEL: stock = Data.MaxFuel - Data.Fuel;
            default:
                         throw "Stock update during TALK option?";
        }

        if(type != REFUEL) {
            itemLabel.text += 'x$stock';
        }

    }

    override public function update(elapsed:Float) {

        super.update(elapsed);

        updateStock();

    }

}

class TradeAmtButton extends FlxSpriteGroup {

    var TextColor:Int = 0xffffffff;
    var BgColorActive:Int = 0xff999999;

    var bg:FlxSprite;
    var callback:Int->Void;

    var ButtonWidth     = 60;
    var ButtonHeight    = 50;

    var label:FlxText;
    var parent:TradeBtn;

    var amt:Int;


    override public function new(Amt:Int, Callback:Int->Void, Parent:TradeBtn) {

        super();

        amt = Amt;
        parent = Parent;

        bg = new FlxSprite();
        bg.makeGraphic(ButtonWidth, ButtonHeight, BgColorActive);
        add(bg);

        label = new FlxText(10,5, 'x$amt');
        label.setFormat("assets/pixelade.ttf", 40, TextColor);
        add(label);

        callback = Callback;

    }



    override public function update(elapsed:Float) {

        super.update(elapsed);

        if(FlxG.mouse.justPressed && bg.overlapsPoint(FlxG.mouse.getScreenPosition()))
            callback(amt);

        if(parent.stock >= amt) {
            color = 0xffffffff;
        }
        else {
            color = 0xff999999;
        }

    }


}

enum CommOption {
    TALK;
    BUY;
    SELL;
    REFUEL;
}
