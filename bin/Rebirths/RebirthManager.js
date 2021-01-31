const RebirthData = require("./RebirthData");
const conn = require("../../conf/mysql");

class RebirthManager {
    constructor() {
        /**
         * @type {Object<number, RebirthData>}
         **/
        this.rebirthsLevelsModifiers = {};
        this.maxRebirthLevel = 0;
    }

    async load() {
        let res = await conn.query("SELECT * FROM rebirthspossibles;");
        let promises = [];
        for (let rebirth of res) {
            let rebirthDataObject = RebirthData.loadFromData(rebirth);
            this.rebirthsLevelsModifiers[rebirth.rebirthLevel] = rebirthDataObject;
            promises.push(rebirthDataObject.loadRequirements());
            if (rebirthDataObject.rebirthLevel > this.maxRebirthLevel) {
                this.maxRebirthLevel = rebirthDataObject.rebirthLevel;
            }
        }

        await Promise.all(promises);
    }
}

module.exports = RebirthManager;