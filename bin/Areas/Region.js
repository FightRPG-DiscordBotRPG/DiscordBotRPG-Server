const conn = require("../../conf/mysql");
const Area = require("./Area");
const Translator = require("../Translator/Translator");
const Discord = require("discord.js");

class Region {
    constructor(id) {
        this.id = id;
        /**
         * @type {Map<number, Area>}
         */
        this.areas = new Map();
        this.areaIncrementIndex = 1;
        /**
         * @type {Map<number, Area>}
         */
        this.connectedAreas = new Map();
        this.connectedAreasIncrementIndex = 1;
    }

    static staticGetName(id, lang="en") {
        return Translator.getString(lang, "regionsNames", id);
    }

    getName(lang="en") {
        return Translator.getString(lang, "regionsNames", this.id);
    }

    getImage(lang="en") {
        return Translator.getString(lang, "regionsImages", this.id);
    }

    getArea(index) {
        return this.areas.get(index);
    }

    getConnectedArea(index) {
        return this.connectedAreas.get(index);
    }

    /**
     * 
     * @param {Area} area 
     */
    addArea(area) {
        this.areas.set(this.areaIncrementIndex, area);
        this.areaIncrementIndex++;
    }

    addConnectedArea(area) {
        this.connectedAreas.set(this.connectedAreasIncrementIndex, area);
        this.connectedAreasIncrementIndex++;
    }

    exist(index) {
        return this.areas.get(index) != null;
    }

    isConnected(index) {
        return this.connectedAreas.get(index) != null;
    }

    seeAreas(lang) {
        let strAreas = "";
        // Map
        for (let [key, value] of this.areas) {
            strAreas += "`";
            switch (this.areas.get(key).areaType) {
                case "wild":
                    strAreas += Translator.getString(lang, "area", "wild_area", [key, this.areas.get(key).getName(lang), this.areas.get(key).levels]);
                    break;
                case "city":
                    strAreas += Translator.getString(lang, "area", "city_area", [key, this.areas.get(key).getName(lang), this.areas.get(key).levels]);
                    break;
                case "dungeon":
                    strAreas += Translator.getString(lang, "area", "dungeon_area", [key, this.areas.get(key).getName(lang), this.areas.get(key).levels]);
                    break;
            }
            strAreas += "`\n";
        }
        strAreas += "";

        let strConnectedAreas = "";
        for (let [key, value] of this.connectedAreas) {
            strConnectedAreas += "`"
            switch (this.connectedAreas.get(key).areaType) {
                case "wild":
                    strConnectedAreas += Translator.getString(lang, "area", "wild_area", [key, this.connectedAreas.get(key).getName(lang), this.connectedAreas.get(key).levels]);
                    break;
                case "city":
                    strConnectedAreas += Translator.getString(lang, "area", "city_area", [key, this.connectedAreas.get(key).getName(lang), this.connectedAreas.get(key).levels]);
                    break;
                case "dungeon":
                    strConnectedAreas += Translator.getString(lang, "area", "dungeon_area", [key, this.connectedAreas.get(key).getName(lang), this.connectedAreas.get(key).levels]);
                    break;
            }
            strConnectedAreas += " | " + Translator.getString(lang, "general", "region") + " : " + Region.staticGetName(this.connectedAreas.get(key).idRegion) + "`\n"
        }
        if(strConnectedAreas == "") {
            strConnectedAreas = Translator.getString(lang, "area", "no_connected_regions");
        }

        return new Discord.RichEmbed()
        .setColor([0, 255, 0])
        .setAuthor(this.getName(lang))
        .addField(Translator.getString(lang, "area", "list"), strAreas)
        .addField(Translator.getString(lang, "area", "list_regions_connected"), strConnectedAreas)
        .setImage(this.getImage(lang));
    }

}

module.exports = Region;