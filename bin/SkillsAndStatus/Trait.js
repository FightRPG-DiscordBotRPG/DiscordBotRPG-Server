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
        this.valueSkill = null;
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
        this.valueSkill = res[0].valueSkill;
    }

    static TraitTypesNames = {
        ElementAttack: 1,
        StatusCertain: 2,
        StatsParam: 3,
        ElementRate: 4,
        StatsDebuff: 5,
        StatusDebuff: 6,
        StatusResist: 7,
        QuietSkills: 8,
        SecondaryStatsDebuff: 9,
        QuietSpecificSkill: 10,
    }


    getNumericValue() {
        return this.valueInt || this.valueFloat || 0;
    }

    getFloatValue() {
        return this.valueFloat || 1;
    }

    getNumberValue() {
        return this.valueInt || 0;
    }

    getSingleValue() {
        return this.valueElementType || this.valueFloat || this.valueInt || this.valueSkill || this.valueSkillType || this.valueStat || this.valueState;
    }

    getStatName() {
        return 
    }
}

module.exports = Trait;