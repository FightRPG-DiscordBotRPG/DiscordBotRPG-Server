'use strict';
const conn = require("../../conf/mysql.js");
const Area = require("./Area");
const Discord = require("discord.js");
const Translator = require("../Translator/Translator");
const AreaTournament = require("../AreaTournament/AreaTournament");

class DungeonArea extends Area {

    constructor(id) {
        super(id, id);
        this.fightPossible = true;
        this.authorizedBonuses = ["xp_fight", "xp_collect", "gold_drop", "item_drop", "collect_drop"];
    }

    toStr(lang) {
        return new Discord.RichEmbed()
            .setColor([0, 255, 0])
            .setAuthor(this.getName(lang) + " | " + this.minMaxLevelToString() + " | " + Translator.getString(lang, "area", "owned_by") + " : " + this.getOwner(lang), this.image)
            .addField(Translator.getString(lang, "general", "description"), this.getDesc(lang) + "\n\n" + Translator.getString(lang, "area", "minimum_quality") + " **" + Translator.getString(lang, "rarities", this.getMinItemQuality()) + "**")
            .addField(Translator.getString(lang, "general", "monsters"), this.getMonsters(lang))
            .setImage(this.image);
    }
}

module.exports = DungeonArea;