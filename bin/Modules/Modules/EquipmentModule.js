const GModule = require("../GModule");
const User = require("../../User");
const conn = require("../../../conf/mysql");
const Globals = require("../../Globals");
const LootSystem = require("../../LootSystem");
const AreasManager = require("../../Areas/AreasManager");
const Guild = require("../../Guild");
const Group = require("../../Group");
const Fight = require("../../Fight/Fight");
const Monster = require("../../Entities/Monster");
const Translator = require("../../Translator/Translator");
const CraftSystem = require("../../CraftSystem/CraftSystem");
const AreaTournament = require("../../AreaTournament/AreaTournament");
const PStatistics = require("../../Achievement/PStatistics");
const Craft = require("../../CraftSystem/Craft");
const Item = require("../../Items/Item");
const Emojis = require("../../Emojis");
const express = require("express");
const Character = require("../../Character");


class EquipmentModule extends GModule {
    constructor() {
        super();
        this.commands = ["equip", "unequip", "equiplist", "equipment", "use"];
        this.startLoading("Equipment");
        this.init();
        this.endLoading("Equipment");
    }

    init() {
        super.init();
        this.router.use((req, res, next) => {
            PStatistics.incrStat(Globals.connectedUsers[res.locals.id].character.id, "commands_equipment", 1);
            next();
        });
    }

    loadRoutes() {
        this.router.post("/equip", async (req, res, next) => {
            let data = {}
            let toEquip = parseInt(req.body.idItem, 10);
            let isRealID = req.body.isRealID;
            let itemToEquip;
            if (toEquip != null && Number.isInteger(toEquip)) {
                if (isRealID == null || isRealID == false) {
                    itemToEquip = await Globals.connectedUsers[res.locals.id].character.getInv().getItem(toEquip);
                } else {
                    itemToEquip = await Globals.connectedUsers[res.locals.id].character.getInv().getItemOfThisIDItem(toEquip);
                }
                data = await this.equipThisItem(Globals.connectedUsers[res.locals.id].character, itemToEquip, res.locals.lang);
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "item_enter_id_to_equip");
            }

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.post("/unequip", async (req, res, next) => {
            let data = {}
            let itemToUnequip = null;

            if (req.body.isRealID == null || req.body.isRealID == false) {
                itemToUnequip = await res.locals.character.getEquipement().getItem(this.getEquipableIDType(req.body.idItem));
            } else {
                itemToUnequip = await res.locals.character.getEquipement().getItemByIDItem(parseInt(req.body.idItem));
            }

            data = await this.unEquipThisItem(res.locals.character, itemToUnequip, res.locals.lang);

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.get("/show", async (req, res, next) => {
            let data = {};
            data.lang = res.locals.lang;
            data.items = await Globals.connectedUsers[res.locals.id].character.equipement.toApi(res.locals.lang);
            await next();
            return res.json(data);
        });

        this.router.post("/use", async (req, res, next) => {
            let data = {}
            data.lang = res.locals.lang;

            let toUse = parseInt(req.body.idItem, 10);
            let number = parseInt(req.body.amount, 10);
            //number = number > 0 ? number : 1;

            if (toUse != null && Number.isInteger(toUse)) {
                if (await Globals.connectedUsers[res.locals.id].character.haveThisObject(toUse)) {
                    let itemToUse = await Globals.connectedUsers[res.locals.id].character.getInv().getItem(toUse);
                    if (Globals.connectedUsers[res.locals.id].character.canUse(itemToUse)) {
                        await Globals.connectedUsers[res.locals.id].character.use(itemToUse, toUse, number);
                        data.success = itemToUse.resultToString(res.locals.lang);
                    } else {
                        data.error = Translator.getString(res.locals.lang, "errors", "item_you_cant_use");
                    }
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "item_you_dont_have");
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "item_enter_id_to_use");
            }

            await next();
            return res.json(data);
        });

    }

    /**
     * 
     * @param {Character} character
     * @param {Item} itemToUnequip
     * @param {string} lang
     */
    async unEquipThisItem(character, itemToUnequip = null, lang = "en") {

        if (itemToUnequip == null) {
            return this.asError(Translator.getString(lang, "errors", "item_you_have_to_choose_type_to_unequip"));
        }

        if (await character.getEquipement().isSlotFree(itemToUnequip.getEquipTypeID())) {
            return this.asError(Translator.getString(lang, "errors", "item_you_dont_have_item_equiped_here"));
        }

        await character.unEquipThisItem(itemToUnequip);
        return this.asSuccess(Translator.getString(lang, "inventory_equipment", "item_unequiped"));
    }

    /**
     * 
     * @param {Character} character
     * @param {Item} itemToEquip
     */
    async equipThisItem(character, itemToEquip = null, lang = "en") {

        if (itemToEquip == null) {
            return this.asError(Translator.getString(lang, "errors", "item_you_dont_have"));
        }

        if (!itemToEquip.isEquipable()) {
            return this.asError(Translator.getString(lang, "errors", "item_you_cant_equip"));
        }
        if (character.getLevel() < itemToEquip.getLevel()) {
            return this.asError(Translator.getString(lang, "errors", "item_cant_equip_higher_level", [itemToEquip.getLevel()]));
        }

        if (character.getRebirthLevel() < itemToEquip.getRebirthLevel()) {
            return this.asError(Translator.getString(lang, "errors", "item_cant_equip_higher_rebirth_level", [itemToEquip.getRebirthLevel()]));
        }

        await character.equipThisItem(itemToEquip);
        return this.asSuccess(Translator.getString(lang, "inventory_equipment", "item_equiped", [itemToEquip.getName(lang)]));
    }
}


module.exports = EquipmentModule;
