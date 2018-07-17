'use strict';
const conn = require("../../conf/mysql.js");
const Area = require("./Area");
const Discord = require("discord.js");
const Translator = require("../Translator/Translator");
const Marketplace = require("../Marketplace/Marketplace");
const CraftingBuilding = require("../CraftSystem/CraftingBuilding");
const AreaTournament = require("../AreaTournament/AreaTournament");

class CityArea extends Area {

    constructor(id) {
        super(id, id);
        this.services = {
            "marketplace": new Marketplace(),
            "craftingbuilding" : new CraftingBuilding()
        }

        this.authorizedBonuses = ["xp_craft"];
        this.services.marketplace.loadMakerplace(this.id);
        this.services.craftingbuilding.load(this.id);
    }

    toStr(lang) {
        let tax = "";
        if(this.getOwnerID != null) {
            tax = "(" + (this.services.marketplace.getTax() * 100) + "% Tax)";
        }
        return new Discord.RichEmbed()
            .setColor([0, 255, 0])
            .setAuthor(this.name + " | " + this.levels + " | " + Translator.getString(lang, "area", "owned_by") + " : " + this.getOwner(lang), this.image)
            .addField(Translator.getString(lang, "general", "description"), (this.desc ? this.desc : Translator.getString(lang, "area", "no_description")) + "\n\nAvancement de la ville : **" + 1 + "**")
            .addField("Services", "```- Marché " + tax + "\n- Forge (Craft)```")
            .setImage(this.image);
    }


}



module.exports = CityArea;
