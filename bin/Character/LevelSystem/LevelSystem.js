'use strict';
const BaseLevelSystem = require("./BaseLevelSystem");

class LevelSystem extends BaseLevelSystem {

    constructor() {
        super();
        this.databaseTable = "levels";
        this.achievementsToUnlocksForLevels = {
            20: 8,
            100: 9
        };
        this.achievementsToUnlocksForRebirthLevels = {
            1: 21,
            2: 22,
            5: 24,
        };

    }

}

module.exports = LevelSystem;