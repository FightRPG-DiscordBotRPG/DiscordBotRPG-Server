const conn = require("../../conf/mysql");
const Area = require("./Area");
const Translator = require("../Translator/Translator");
const Discord = require("discord.js");

class Region {
    constructor(id) {
        this.id = id;
        this.name = "";
        this.image = "";
        /**
         * @type {Map<number, Area>}
         */
        this.areas = new Map();

        this.load();
    }

    load() {
        let res = conn.query("SELECT * FROM regions WHERE idRegion = ?", [this.id]);
        if(res[0]) {
            res = res[0];
            this.name = res.name;
            this.image = res.image
        }
    }

    /**
     * 
     * @param {Area} area 
     */
    addArea(area) {
        this.areas.set(area.id, area);
    }

    seeAreas(lang) {
        let str = "```";
        // Map
        for (let [key, value] of this.areas) {
            switch (this.areas.get(key).areaType) {
                case "wild":
                    //str += this.areas.get(key).id + " | " + this.areas.get(key).name + " | Niveaux : " + this.areas.get(key).levels + "\n";
                    str += Translator.getString(lang, "area", "wild_area", [this.areas.get(key).id, this.areas.get(key).name, this.areas.get(key).levels]) + "\n";
                    break;
                case "city":
                    //str += this.areas.get(key).id + " | " + this.areas.get(key).name + " (Ville) | Niveau : " + this.areas.get(key).levels + "\n";
                    str += Translator.getString(lang, "area", "city_area", [this.areas.get(key).id, this.areas.get(key).name, this.areas.get(key).levels]) + "\n";
                    break;
                case "dungeon":
                    str += Translator.getString(lang, "area", "dungeon_area", [this.areas.get(key).id, this.areas.get(key).name, this.areas.get(key).levels]) + "\n";
                    break;
            }

        }
        str += "```";

        return new Discord.RichEmbed()
        .setColor([0, 255, 0])
        .setAuthor(this.name)
        .addField(Translator.getString(lang, "area", "list"), str)
        .setImage(this.image);
    }

}

module.exports = Region;