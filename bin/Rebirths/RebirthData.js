const conn = require("../../conf/mysql");

class RebirthData {
    constructor() {
        this.rebirthLevel = 0;
        this.nbrOfStatsPointsPerLevel = 0;
        this.nbrOfTalentPointsBonus = 0;
        this.percentageBonusToMonstersStats = 0;
        this.percentageBonusToItemsStats = 0;
        /**
         * @type {SimpleItemData[]}
         * */
        this.requiredItems = [];
    }

    /**
     * 
     * @param {any} data
     * @returns {RebirthData}
     */
    static loadFromData(data) {
        return Object.assign(new RebirthData(), data);
    }

    async loadRequirements() {
        let res = await conn.query(`SELECT imageItem, nomType, nomRarity, couleurRarity, nomSousType, number, itemsbase.idBaseItem, rebirthspossiblesitemsneeded.minRebirthLevel, rebirthspossiblesitemsneeded.rebirthLevel FROM rebirthspossiblesitemsneeded 
            INNER JOIN rebirthspossibles USING(rebirthLevel)
            INNER JOIN itemsbase USING(idBaseItem)
            INNER JOIN itemstypes USING(idType)
            INNER JOIN itemsrarities USING(idRarity)
            INNER JOIN itemssoustypes USING(idSousType)
            WHERE rebirthspossiblesitemsneeded.rebirthLevel = ?;`, [this.rebirthLevel]);

        for (let item of res) {
            const SimpleItemData = require("../Items/SimpleItemData");
            this.requiredItems.push(SimpleItemData.createFromData({
                idBase: item.idBaseItem,
                typename: item.nomType,
                stypename: item.nomSousType,
                rarity: item.nomRarity,
                number: item.number,
                minRebirthLevel: item.minRebirthLevel,
            }));
        }
    }

    /**
     * 
     * @param {Character} character
     * @param {any} lang
     */
    async toApi(character, lang = "en") {
        let data = Object.assign(new RebirthData(), this);
        data = await character.inv.getRebirthRequiredItems(data);
        let tempRequiredItems = [];

        for (let item of data.requiredItems) {
            tempRequiredItems.push(item.toApi(lang));
        }

        data.requiredItems = tempRequiredItems;

        return data;
    }
}

module.exports = RebirthData;

/**
 * 
 * @typedef {import("../Items/SimpleItemData")} SimpleItemData;
 * @typedef {import("../Character")} Character;
 * 
 * */
