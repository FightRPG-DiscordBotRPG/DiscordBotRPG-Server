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
            data.lang = res.locals.lang;
            let toEquip = parseInt(req.body.idItem, 10);
            let isRealID = req.body.isRealID;
            if (toEquip != null && Number.isInteger(toEquip)) {
                if (isRealID == null || isRealID == false) {
                    if (await Globals.connectedUsers[res.locals.id].character.haveThisObject(toEquip)) {
                        if (await Globals.connectedUsers[res.locals.id].character.getInv().isEquipable(toEquip)) {
                            let tItemToEquip = await Globals.connectedUsers[res.locals.id].character.getInv().getItem(toEquip);
                            if (Globals.connectedUsers[res.locals.id].character.getLevel() >= tItemToEquip.getLevel()) {
                                let swapItem = await Globals.connectedUsers[res.locals.id].character.getEquipement().equip(tItemToEquip.id);
                                await Globals.connectedUsers[res.locals.id].character.getInv().deleteFromInventory(tItemToEquip);
                                if (swapItem > 0) {
                                    await Globals.connectedUsers[res.locals.id].character.getInv().addToInventory(swapItem);
                                }
                                Globals.connectedUsers[res.locals.id].character.checkEquipmentAchievements();

                                res.locals.character.updateMaxStats();
                                res.locals.character.healIfAreaIsSafe();

                                data.success = Translator.getString(res.locals.lang, "inventory_equipment", "item_equiped", [tItemToEquip.getName(data.lang)]);
                            } else {
                                data.error = Translator.getString(res.locals.lang, "errors", "item_cant_equip_higher_level", [tItemToEquip.getLevel()]);
                            }

                        } else {
                            data.error = Translator.getString(res.locals.lang, "errors", "item_you_cant_equip");
                        }
                    } else {
                        data.error = Translator.getString(res.locals.lang, "errors", "item_you_dont_have");
                    }
                } else {
                    let itemToEquip = await Globals.connectedUsers[res.locals.id].character.getInv().getItemOfThisIDItem(toEquip);
                    if (itemToEquip != null) {
                        if (itemToEquip.isEquipable()) {
                            if (Globals.connectedUsers[res.locals.id].character.getLevel() >= itemToEquip.getLevel()) {
                                let swapItem = await Globals.connectedUsers[res.locals.id].character.getEquipement().equip(itemToEquip.id);
                                await Globals.connectedUsers[res.locals.id].character.getInv().deleteFromInventory(itemToEquip);
                                if (swapItem > 0) {
                                    await Globals.connectedUsers[res.locals.id].character.getInv().addToInventory(swapItem);
                                }
                                Globals.connectedUsers[res.locals.id].character.checkEquipmentAchievements();

                                res.locals.character.updateMaxStats();
                                res.locals.character.healIfAreaIsSafe();

                                data.success = Translator.getString(res.locals.lang, "inventory_equipment", "item_equiped", [itemToEquip.getName(data.lang)]);
                            } else {
                                data.error = Translator.getString(res.locals.lang, "errors", "item_cant_equip_higher_level", [itemToEquip.getLevel()]);
                            }
                        } else {
                            data.error = Translator.getString(res.locals.lang, "errors", "item_you_cant_equip");
                        }
                    } else {
                        data.error = Translator.getString(res.locals.lang, "errors", "item_you_dont_have");
                    }
                }

            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "item_enter_id_to_equip");
            }

            await next();
            return res.json(data);
        });

        this.router.post("/unequip", async (req, res, next) => {
            let data = {}
            data.lang = res.locals.lang;
            let itemToInventory;

            let toUnequip = this.getEquipableIDType(req.body.idItem);
            let idItemToUnequip = parseInt(req.body.idItem);
            let isRealID = req.body.isRealID;
            if (isRealID == null || isRealID == false) {
                if (toUnequip != -1 && Number.isInteger(toUnequip)) {
                    itemToInventory = await Globals.connectedUsers[res.locals.id].character.equipement.unEquip(toUnequip);
                    if (itemToInventory > 0) {
                        await Globals.connectedUsers[res.locals.id].character.getInv().addToInventory(itemToInventory);

                        res.locals.character.updateMaxStats();
                        res.locals.character.healIfAreaIsSafe();

                        data.success = Translator.getString(res.locals.lang, "inventory_equipment", "item_unequiped");
                    } else {
                        data.error = Translator.getString(res.locals.lang, "errors", "item_you_dont_have_item_equiped_here");
                    }

                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "item_you_have_to_choose_type_to_unequip");
                }
            } else {
                let itemToUnequip = await Globals.connectedUsers[res.locals.id].character.getEquipement().getItemByIDItem(idItemToUnequip);
                if (itemToUnequip != null) {
                    itemToInventory = await Globals.connectedUsers[res.locals.id].character.equipement.unEquip(itemToUnequip.getEquipTypeID());
                    if (itemToInventory > 0) {
                        await Globals.connectedUsers[res.locals.id].character.getInv().addToInventory(itemToInventory);

                        res.locals.character.updateMaxStats();
                        res.locals.character.healIfAreaIsSafe();

                        data.success = Translator.getString(res.locals.lang, "inventory_equipment", "item_unequiped");
                    } else {
                        data.error = Translator.getString(res.locals.lang, "errors", "item_you_dont_have_item_equiped_here");
                    }
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "item_you_have_to_choose_type_to_unequip");
                }
            }


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
}

module.exports = EquipmentModule;
