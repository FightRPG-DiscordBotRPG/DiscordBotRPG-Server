'use strict';
const conn = require("../../conf/mysql.js");
const Area = require("./Area");
const Discord = require("discord.js");
const Translator = require("../Translator/Translator");

class CityArea extends Area {

    constructor(id) {
        super(id, id);
    }

    toStr(lang) {
        return new Discord.RichEmbed()
            .setColor([0, 255, 0])
            .setAuthor(this.name + " | " + this.levels + " | Owned by : " + this.getOwner(lang), this.image)
            .addField(Translator.getString(lang, "general", "description"), (this.desc ? this.desc : Translator.getString(lang, "area", "no_description")) + "\n\nAvancement de la ville : **" + 1 + "**")
            .addField("PNJ", "``` PLACEHOLDER ```")
            .addField("Services", "```- Tavernier\n- Banque\n- Marché\n- Forge```")
            .setImage(this.image);
    }


}

module.exports = CityArea;
