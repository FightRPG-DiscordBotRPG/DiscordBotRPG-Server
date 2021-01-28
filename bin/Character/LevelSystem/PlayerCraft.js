'use strict'
const BaseLevelSystem = require("./BaseLevelSystem");

class PlayerCraft extends BaseLevelSystem {

    constructor() {
        super();
        this.databaseTable = "characterscraftlevel";
        this.achievementsToUnlocksForLevels = {
            20: 14,
            100: 15
        };
        this.achievementsToUnlocksForRebirthLevels = {};
    }

}

module.exports = PlayerCraft;