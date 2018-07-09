'use strict';
const conn = require("../../conf/mysql.js");
const Area = require("./Area");
const Discord = require("discord.js");
const Translator = require("../Translator/Translator");
const AreaTournament = require("../AreaTournament/AreaTournament");

class WildArea extends Area{

    constructor(id) {
        super(id, id);
        this.fightPossible = true;
    }

    getMaxItemQuality() {
        let res = conn.query(
            "SELECT DISTINCT itemsrarities.nomRarity " +
            "FROM itemsbase " +
            "INNER JOIN itemsrarities ON itemsrarities.idRarity = itemsbase.idRarity " +
            "INNER JOIN areasitems ON areasitems.idBaseItem = itemsbase.idBaseItem AND areasitems.idArea = " + this.id + " " +
            "GROUP BY itemsrarities.idRarity DESC LIMIT 1;"
        );

        return res[0]["nomRarity"];
    }

    /**
     * @param {string} lang 
     * @returns {RichEmbed}
     */
    toStr(lang) {
        return new Discord.RichEmbed()
            .setColor([0, 255, 0])
            .setAuthor(this.name + " | " + this.levels + " | " + Translator.getString(lang, "area", "owned_by") + " : " + this.getOwner(lang), this.image)
            .addField(Translator.getString(lang, "general", "description"), (this.desc ? this.desc : Translator.getString(lang, "area", "no_description")) + "\n\n" + Translator.getString(lang, "area", "maximum_quality") + " **" + Translator.getString(lang, "rarities", this.getMaxItemQuality()) + "**")
            .addField(Translator.getString(lang, "general", "monsters"), this.getMonsters(lang))
            .addField(Translator.getString(lang, "general", "resources"), this.getResources(lang))
            .setImage(this.image);
    }
}

module.exports = WildArea;
