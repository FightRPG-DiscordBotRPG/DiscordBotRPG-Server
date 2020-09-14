const Trait = require("./Trait");
const Utils = require("../Utilities/Utils");
const conn = require("../../conf/mysql");
const Translator = require("../Translator/Translator");


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
            promises.push(t.loadWithID(item.idTrait));
        }

        await Promise.all(promises);

        this.resetCounts();
    }

    resetCounts() {
        this.roundEnd = Utils.randRangeInt(this.roundMin, this.roundMax);
        this.currentRound = 1;
    }

    /**
     *  Returns true if state expire after rounds 
     **/
    isExpired() {
        return this.afterRounds && this.currentRound > this.roundEnd;
    }

    isRemovedByRestriction() {
        return this.idStateRestriction != null;
    }

    getName(lang="en") {
        return Translator.getString(lang, "statesNames", this.id);
    }

    toApi(lang="en") {
        return {
            id: this.id,
            name: this.getName(lang),
            traits: this.traits,
            afterDamage: this.afterDamage,
            afterFight: this.afterFight,
            afterRounds: this.afterRounds,
            roundsLeft: this.roundEnd - this.currentRound
        }
    }

}


module.exports = State;