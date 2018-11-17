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

class CraftingModule extends GModule {
    constructor() {
        super();
        this.commands = ["craftlist", "craftshow", "craft", "collect", "resources"];
        this.startLoading("Crafting");
        this.init();
        this.endLoading("Crafting");
    }

    init() {
        this.router = express.Router();

        // Add to router needed things
        this.loadNeededVariables();
        this.router.use((req, res, next) => {
            PStatistics.incrStat(Globals.connectedUsers[res.locals.id].character.id, "commands_job", 1);
            next();
        });
        this.reactHandler();
        this.loadRoutes();
        this.crashHandler();
    }

    loadRoutes() {
        this.router.get("/craftlist/:page?", async (req, res) => {
            let data = {};

            if (res.locals.craftingbuilding != null) {
                data = res.locals.craftingbuilding.craftingListToApi(req.params.page, res.locals.lang);
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "craft_no_building");
            }
            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.get("/craftshow/:idCraft?", async (req, res) => {
            let data = {};

            if (res.locals.craftingbuilding != null) {
                let craft = res.locals.craftingbuilding.getCraft(req.params.idCraft);
                if (craft != null) {
                    data.craft = craft.toApi(res.locals.lang);
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "craft_dont_exist");
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "craft_no_building");
            }

            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.post("/craft", async (req, res) => {
            let data = {};

            if (res.locals.craftingbuilding != null) {
                // ToCraft = Craft type
                if (Globals.connectedUsers[res.locals.id].character.canDoAction()) {
                    /**
                     * @type {Craft}
                     */
                    let toCraft = res.locals.craftingbuilding.getCraft(req.body.idCraft);
                    if (toCraft) {
                        if (Globals.connectedUsers[res.locals.id].character.isCraftable(toCraft)) {
                            if (Globals.connectedUsers[res.locals.id].character.craft(toCraft)) {
                                data.success = Translator.getString(res.locals.lang, "craft", "craft_done", [Translator.getString(res.locals.lang, "itemsNames", toCraft.itemInfo.idBase)]) + "\n";

                                Globals.connectedUsers[res.locals.id].character.waitForNextCraft(toCraft.itemInfo.idRarity);

                                PStatistics.incrStat(Globals.connectedUsers[res.locals.id].character.id, "items_" + toCraft.getRarity() + "_craft", 1);
                                // Seulement s'il n'est pas niveau max
                                if (Globals.connectedUsers[res.locals.id].character.getCraftLevel() < Globals.maxLevel) {
                                    let craftBonus = res.locals.currentArea.getAllBonuses().xp_craft;
                                    let craftXP = CraftSystem.getXP(Globals.connectedUsers[res.locals.id].character.itemCraftedLevel(toCraft.itemInfo.maxLevel), Globals.connectedUsers[res.locals.id].character.getCraftLevel(), toCraft.itemInfo.idRarity, false);
                                    let craftXPBonus = craftBonus.getPercentageValue() * craftXP;
                                    let totalCraftXP = craftXP + craftXPBonus;

                                    let craftCraftUP = Globals.connectedUsers[res.locals.id].character.addCraftXP(totalCraftXP);

                                    data.success += Translator.getString(res.locals.lang, "resources", "collect_gain_xp", [totalCraftXP, craftXPBonus]) + "\n";

                                    if (craftCraftUP > 0) {
                                        data.success += Translator.getString(res.locals.lang, "resources", craftCraftUP > 1 ? "job_level_up_plur" : "job_level_up", [craftCraftUP]);
                                    }
                                }

                            } else {
                                data.error = Translator.getString(res.locals.lang, "errors", "craft_dont_have_required_items");
                            }
                        } else {
                            data.error = Translator.getString(res.locals.lang, "errors", "craft_dont_have_required_level", [toCraft.itemInfo.minLevel]);
                        }
                    } else {
                        data.error = Translator.getString(res.locals.lang, "errors", "craft_dont_exist");
                    }
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "craft_tired_wait_x_seconds", [Globals.connectedUsers[res.locals.id].character.getExhaust()]);
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "craft_no_building");
            }

            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.post("/collect", async (req, res) => {
            let data = {};

            let idToCollect = parseInt(req.body.idResource, 10);
            if (Globals.connectedUsers[res.locals.id].character.canDoAction()) {
                if (idToCollect && Number.isInteger(idToCollect)) {
                    let resourceToCollect = Globals.areasManager.getResource(Globals.connectedUsers[res.locals.id].character.getIdArea(), idToCollect);
                    //idToCollect = Globals.areasManager.getResourceId(Globals.connectedUsers[res.locals.id].character.getIdArea(), idToCollect);
                    if (resourceToCollect) {
                        let collectBonuses = res.locals.currentArea.getAllBonuses();
                        Globals.connectedUsers[res.locals.id].character.waitForNextResource(resourceToCollect.idRarity);
                        idToCollect = Globals.connectedUsers[res.locals.id].character.getIdOfThisIdBase(resourceToCollect.idBaseItem);
                        let numberItemsCollected = CraftSystem.getNumberOfItemsCollected(Globals.connectedUsers[res.locals.id].character.getStat("intellect") * (1 + collectBonuses.collect_drop.getPercentage()), resourceToCollect.idRarity);
                        data.success = Translator.getString(res.locals.lang, "resources", "tried_to_collect_x_times", [Globals.collectTriesOnce]) + "\n";
                        if (numberItemsCollected > 0) {
                            if (idToCollect) {
                                Globals.connectedUsers[res.locals.id].character.inv.addToInventory(idToCollect, numberItemsCollected);
                            } else {
                                let idInsert = conn.query("INSERT INTO items(idItem, idBaseItem, level) VALUES(NULL, ?, 1)", [resourceToCollect.idBaseItem])["insertId"];
                                Globals.connectedUsers[res.locals.id].character.inv.addToInventory(idInsert, numberItemsCollected);
                            }

                            PStatistics.incrStat(Globals.connectedUsers[res.locals.id].character.id, "items_" + resourceToCollect.nomRarity + "_collected", numberItemsCollected);

                            data.success += Translator.getString(res.locals.lang, "resources", "collected_x_resource", [numberItemsCollected, Translator.getString(res.locals.lang, "itemsNames", resourceToCollect.idBaseItem)]) + "\n";
                        } else {
                            data.success += Translator.getString(res.locals.lang, "resources", "not_collected") + "\n";
                        }
                        // Si le joueur n'est pas max level en craft
                        if (Globals.connectedUsers[res.locals.id].character.getCraftLevel() < Globals.maxLevel) {
                            let collectXP = CraftSystem.getXP(Globals.connectedUsers[res.locals.id].character.getCraftLevel(), Globals.connectedUsers[res.locals.id].character.getCraftLevel(), resourceToCollect.idRarity, true) * Globals.collectTriesOnce;
                            let collectXPBonus = collectBonuses.xp_collect.getPercentageValue() * collectXP;
                            let totalCollectXP = collectXP + collectXPBonus;
                            let collectCraftUP = Globals.connectedUsers[res.locals.id].character.addCraftXP(totalCollectXP);
                            data.success += Translator.getString(res.locals.lang, "resources", "collect_gain_xp", [totalCollectXP, collectXPBonus]) + "\n";
                            if (collectCraftUP > 0) {
                                data.success += Translator.getString(res.locals.lang, "resources", collectCraftUP > 1 ? "job_level_up_plur" : "job_level_up", [collectCraftUP]);
                            }
                        }

                    } else {
                        // error object don't exist
                        data.error = Translator.getString(res.locals.lang, "resources", "resource_dont_exist");
                    }
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "collect_enter_id_to_collect");
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "collect_tired_wait_x_seconds", [Globals.connectedUsers[res.locals.id].character.getExhaust()]);
            }

            data.lang = res.locals.lang;
            return res.json(data);
        });

        this.router.get("/resources", async (req, res) => {
            let data = {};

            data.success = Translator.getString(res.locals.lang, "area", "follow_the_link") + "\n";
            data.success += "http://api.fight-rpg.com/helpers/areas/resources?lang=" + res.locals.lang;

            data.lang = res.locals.lang;
            return res.json(data);
        });



    }
}

module.exports = CraftingModule;