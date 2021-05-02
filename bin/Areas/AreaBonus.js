const conn = require("../../conf/mysql.js");
const Translator = require("../Translator/Translator");

class AreaBonus {
    /**
     * 
     * @param {number} id 
     */
    constructor(id) {
        this.id = id;
        this.name = "";
        this.value = 0;
    }

    async load() {
        let res = await conn.query("SELECT * FROM bonustypes WHERE idBonusTypes = ?", [this.id]);
        res = res[0];
        if (res) {
            this.name = res.nom;
        }
    }

    /**
     * 
     * @param {number} val 
     */
    setValue(val) {
        this.value = val;
    }

    /**
     * 
     * @param {string} lang 
     */
    toStr(lang) {
        return Translator.getString(lang, "bonuses", this.name) + " : " + this.getPercentage() + "%";
    }

    toApi(lang) {
        return {
            bonus_identifier: this.name,
            name: Translator.getString(lang, "bonuses", this.name),
            percentage: this.getPercentage(),
        };
    }

    getPercentage() {
        return this.value;
    }

    getPercentageValue() {
        return this.value / 100;
    }

    static identifiers = {
        xpFight: "xp_fight",
        xpCollect: "xp_collect",
        xpCraft: "xp_craft",
        goldDrop: "gold_drop",
        itemDrop: "item_drop",
        collectDrop: "collect_drop",
    }

}

module.exports = AreaBonus;