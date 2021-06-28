const conn = require("../../../conf/mysql.js");
const Globals = require("../../Globals.js");
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

    static async getAllPossibleBodyTypes(reload = false) {
        if (reload) {
            await CharacterAppearance.loadAllPossibleBodyTypes();
        }
        return CharacterAppearance.bodyTypesAppearances;
    }

    static async loadAllPossibleBodyTypes() {
        const res = await conn.query(`SELECT * FROM bodytype`);
        CharacterAppearance.bodyTypesAppearances = {};
        for (let item of res) {
            CharacterAppearance.bodyTypesAppearances[item.idBodyType] = item;
        }
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
            appearance.appearanceType = item.idAppearanceType;
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

    /**
     * 
     * @param {Appearance[]} arrOfAppearances
     * @param {{ bodyType:number, hairColor:string, bodyColor: string, eyeColor:string}} specificAppearance
     */
    async saveNewAppearance(arrOfAppearances, specificAppearance) {
        let appearanceIds = arrOfAppearances.map(a => `(${this.id},${a.id})`);
        await conn.query("UPDATE charactersappearance SET hairColor = ?, bodyColor = ?, eyeColor = ?, idBodyType = ? WHERE idCharacter = ?;", [specificAppearance.hairColor, specificAppearance.bodyColor, specificAppearance.eyeColor, specificAppearance.bodyType, this.id]);
        await conn.query("DELETE FROM charactersappearanceparts WHERE idCharacter = ?;", [this.id]);
        await conn.query(`REPLACE INTO charactersappearanceparts VALUES ${appearanceIds.join(",")};`);
        await this.reload();
    }

    async reload() {
        await this.load(this.id);
    }

}


module.exports = CharacterAppearance;

