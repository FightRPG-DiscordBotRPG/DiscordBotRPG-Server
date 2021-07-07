const conn = require("../../conf/mysql.js");
const Appearance = require("./Appearance.js");

class ItemAppearance {

    constructor() {
        /** Body Type : Appearance 
         * For all body types key is : all
         * @type {Object<string, Appearance>}
         **/
        this.appearances = {};
    }

    async load(id, idBodyType) {
        this.id = id;
        let data = await conn.query(`SELECT idAppearance, propertyName FROM itemsappearances INNER JOIN appearances USING (idAppearance) INNER JOIN appearancestype USING(idAppearanceType) WHERE idBaseItem = ?`, [this.id]);
        for (let item of data) {
            const bodyType = Appearance.appearancesList[item.idAppearance].idBodyType ?? "all";
            if (!this.appearances[bodyType]) {
                this.appearances[bodyType] = {};
            }
            this.appearances[bodyType][item.propertyName] = Appearance.appearancesList[item.idAppearance];
        }
    }

}


module.exports = ItemAppearance;

