package;

import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.FlxSprite;
import Data;
using ScaledSprite;
using flixel.util.FlxSpriteUtil;
import flixel.util.FlxCollision;
import flixel.FlxG;

class Inventory extends FlxGroup {

    var bg:FlxSprite;
    public var selected:Item = null;

    var heading:FlxText;
    var screenTitle:FlxText;
    var itemImg:FlxSprite;
    var inStockText:FlxText;
    var itemDesc:FlxText;
    var totElapsed:Float = 0;

    override public function new() {

        super();

        selected = null;

        bg = new FlxSprite("assets/images/inven.png");
        bg.scaleUp();
        add(bg);

        var TL = {x:230,y:90};
        var TM = {x:380,y:90};

        var i = 0;
        for(item in Data.Cargo.allItems()) {
            var b = new InventoryButton(i++, item, function() {
                switchItem(item);
            });
            add(b);
        }


        screenTitle = new FlxText(TM.x, TM.y, 440);
        screenTitle.setFormat("assets/pixelade.ttf", 40, 0xffffffff, CENTER);
        screenTitle.text = "CARGO VIEWER 2000";
        add(screenTitle);

        heading = new FlxText(TM.x+10, TM.y+50);
        heading.setFormat("assets/pixelade.ttf", 50, 0xffffffff);
        if(Data.Cargo.allItems().length == 0)
            heading.text = "Cargo hold is empty.";
        add(heading);

        inStockText = new FlxText(TM.x+10, TM.y+55, 590);
        inStockText.setFormat("assets/pixelade.ttf", 32, 0xff999999, RIGHT);
        add(inStockText);

        itemImg  = new FlxSprite(650, 190);
        itemImg.visible = false;
        add(itemImg);

        itemDesc = new FlxText(TM.x+10, TM.y+220, 590);
        itemDesc.setFormat("assets/pixelade.ttf", 30, 0xffffffff);
        add(itemDesc);

    }

    public function switchItem(I:Item) {
        selected = I;

        var name = Std.string(selected);
        heading.text = name.substr(0,1)+name.substr(1).toLowerCase();

        itemImg.loadGraphic('assets/images/items/${name.toLowerCase()}.png');
        itemImg.scaleUp();
        itemImg.scale.set(5,5);
        itemImg.x = 690 - (itemImg.width/2*itemImg.scale.x);
        itemImg.visible = true;

        itemDesc.text = Data.ItemDetails[I];

        inStockText.text = Std.string(Data.Cargo.getAmount(I)) + " in cargo";
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        totElapsed += elapsed;
        var mpos = FlxG.mouse.getScreenPosition();

        if(totElapsed < 0.1) return;
        if(FlxG.mouse.justPressed &&
                ( mpos.x < 110
               || mpos.y < 60
               || mpos.x > 1010
               || mpos.y > 540 )) {
            kill();
            ShipScreen.CurrentMode = NORMAL;
        }

    }

}

class InventoryButton extends FlxSpriteGroup {

    var TextColor:Int   = 0xffffffff;
    var CountColor:Int  = 0xffffffff;
    var BorderColor:Int = 0xff238f00;
    var SelColor:Int    = 0xff164700;
    var ButtonWidth     = 230;
    var ButtonHeight    =  80;
    var TopLeft         = {x:140, y:90};

    var bg:FlxSprite;
    var itemLabel:FlxText;
    var countBg:FlxSprite;
    var countLabel:FlxText;
    var callback:Void->Void;
    var thumb:FlxSprite;

    var index:Int;
    public var item:Item;

    override public function new(Index:Int, Item:Item, Callback:Void->Void) {

        super();

        item = Item;
        index = Index;

        bg = new FlxSprite();
        bg.makeGraphic(ButtonWidth, ButtonHeight, SelColor);
        bg.drawRect(0,ButtonHeight-10,ButtonWidth,10,BorderColor);
        add(bg);

        var name = Std.string(item);

        thumb = new FlxSprite('assets/images/itemthumbnail/${name.toLowerCase()}.png');
        add(thumb);
        thumb.x = 10;
        thumb.y = 10;
        thumb.scaleUp(5);

        itemLabel = new FlxText(80,12);
        itemLabel.setFormat("assets/pixelade.ttf", 40, TextColor);
        itemLabel.text = name.substr(0,1)+name.substr(1).toLowerCase();
        add(itemLabel);

        countBg    = new FlxSprite(170, 19);
        countBg.makeGraphic(50,29, 0xff000000);
        add(countBg);

        countLabel = new FlxText(0,22,ButtonWidth-10);
        countLabel.setFormat("assets/dseg.ttf", 20, CountColor,RIGHT);
        countLabel.text = Std.string(Data.Cargo.getAmount(item));
        add(countLabel);

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
