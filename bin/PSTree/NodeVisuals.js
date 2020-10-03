const conn = require("../../conf/mysql");

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
    async getName(lang="en") {
        let res = (await conn.query("SELECT name FROM localizationnodespstree WHERE idNode = ? AND (lang = ? || lang = 'en');", [this.id, lang]))[0];

        return res ? res.name : "";
    }

    /**
     * 
     * @param {string} lang
     */
    async toApi(lang = "en") {
        return {
            id: this.id,
            icon: this.icon,
            name : await this.getName(lang),
        };
    }
}

module.exports = NodeVisuals;