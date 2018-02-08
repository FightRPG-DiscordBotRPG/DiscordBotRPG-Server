'use strict';
const conn = require("../../conf/mysql.js");
const Area = require("./Area");
const Discord = require("discord.js");

class CityArea extends Area {

    constructor(id) {
        super(id, id);
    }

    toStr() {
        return new Discord.RichEmbed()
            .setColor([0, 255, 0])
            .setAuthor(this.name + " | " + this.levels + " | Owned by : " + this.getOwner(), this.image)
            .addField("Description", (this.desc ? this.desc : "Aucune description pour cette zone") + "\n\nAvancement de la ville : **" + 1 + "**")
            .addField("PNJ", "``` PLACEHOLDER ```")
            .addField("Services", "```- Tavernier\n- Banque\n- Marché\n- Forge```")
            .setImage(this.image);
    }


}

module.exports = CityArea;
