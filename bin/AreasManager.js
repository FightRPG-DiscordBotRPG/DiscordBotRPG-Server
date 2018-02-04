'use strict';
const conn = require("../conf/mysql.js");
const Area = require("./Area.js");
const Globals = require("./Globals.js");
const Discord = require("discord.js");

class AreasManager {

    constructor() {
        this.areas = new Map();
        this.loadAreas();
    }

    loadAreas() {
        /*let res = conn.query("SELECT COUNT(*) FROM areas")[0]["COUNT(*)"];
        for (let i = 1; i <= res; i++) {
            this.areas[i] = new Area(i);
        }*/
        let res = conn.query("SELECT idArea FROM areas ORDER BY AreaLevels ASC");
        for (let i in res) {
            //this.areas[res[i].idArea] = new Area(res[i].idArea);
            this.areas.set(res[i].idArea, new Area(res[i].idArea));
        }
    }

    canIFightThisMonster(idArea, idEnemy, perception) {
        let res = conn.query("SELECT idMonstre FROM AreasMonsters WHERE idArea = " + idArea + " AND idMonstre = " + idEnemy);
        if (res.length > 0) {
            let bonus = 1 + (perception / 100);
            let chance = Math.random();
            if (chance <= Globals.chanceToFightTheMonsterYouWant * bonus) {
                return true;
            }
        }

        return false;
    }

    selectRandomMonsterIn(idArea, idEnemy) {
        let res = conn.query("SELECT idMonstre FROM AreasMonsters WHERE idArea = " + idArea + " AND NOT idMonstre = " + idEnemy + " ORDER BY RAND() LIMIT 1;");
        if (res.length > 0) {
            return res[0]["idMonstre"];
        }
        return 1;
    }

    // Return string embed discord
    seeThisArea(idArea) {
        let embed = "None";
        /* WithOut map object
        switch (this.areas[idArea].areaType) {

            case "Wild":
                embed = new Discord.RichEmbed()
                    .setColor([0, 255, 0])
                    .setAuthor(this.areas[idArea].name + " | " + this.areas[idArea].levels, this.areas[idArea].image)
                    .addField("Description", (this.areas[idArea].desc ? this.areas[idArea].desc : "Aucune description pour cette zone") + "\n\nQualité Maximale pour un objet : **" + this.areas[idArea].getMaxItemQuality() + "**")
                    .addField("Monstres", this.areas[idArea].getMonsters())
                    .setImage(this.areas[idArea].image);
                break;

            case "City":
                embed = new Discord.RichEmbed()
                    .setColor([0, 255, 0])
                    .setAuthor(this.areas[idArea].name + " | " + this.areas[idArea].levels, this.areas[idArea].image)
                    .addField("Description", (this.areas[idArea].desc ? this.areas[idArea].desc : "Aucune description pour cette zone") + "\n\nAvancement de la ville : **" + 1 + "**")
                    .addField("PNJ", "``` PLACEHOLDER ```")
                    .addField("Services", "```- Tavernier\n- Banque\n- Marché\n- Forge```")
                    .setImage(this.areas[idArea].image);

        }*/

        // With map object
        switch (this.areas.get(idArea).areaType) {
            case "Wild":
                embed = new Discord.RichEmbed()
                    .setColor([0, 255, 0])
                    .setAuthor(this.areas.get(idArea).name + " | " + this.areas.get(idArea).levels, this.areas.get(idArea).image)
                    .addField("Description", (this.areas.get(idArea).desc ? this.areas.get(idArea).desc : "Aucune description pour cette zone") + "\n\nQualité Maximale pour un objet : **" + this.areas.get(idArea).getMaxItemQuality() + "**")
                    .addField("Monstres", this.areas.get(idArea).getMonsters())
                    .addField("Resources", this.areas.get(idArea).getResources())
                    .setImage(this.areas.get(idArea).image);
                break;

            case "City":
                embed = new Discord.RichEmbed()
                    .setColor([0, 255, 0])
                    .setAuthor(this.areas.get(idArea).name + " | " + this.areas.get(idArea).levels, this.areas.get(idArea).image)
                    .addField("Description", (this.areas.get(idArea).desc ? this.areas.get(idArea).desc : "Aucune description pour cette zone") + "\n\nAvancement de la ville : **" + 1 + "**")
                    .addField("PNJ", "``` PLACEHOLDER ```")
                    .addField("Services", "```- Tavernier\n- Banque\n- Marché\n- Forge```")
                    .setImage(this.areas.get(idArea).image);
                break;
        }

        return embed;
    }

    seeAllAreas() {
        let str = "```";

        // No Map
        /*for (let i in this.areas) {
            console.log(i);
            switch (this.areas[i].areaType) {
                case "Wild":
                    str += this.areas[i].id + " | " + this.areas[i].name + " | Niveaux : " + this.areas[i].levels + "\n";
                    break;
                case "City":
                    str += this.areas[i].id + " | " + this.areas[i].name + " (Ville) | Niveaux : " + this.areas[i].levels + "\n";
                    break;
            }

        }*/
        //console.log(this.areas.);
        // Map
        for (let [key, value] of this.areas) {
            switch (this.areas.get(key).areaType) {
                case "Wild":
                    str += this.areas.get(key).id + " | " + this.areas.get(key).name + " | Niveaux : " + this.areas.get(key).levels + "\n";
                    break;
                case "City":
                    str += this.areas.get(key).id + " | " + this.areas.get(key).name + " (Ville) | Niveau : " + this.areas.get(key).levels + "\n";
                    break;
            }

        }
        str += "```";
        return str;
    }

    canISellToThisArea(idArea) {
        if (this.areas.get(idArea).areaType == "City") {
            return true;
        }
        return false;
    }

    canIFightInThisArea(idArea) {
        if (this.areas.get(idArea).areaType == "Wild") {
            return true;
        }
        return false;
    }

    exist(idArea) {
        if (this.areas.get(idArea)) {
            return true;
        }
        return false;
    }

    // Update nbr players when a player travel to another location
    updateTravel(from, to) {
        this.areas.get(from).nbrPlayers -= 1;
        this.areas.get(to).nbrPlayers += 1;
    }

    // Single Getters for an area

    getNameOf(idArea) {
        return this.areas.get(idArea).name;
    }

    getPlayersOf(idArea, page, connectedUsers) {
        return this.areas.get(idArea).getPlayers(page, connectedUsers);
    }

    getResources(idArea) {
        return this.areas.get(idArea).getResources();
    }
    getResource(idArea, index) {
        return this.areas.get(idArea).getResource(index);
    }


}

module.exports = AreasManager;
