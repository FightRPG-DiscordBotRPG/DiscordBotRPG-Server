const conn = require("../../../conf/mysql.js");
const Globals = require("../../Globals.js");
const Appearance = require("./Appearance.js");

class CharacterAppearance {

    /**
     * @type {Object<number, CharacterAppearance>}
     **/
    static appearancesList = {};

    /**
     * @type {Object<number, number[]>}
     **/
    static linkedAppearances = {};

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
        await conn.query(`INSERT INTO charactersappearanceparts VALUES (SELECT ?, idAppearance, idAppearanceType FROM appearances WHERE idAppearanceType IN (1,2,3,4,5,7,9,10) GROUP BY idAppearanceType)`, [this.id]);
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

        for (let item of (await conn.query(`SELECT idAppearance, propertyName FROM charactersappearanceparts INNER JOIN appearances USING (idAppearance) INNER JOIN appearancestype USING(idAppearanceType) WHERE idCharacter = ?;`, [this.id]))) {
            this.appearances[item.propertyName] = CharacterAppearance.appearancesList[item.idAppearance];
        }

    }

    static async getAllPossibleAppearances(reload = false) {
        if (reload) {
            await CharacterAppearance.loadAllPossibleAppearances();
        }
        return CharacterAppearance.appearancesList;
    }

    static async loadAllPossibleAppearances() {
        // Take all character related appearance
        // Maybe use a list next time
        let res = await conn.query(`SELECT * FROM appearances WHERE idAppearanceType <= 10`);
        let allLinks = await conn.query(`SELECT * FROM linkedappearances`);

        CharacterAppearance.linkedAppearances = {};
        CharacterAppearance.appearancesList = {};

        for (let link of allLinks) {
            if (!CharacterAppearance.linkedAppearances[link.idAppearance]) {
                CharacterAppearance.linkedAppearances[link.idAppearance] = [];
            }

            if (!CharacterAppearance.linkedAppearances[link.idLinkedAppearance]) {
                CharacterAppearance.linkedAppearances[link.idLinkedAppearance] = [];
            }

            CharacterAppearance.linkedAppearances[link.idAppearance].push(link.idLinkedAppearance);
            CharacterAppearance.linkedAppearances[link.idLinkedAppearance].push(link.idAppearance);
        }

        for (let item of res) {
            let appearance = new Appearance();
            appearance.appearanceType = item.appearanceType;
            appearance.canBeDisplayedOnTop = item.canBeDisplayedOnTop;
            appearance.id = item.idAppearance;
            appearance.idBodyType = item.idBodyType;
            appearance.link = item.link;
            if (CharacterAppearance.linkedAppearances[item.idAppearance]) {
                appearance.linkedTo = CharacterAppearance.linkedAppearances[item.idAppearance];
            }

            CharacterAppearance.appearancesList[item.idAppearance] = appearance;
        }
    }

}


module.exports = CharacterAppearance;

