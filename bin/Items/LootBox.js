const Item = require("./Item");
const Consumable = require("./Consumable");


class LootBox extends Consumable {
    constructor(id) {
        super(id);
        this.openResult = {items : [], gold: 0}
    }

    use(character) {
        throw "Must be implemented - LootBox";
    }

    addItem(id, number) {
        let item = {id: id, number:number};
        this.openResult.items.push(item);
    }

    resultToString(lang) {
        let msg = "Vous avez ouvert une lootbox, vous obtenez : \n";
        let drop = false;

        if(this.openResult.items.length > 0) {
            for(let i=0; i<this.openResult.items.length; i++) {
                msg += Item.getName(lang, this.openResult.items[i].id) + " [x" + this.openResult.items[i].number + "]";
                if(i < (this.openResult.items-1)) {
                    msg += ",";
                }   
            }
            drop = true;
        }
        if(this.openResult.gold > 0) {
            msg += "\n%dG";
            drop = true;
        }

        if(drop == false ) {
            msg = "Vous avez ouvert une lootbox, mais vous n'avez rien eu !";
        }

        return msg;

    }

}

module.exports = LootBox;