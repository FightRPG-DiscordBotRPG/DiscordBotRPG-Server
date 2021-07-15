const conn = require("../../conf/mysql.js");
const Appearance = require("./Appearance.js");

class ItemAppearance {

    /**
     * @type {Object<string, Object<string, Object<string, Appearance>>}
     */
    static appearances = {}

    constructor() {
        /** Body Type : Appearance 
         * For all body types key is : all
         * @type {Object<string, Appearance>}
         **/
        this.appearances = {};
    }

    async load(id) {
        this.appearances = ItemAppearance.appearances[id];
    }

    static async loadItemsAppearances() {
        ItemAppearance.appearances = {};

        let maskColorsData = {};
        for (let item of await conn.query("SELECT * FROM itemsappearancesmaskcolors")) {
            if (!maskColorsData[item.idBaseItem]) {
                maskColorsData[item.idBaseItem] = {};
            }

            if (!maskColorsData[item.idBaseItem][item.idAppearance]) {
                maskColorsData[item.idBaseItem][item.idAppearance] = [];
            }

            maskColorsData[item.idBaseItem][item.idAppearance].push({ source: item.sourceColor, target: item.targetColor });
        }

        for (let item of await conn.query("SELECT idBaseItem, idAppearance, propertyName FROM itemsappearances INNER JOIN appearances USING (idAppearance) INNER JOIN appearancestype USING(idAppearanceType)")) {
            const bodyType = Appearance.appearancesList[item.idAppearance].idBodyType ?? "all";
            if (!ItemAppearance.appearances[item.idBaseItem]) {
                ItemAppearance.appearances[item.idBaseItem] = {};
            }

            if (!ItemAppearance.appearances[item.idBaseItem][bodyType]) {
                ItemAppearance.appearances[item.idBaseItem][bodyType] = {};
            }

            let maskColors = {};
            if (maskColorsData[item.idBaseItem] && maskColorsData[item.idBaseItem][item.idAppearance]) {
                maskColors = maskColorsData[item.idBaseItem][item.idAppearance];
            }

            ItemAppearance.appearances[item.idBaseItem][bodyType][item.propertyName] = Object.assign({ maskColors: maskColors }, Appearance.appearancesList[item.idAppearance]);
        }

        // Update linked appearances for items
        for (let idItem in ItemAppearance.appearances) {
            for (let bodyType in ItemAppearance.appearances[idItem]) {
                for (let property in ItemAppearance.appearances[idItem][bodyType]) {
                    const item = ItemAppearance.appearances[idItem][bodyType][property];

                    if (item.linkedTo.length === 0) {
                        continue;
                    }

                    for (let link of item.linkedTo) {
                        const linkedAppearance = Appearance.appearancesList[link];
                        if (ItemAppearance.appearances[idItem][bodyType][linkedAppearance.propertyName] == null) {
                            ItemAppearance.appearances[idItem][bodyType][linkedAppearance.propertyName] = Object.assign({maskColors: item.maskColors}, linkedAppearance);
                        }
                    }

                }
            }
        }

    }

}


module.exports = ItemAppearance;

