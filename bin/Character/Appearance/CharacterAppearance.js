const conn = require("../../../conf/mysql.js");
const Globals = require("../../Globals.js");
const Appearance = require("./Appearance.js");

class CharacterAppearance {
    constructor() {
        this.id = null;
        this.hairColor = "#241C11";
        this.bodyColor = "#CE8E71";
        this.eyeColor = "#634E34";
        this.idBodyType = 1;
        this.displayHelmet = true;
        this.appearances = {};
        this.body = null;
    }

    async init(id) {
        this.id = id;
        await conn.query(`INSERT INTO charactersappearance VALUES (?, "#241C11", "#CE8E71", "#634E34", 1, 1);`, [this.id]);
        await conn.query(`INSERT INTO charactersappearanceparts VALUES (SELECT ?, idAppearance, idAppearanceType FROM appearances WHERE idAppearanceType IN (1,2,3,4,5,7,8,9,10) GROUP BY idAppearanceType)`, [this.id]);
        await this.load(id);
    }

    async load(id) {
        this.id = id;
        let data = (await conn.query(`SELECT * FROM charactersappearance WHERE idCharacter = ?;`, [this.id]))[0];

        this.hairColor = data.hairColor;
        this.bodyColor = data.bodyColor;
        this.eyeColor = data.eyeColor;
        this.idBodyType = data.idBodyType;
        this.displayHelmet = data.displayHelmet;
        this.body = Globals.bodiesLinks[data.idBodyType];

        this.appearances = {};

        for (let item of (await conn.query(`SELECT * FROM charactersappearanceparts INNER JOIN appearancestype USING(idAppearanceType) INNER JOIN appearances USING (idAppearance) WHERE idCharacter = ?;`, [this.id]))) {
            let appearance = new Appearance();
            appearance.appearanceType = item.appearanceType;
            appearance.canBeDisplayedOnTop = item.canBeDisplayedOnTop;
            appearance.id = item.idAppearance;
            appearance.idBodyType = item.idBodyType;
            appearance.link = item.link;
            this.appearances[item.propertyName] = appearance;
        }


    }

}


module.exports = CharacterAppearance;

