const RebirthData = require("./RebirthData");

class RebirthApiData {
    constructor() {
        this.level = 0;
        this.rebirthLevel = 0;
        this.maxLevel = 0;
        this.maxRebirthLevel = 0;
        /**
         * @type {RebirthData}
         */
        this.currentRebirthsLevelsModifiers = null;
        /**
         * @type {RebirthData}
         */
        this.nextRebirthsLevelsModifiers = null;
    }
}

module.exports = RebirthApiData;