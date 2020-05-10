const conn = require("../../conf/mysql");

class Trait {
    constructor() {
        this.id = 0;
        this.idTraitType = 0;
        this.valueInt = null;
        this.valueFloat = null;
        this.valueState = null;
        this.valueElementType = null;
        this.valueSkillType = null;
        this.valueStat = null;
    }

    async loadWithID(id) {
        this.id = id;
        let res = await conn.query("SELECT * FROM traits WHERE idTrait = ?", [this.id]);

        this.idTraitType = res[0].idTraitType;
        this.valueFloat = res[0].valueFloat;
        this.valueState = res[0].valueState;
        this.valueElementType = res[0].valueElementType;
        this.valueSkillType = res[0].valueSkillType;
        this.valueStat = res[0].valueStat;
    }

}

module.exports = Trait;