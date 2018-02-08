'use strict';
const conn = require("../../conf/mysql.js");
const Area = require("./Area");
const Discord = require("discord.js");

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

    toStr() {
        return new Discord.RichEmbed()
            .setColor([0, 255, 0])
            .setAuthor(this.name + " | " + this.levels + " | Owned by : " + this.getOwner(), this.image)
            .addField("Description", (this.desc ? this.desc : "Aucune description pour cette zone") + "\n\nQualité Maximale pour un objet : **" + this.getMaxItemQuality() + "**")
            .addField("Monstres", this.getMonsters())
            .addField("Resources", this.getResources())
            .setImage(this.image);
    }
}

module.exports = WildArea;
