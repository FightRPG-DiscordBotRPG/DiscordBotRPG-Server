const conn = require("../../../conf/mysql");
const Globals = require("../../Globals");
const RandomLootBox = require("./RandomLootBox");

class EquipmentRandomLootBox extends RandomLootBox {

    static itemsListCacheValue = {};

    constructor(id) {
        super(id);
    }

    async prepareToUse() {
        if (EquipmentRandomLootBox.itemsListCacheValue[this.idBaseItem]) {
            this.itemsList = EquipmentRandomLootBox.itemsListCacheValue[this.idBaseItem];
        } else {
            // Depend on rarity like equipment lootbox
            // Only head,chest,legs,weapon
            if (Globals.equipsPossible.length > 0) {
                // PENDING more automated non selection of mount
                let possibleItems = await conn.query("SELECT idBaseItem FROM itemsbase WHERE idRarity = ? AND idType IN (1,2,3,4)", [this.getIdRarity()]);
                for (let pi of possibleItems) {
                    this.itemsList.push({
                        id: pi.idBaseItem,
                        amount: 1,
                        rarityDrop: this.getIdRarity(),
                        dropRate: Globals.getDropChances(this.getIdRarity()) / 10,
                    });
                }

                EquipmentRandomLootBox.itemsListCacheValue[this.idBaseItem] = this.itemsList;
            }
        }

    }
}

module.exports = EquipmentRandomLootBox;