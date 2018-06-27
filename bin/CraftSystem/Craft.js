const conn = require("../../conf/mysql");
const Globals = require("../Globals");
const Translator = require("../Translator/Translator");
const Discord = require("discord.js");

class Craft {
    constructor(id) {
        this.exist = false;
        this.requiredItems = [];
        this.itemInfo = {};
        this.load(id);
    }

    load(id) {
        let res = conn.query(`SELECT DISTINCT nomItem, itemsbase.idRarity, descItem, imageItem, nomType, nomRarity, couleurRarity, nomSousType, maxLevel, minLevel, itemsbase.idBaseItem FROM craftitemsneeded 
        INNER JOIN craftitem ON craftitem.idCraftItem = craftitemsneeded.IdCraftItem
        INNER JOIN itemsbase ON itemsbase.idBaseItem = craftitem.idBaseItem
        INNER JOIN itemstypes ON itemsbase.idType = itemstypes.idType 
        INNER JOIN itemsrarities ON itemsbase.idRarity = itemsrarities.idRarity 
        INNER JOIN itemssoustypes ON itemssoustypes.idSousType = itemsbase.idSousType
        WHERE craftitemsneeded.IdCraftItem = ?;
        `, [id]);
        if(res[0]) {
            res = res[0];
            this.exist = true;
            this.itemInfo = {
                idBase: res.idBaseItem,
                name: res.nomItem,
                desc: res.descItem,
                image: res.imageItem,
                typename: res.nomType,
                stypename: res.nomSousType,
                rarity: res.nomRarity,
                idRarity: res.idRarity,
                rarityColor: res.rarityColor,
                maxLevel: res.maxLevel,
                minLevel: res.minLevel,
            }

            res = conn.query(`SELECT nomItem, descItem, imageItem, nomType, nomRarity, couleurRarity, nomSousType, maxLevel, minLevel, number, itemsbase.idBaseItem FROM craftitemsneeded 
            INNER JOIN craftitem ON craftitem.idCraftItem = craftitemsneeded.IdCraftItem
            INNER JOIN itemsbase ON itemsbase.idBaseItem = craftitemsneeded.NeededItem
            INNER JOIN itemstypes ON itemsbase.idType = itemstypes.idType 
            INNER JOIN itemsrarities ON itemsbase.idRarity = itemsrarities.idRarity 
            INNER JOIN itemssoustypes ON itemssoustypes.idSousType = itemsbase.idSousType
            WHERE craftitemsneeded.IdCraftItem = ?;`, [id]);

            for(let item of res) {
                this.requiredItems.push({
                    idBase: item.idBaseItem,
                    name: item.nomItem,
                    typename: item.nomType,
                    stypename: item.nomSousType,
                    rarity: item.nomRarity,
                    number: item.number
                });
            }
        }
    }

    toEmbed(lang) {
        let embed = new Discord.RichEmbed()
                .setAuthor(this.itemInfo.name, Globals.addr + "images/items/" + this.itemInfo.image + ".png")
                .setColor(this.itemInfo.rarityColor)
                .addField(Translator.getString(lang, "item_types", this.itemInfo.typename) + " (" + Translator.getString(lang, "item_sous_types", this.itemInfo.stypename) + ")" + " | " + Translator.getString(lang, "rarities", this.itemInfo.rarity) + " | " + Translator.getString(lang, "general", "lvl") + " : " + this.itemInfo.minLevel + "-" + this.itemInfo.maxLevel + " | "
                , this.itemInfo.desc != "" ? this.itemInfo.desc : Translator.getString(lang, "inventory_equipment", "no_desc"))
                .addField(Translator.getString(lang, "craft", "needed_items"), this.requiredItemsToStr(lang));
        return embed;
    }

    requiredItemsToStr(lang) {
        let str = "```\n" + Translator.getString(lang, "craft", "header_required") + "\n";

        for(let item of this.requiredItems) {
            str += "\n";
            str += item.name + " - " + Translator.getString(lang, "item_types", item.typename) + " - " + Translator.getString(lang, "item_sous_types", item.stypename) + " - " + Translator.getString(lang, "rarities", item.rarity) + " - x" + item.number;
        }

        str += "```";
        return str;
    }

    canBeCraft(buildingRarityLevel) {
        return this.itemInfo.idRarity <= buildingRarityLevel;
    }

}

module.exports = Craft;