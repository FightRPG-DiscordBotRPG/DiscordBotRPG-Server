const conn = require("../../conf/mysql");

class Effect {
    constructor() {
        this.id = 0;
        this.idEffectType = 0;
        this.percentageValue = 0;
        this.fixedValue = 0;
        this.stateValue = null;
        this.statValue = null;
        this.roundsValue = 0;
    }

    async loadWithID(id) {
        this.id = id;
        let res = await conn.query("SELECT * FROM effectsskills WHERE idEffectSkill = ?;", [this.id]);

        this.idEffectType = res[0].idEffectType;
        this.percentageValue = res[0].percentageValue;
        this.fixedValue = res[0].fixedValue;
        this.stateValue = res[0].stateValue;
        this.statValue = res[0].statValue;
        this.roundsValue = res[0].roundsValue;
    }
}

module.exports = Effect;