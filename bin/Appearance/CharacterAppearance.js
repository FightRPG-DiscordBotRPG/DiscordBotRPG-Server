const conn = require("../../conf/mysql.js");
const Globals = require("../Globals.js");
const Appearance = require("./Appearance.js");

class CharacterAppearance {

    /**
     * @type {Object<number, Appearance>}
     **/
    static appearancesList = {};

    /**
     * @type {Object<number, number[]>}
     **/
    static linkedAppearances = {};

    static bodyTypesAppearances = {};

    static requiredAppearancesTypeForCharacter = [1, 3, 5, 10];

    static selectableBodyTypes = [1, 2];

    static selectableHairColors = ["#AA8866", "#DEBE99", "#241C11", "#4F1A00", "#9A3300"];

    static selectableEyeColors = ["#634E34", "#2E536F", "#3D671D", "#131C1B", "#59525A"];

    static selectableBodyColors = ["#553827", " #935934", "#BD804A", "#FEE4D7", "#E6A17D", "#BE7F5E"];

    constructor() {
        this.id = null;
        this.hairColor = "#241C11";
        this.bodyColor = "#BD804A";
        this.eyeColor = "#634E34";
        this.idBodyType = 1;
        this.displayHelmet = true;
        this.appearances = {};
        this.body = null;
    }

    async init(id) {
        this.id = id;
        await conn.query(`INSERT INTO charactersappearance VALUES (?, "#241C11", "#BD804A", "#634E34", 1, 1);`, [this.id]);
        await conn.query(`INSERT INTO charactersappearanceparts VALUES (SELECT ${this.id}, idAppearance, idAppearanceType FROM appearances WHERE idAppearanceType IN (1,2,3,4,5,7,9,10) GROUP BY idAppearanceType)`);
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
            this.appearances[item.propertyName] = Appearance.appearancesList[item.idAppearance];
        }

    }

    /**
     * 
     * @param {Appearance[]} arrOfAppearances
     * @param {{ bodyType:number, hairColor:string, bodyColor: string, eyeColor:string, shouldDisplayHelmet:boolean}} specificAppearance
     */
    async saveNewAppearance(arrOfAppearances, specificAppearance) {
        let appearanceIds = arrOfAppearances.map(a => `(${this.id},${a.id})`);
        specificAppearance.shouldDisplayHelmet = specificAppearance.shouldDisplayHelmet == "true" ? 1 : 0;

        await conn.query("UPDATE charactersappearance SET hairColor = ?, bodyColor = ?, eyeColor = ?, idBodyType = ?, displayHelmet = ? WHERE idCharacter = ?;", [specificAppearance.hairColor, specificAppearance.bodyColor, specificAppearance.eyeColor, specificAppearance.bodyType, specificAppearance.shouldDisplayHelmet, this.id]);
        await conn.query("DELETE FROM charactersappearanceparts WHERE idCharacter = ?;", [this.id]);
        await conn.query(`REPLACE INTO charactersappearanceparts VALUES ${appearanceIds.join(",")};`);
        await this.reload();
    }

    async reload() {
        await this.load(this.id);
    }

    static async getAllPossibleAppearances() {
        if (Object.values(CharacterAppearance.appearancesList).length === 0) {
            // Reload
            CharacterAppearance.appearancesList = {};
            for (let i in Appearance.appearancesList) {
                if (Appearance.appearancesList[i].appearanceType <= 10) {
                    CharacterAppearance.appearancesList[i] = Appearance.appearancesList[i];
                }
            }
        }

        return CharacterAppearance.appearancesList;
    }

}


module.exports = CharacterAppearance;

