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
        for (let i of [...Object.keys(lootTableA), ...Object.keys(lootTableB)]) {
            if (lootTableB[i] && lootTableA[i]) {
                lootTableToReturn[i] = [...lootTableA[i], ...lootTableB[i]];
            } else if (lootTableA[i] && !lootTableB[i]) {
                lootTableToReturn[i] = lootTableA[i];
            } else {
                lootTableToReturn[i] = lootTableB[i];
            }
        }
        return lootTableToReturn;
    }
}

module.exports = ItemLootData;