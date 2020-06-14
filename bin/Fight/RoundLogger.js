const EntityAffectedLogger = require("./EntityAffectedLogger");

class RoundLogger {

    constructor() {

        this.roundType = "";
        this.roundEntitiesIndex = 0;
        this.idSkillUsed = 0;

        this.drain = false;
        this.heal = false;
        this.success = false;
        this.addingState = false;
        this.attacker = new EntityAffectedLogger();
        /**
         * @type {Array<EntityAffectedLogger>}
         **/
        this.defenders = [];
    }

}

module.exports = RoundLogger;