class ItemLootData {
    constructor() {
        this.percentage = 0;
        this.min = 1;
        this.max = 1;
        this.idBaseItem = 0;
        this.idRarity = 0;
        this.equipable = false;
    }

    static mergeLootTables(lootTableA, lootTableB) {
        let lootTableToReturn = {};
        for (let i in lootTableA) {
            if (lootTableB[i]) {
                lootTableToReturn[i] = [...lootTableA[i], ...lootTableB[i]];
            } else {
                lootTableToReturn[i] = lootTableA[i];
            }
        }
        return lootTableToReturn;
    }
}

module.exports = ItemLootData;