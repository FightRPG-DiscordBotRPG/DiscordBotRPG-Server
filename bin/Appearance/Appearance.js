const conn = require("../../conf/mysql.js");

class Appearance {

    /**
     * @type {Object<number, Appearance>}
     **/
    static appearancesList = {};

    /**
     * @type {Object<number, number[]>}
     **/
    static linkedAppearances = {};

    constructor() {
        this.id = 1;
        this.link = "";
        this.appearanceType = 1;
        this.idBodyType = 1;
        this.canBeDisplayedOnTop = true;
        this.maskLink = null;
        /**
         * @type {number[]}
         **/
        this.linkedTo = [];
    }

    static async getAllPossibleAppearances(reload = false) {
        if (reload) {
            await Appearance.loadAllPossibleAppearances();
        }
        return Appearance.appearancesList;
    }

    static async getAllPossibleBodyTypes(reload = false) {
        if (reload) {
            await Appearance.loadAllPossibleBodyTypes();
        }
        return Appearance.bodyTypesAppearances;
    }

    static async loadAllPossibleBodyTypes() {
        const res = await conn.query(`SELECT * FROM bodytype`);
        Appearance.bodyTypesAppearances = {};
        for (let item of res) {
            Appearance.bodyTypesAppearances[item.idBodyType] = item;
        }
    }

    static async loadAllPossibleAppearances() {
        // Take all character related appearance
        // Maybe use a list next time
        let res = await conn.query(`SELECT * FROM appearances`);
        let allLinks = await conn.query(`SELECT * FROM linkedappearances`);

        Appearance.linkedAppearances = {};
        Appearance.appearancesList = {};

        for (let link of allLinks) {
            if (!Appearance.linkedAppearances[link.idAppearance]) {
                Appearance.linkedAppearances[link.idAppearance] = [];
            }

            if (!Appearance.linkedAppearances[link.idLinkedAppearance]) {
                Appearance.linkedAppearances[link.idLinkedAppearance] = [];
            }

            Appearance.linkedAppearances[link.idAppearance].push(link.idLinkedAppearance);
            Appearance.linkedAppearances[link.idLinkedAppearance].push(link.idAppearance);
        }

        for (let item of res) {
            let appearance = new Appearance();
            appearance.appearanceType = item.idAppearanceType;
            appearance.canBeDisplayedOnTop = item.canBeDisplayedOnTop;
            appearance.id = item.idAppearance;
            appearance.idBodyType = item.idBodyType;
            appearance.link = item.link;
            appearance.maskLink = item.maskLink;
            if (Appearance.linkedAppearances[item.idAppearance]) {
                appearance.linkedTo = Appearance.linkedAppearances[item.idAppearance];
            }

            Appearance.appearancesList[item.idAppearance] = appearance;
        }
    }

}

module.exports = Appearance;