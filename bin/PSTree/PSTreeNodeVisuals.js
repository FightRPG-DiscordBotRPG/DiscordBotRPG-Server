const conn = require("../../conf/mysql");
const Translator = require("../Translator/Translator");

class NodeVisuals {
    constructor() {
        this.id = 0;
        this.icon = "";
    }

    /**
     * 
     * @param {number} id
     */
    async load(id) {
        let res = (await conn.query("SELECT * FROM pstreepossiblesnodesvisuals WHERE idNode = ?;", [id]))[0];
        if (res) {
            this.id = id;
            this.icon = res.icon;
        }
    }

    async save() {
        await conn.query("REPLACE INTO pstreepossiblesnodesvisuals VALUES (?, ?)", [this.id, this.icon]);
        if (this.localizedNames != null) {
            for (let lang in this.localizedNames) {
                await conn.query("REPLACE INTO localizationnodespstree VALUES (?, ?, ?)", [this.id, lang, this.localizedNames[lang]]);
            }
        }

        if (this.name != null) {
            await conn.query("REPLACE INTO localizationnodespstree VALUES (?, ?, ?)", [this.id, "en", this.name]);
        }
    }

    /**
     * 
     * @param {string} lang
     * @return {string}
     */
    getName(lang = "en") {
        return Translator.getString(lang, "nodeVisualsName", this.id);
    }

    /**
     * 
     * @param {string} lang
     */
    toApi(lang = "en") {
        return {
            id: this.id,
            icon: this.icon,
            name : this.getName(lang),
        };
    }
}

module.exports = NodeVisuals;