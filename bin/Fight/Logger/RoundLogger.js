const EntityAffectedLogger = require("./EntityAffectedLogger");

class RoundLogger {

    constructor() {

        this.roundType = "";
        this.roundEntitiesIndex = 0;
        this.skillInfo = {
            id: 0,
            message: ""
        }

        this.drain = false;
        this.heal = false;
        this.success = false;
        this.addingState = false;
        this.restrictions = {};
        /**
         * @type {EntityAffectedLogger}
         **/
        this.attacker = {};
        /**
         * @type {Array<EntityAffectedLogger>}
         **/
        this.defenders = [];
    }

}

module.exports = RoundLogger;