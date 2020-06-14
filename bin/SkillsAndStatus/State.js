const Trait = require("./Trait");
const Utils = require("../Utilities/Utils");


class State {

    constructor() {
        this.id = 0;
        this.shorthand = "";
        this.roundMin = 1;
        this.roundMax = 1;
        this.roundEnd = 1;
        this.afterFight = false;
        this.afterDamage = false;
        this.afterRounds = false;
        this.damageProbability = 0;
        this.idStateRestriction = 0;
        /**
         * @type {Array<Trait>}
         */
        this.traits = [];
        this.currentRound = 1;
    }

    async loadWithID(id) {
        this.id = id;

        let res = await conn.query("SELECT * FROM states INNER JOIN statesremovalconditions ON statesremovalconditions.idState = states.idState WHERE states.idState = ?;", [this.id]);

        this.shorthand = res[0].shorthand;
        this.roundMin = res[0].roundMin;
        this.roundMax = res[0].roundMax;
        this.afterFight = res[0].afterFight;
        this.afterDamage = res[0].afterDamage;
        this.afterRounds = res[0].afterRounds;
        this.damageProbability = res[0].damageProbability;
        this.idStateRestriction = res[0].idStateRestriction;

        res = await conn.query("SELECT * FROM statestraits WHERE idState = ?;", [this.id]);
        let promises = [];
        for (let item of res) {
            let t = new Trait();
            this.traits.push(t);
            promises.push(t.loadWithID(item.idState));
        }

        await Promise.all(promises);

        this.roundEnd = Utils.randRangeInt(this.roundMin, this.roundMax);
    }

    /**
     *  Returns true if state expire after rounds 
     **/
    isExpired() {
        return state.afterRounds && state.currentRound > state.roundEnd;
    }


}


module.exports = State;