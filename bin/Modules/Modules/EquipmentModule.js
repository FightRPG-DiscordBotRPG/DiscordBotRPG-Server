const GModule = require("../GModule");
const Discord = require("discord.js");
const User = require("../../User");
const conn = require("../../../conf/mysql");
const Globals = require("../../Globals");
const LootSystem = require("../../LootSystem");
const AreasManager = require("../../Areas/AreasManager");
const Leaderboard = require("../../Leaderboard");
const Guild = require("../../Guild");
const Group = require("../../Group");
const Fight = require("../../Fight/Fight");
const Monster = require("../../Monstre");
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
        this.router = express.Router();
        this.loadNeededVariables();
        this.router.use((req, res, next) => {
            PStatistics.incrStat(Globals.connectedUsers[res.locals.id].character.id, "commands_equipment", 1);
            next();
        });
        this.reactHandler();
        this.loadRoutes();
        this.crashHandler();
    }

    loadRoutes() {
        this.router.post("/equip", async (req, res) => {
            let data = {}
            data.lang = res.locals.lang;

            let toEquip = parseInt(req.body.idItem, 10);
            //console.log((toEquip));
            if (toEquip != null && Number.isInteger(toEquip)) {
                if (Globals.connectedUsers[res.locals.id].character.haveThisObject(toEquip)) {
                    if (Globals.connectedUsers[res.locals.id].character.getInv().isEquipable(toEquip)) {
                        let tItemToEquip = Globals.connectedUsers[res.locals.id].character.getInv().getItem(toEquip);
                        if (Globals.connectedUsers[res.locals.id].character.getLevel() >= tItemToEquip.getLevel()) {
                            let swapItem = Globals.connectedUsers[res.locals.id].character.getEquipement().equip(tItemToEquip.id);
                            Globals.connectedUsers[res.locals.id].character.getInv().deleteFromInventory(tItemToEquip);
                            if (swapItem > 0) {
                                Globals.connectedUsers[res.locals.id].character.getInv().addToInventory(swapItem);
                            }
                            data.success = Translator.getString(res.locals.id, "inventory_equipment", "item_equiped");
                        } else {
                            data.error = Translator.getString(res.locals.id, "errors", "item_cant_equip_higher_level", [tItemToEquip.getLevel()]);
                        }

                    } else {
                        data.error = Translator.getString(res.locals.id, "errors", "item_you_cant_equip");
                    }
                } else {
                    data.error = Translator.getString(res.locals.id, "errors", "item_you_dont_have");
                }
            } else {
                data.error = Translator.getString(res.locals.id, "errors", "item_enter_id_to_equip");
            }

            return res.json(data);
        });

        this.router.post("/unequip", async (req, res) => {
            let data = {}
            data.lang = res.locals.lang;

            let toUnequip = this.getEquipableIDType(req.body.idItem);
            if (toUnequip != -1 && Number.isInteger(toUnequip)) {
                //let swapItem = Globals.connectedUsers[res.locals.id].character.equ
                let itemToInventory = Globals.connectedUsers[res.locals.id].character.equipement.unEquip(toUnequip);
                if (itemToInventory > 0) {
                    Globals.connectedUsers[res.locals.id].character.getInv().addToInventory(itemToInventory);
                    data.success = Translator.getString(res.locals.lang, "inventory_equipment", "item_unequiped");
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "item_you_dont_have_item_equiped_here");
                }

            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "item_you_have_to_choose_type_to_unequip");
            }

            return res.json(data);
        });

        this.router.get("/show", async (req, res) => {
            let data = {};
            data.lang = res.locals.lang;
            data.items = Globals.connectedUsers[res.locals.id].character.equipement.toApi(res.locals.lang);
            return res.json(data);
        });

        this.router.post("/use", async (req, res) => {
            let data = {}
            data.lang = res.locals.lang;

            let toUse = parseInt(req.body.idItem, 10);

            if (toUse != null && Number.isInteger(toUse)) {
                if (Globals.connectedUsers[res.locals.id].character.haveThisObject(toUse)) {
                    let itemToUse = Globals.connectedUsers[res.locals.id].character.getInv().getItem(toUse);
                    if (Globals.connectedUsers[res.locals.id].character.canUse(itemToUse)) {
                        Globals.connectedUsers[res.locals.id].character.use(itemToUse, toUse);
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

            return res.json(data);
        });

    }
}

module.exports = EquipmentModule;