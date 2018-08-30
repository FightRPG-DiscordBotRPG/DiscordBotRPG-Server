const conn = require("../../conf/mysql");
const Globals = require("../Globals");
const Translator = require("../Translator/Translator");
const Craft = require("./Craft");

class CraftingBuilding {
    constructor() {
        this.id = 0; 
        this.maxRarity = 1;
        this.maxRarityName = "";
        this.maxRarityColor = "";
        this.isActive = false;
    }

    load(idArea) {
        let res = conn.query("SELECT idCraftBuilding, rarityMax, nomRarity, couleurRarity, active FROM craftbuilding INNER JOIN itemsrarities ON itemsrarities.idRarity = craftbuilding.rarityMax WHERE idArea = ?", [idArea]);
        if (res[0]) {
            this.id = res[0]["idCraftBuilding"];
            this.maxRarity = res[0]["rarityMax"];
            this.maxRarityName = res[0]["nomRarity"];
            this.maxRarityColor = res[0]["couleurRarity"];
            this.isActive = res[0]["active"];
        }
    }

    getCraftingList(page) {
        page = Number.parseInt(page ? page : 1);
        page = page ? (page <= 0 || !Number.isInteger(page) ? 1 : page) : 1;
        let perPage = 10;
        let maxPage = Math.ceil(conn.query(`SELECT COUNT(*) FROM craftitem
                                INNER JOIN itemsbase ON itemsbase.idBaseItem = craftitem.idBaseItem
                                WHERE itemsbase.idRarity <= ?`,
            [this.maxRarity])[0]["COUNT(*)"] / perPage);
        page = maxPage > 0 && maxPage < page ? maxPage : page;

        let res = conn.query(`SELECT * FROM craftitem
                    INNER JOIN itemsbase ON itemsbase.idBaseItem = craftitem.idBaseItem
                    INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType
                    WHERE itemsbase.idRarity <= ? ORDER BY craftitem.minLevel ASC LIMIT ? OFFSET ?`,
            [this.maxRarity, perPage, (page - 1) * perPage]);



        return { res: res, maxPage: maxPage, page: page };
    }

    craftingListToEmbed(page=1, lang) {
        let res = this.getCraftingList(page);
        let str = "```\n";
        str += Translator.getString(lang, "craft", "header_craft_list") + "\n\n";
        let crafts = res.res;
        let index = 1;
        let indexOffset = (res.page-1) * 10;
        if (crafts.length > 0) {
            for (let craft of crafts) {
                let itemName = Translator.getString(lang, "itemsNames", craft.idBaseItem);
                str += (index+indexOffset) + " - " + itemName + " - " + Translator.getString(lang, "item_types", craft.nomType) + " - " + craft.minLevel + " - " + craft.maxLevel + " - " + Translator.getString(lang, "rarities", Globals.itemsrarities[craft.idRarity]) + "\n";
                index++;
            }
            str += "\n";
        } else {
            str += Translator.getString(lang, "general", "nothing_at_this_page") + "\n\n";
        }
        str += Translator.getString(lang, "general", "page_out_of_x", [res.page, res.maxPage > 0 ? res.maxPage : 1])
        str += "```";
        return str;
    }

    craftToEmbed(idCraft, lang) {
        idCraft = this.getRealIdCraft(idCraft);

        // Like this we dont have to call databse if id is not a number or whatever
        if(idCraft > 0) {
            let craft = new Craft(idCraft);
            if(craft.exist && craft.canBeCraft(this.maxRarity)) {
                return craft.toEmbed(lang);
            } 
        }

        return Translator.getString(lang, "errors", "craft_dont_exist");
    }

    getCraft(idCraft) {
        idCraft = this.getRealIdCraft(idCraft);
        
        if(idCraft > 0) {
            let craft = new Craft(idCraft);
            if(craft.exist && craft.canBeCraft(this.maxRarity)) {
                return craft;
            }
        }
        return null;
    }

    getRealIdCraft(idCraft) {
        idCraft = idCraft && Number.isInteger(Number.parseInt(idCraft)) ? idCraft : 0;
        
        let res = conn.query("SELECT idCraftItem FROM craftitem INNER JOIN itemsbase ON itemsbase.idBaseItem = craftitem.idBaseItem INNER JOIN itemstypes ON itemstypes.idType = itemsbase.idType WHERE itemsbase.idRarity <= ? ORDER BY craftitem.minLevel ASC LIMIT 1 OFFSET ?", [this.maxRarity, idCraft-1]);

        return res[0] != null ? res[0].idCraftItem : 0;
    }

}

module.exports = CraftingBuilding;