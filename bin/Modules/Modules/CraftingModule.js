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
const Item = require("../../Item");
const Emojis = require("../../Emojis");

class CraftinModule extends GModule {
    constructor() {
        super();
        this.commands = ["craftlist", "craftshow", "craft", "collect"];
        this.startLoading("Crafting");
        this.init();
        this.endLoading("Crafting");
    }

    async run(message, command, args) {
        let msg = "";
        let authorIdentifier = message.author.id;
        let mentions = message.mentions.users;
        //let group = Globals.connectedUsers[authorIdentifier].character.group;
        let lang = Globals.connectedUsers[authorIdentifier].getLang();
        //let pending = Globals.connectedUsers[authorIdentifier].character.pendingPartyInvite;
        //let marketplace = Globals.areasManager.getService(Globals.connectedUsers[authorIdentifier].character.getIdArea(), "marketplace");
        let craftingbuilding = Globals.areasManager.getService(Globals.connectedUsers[authorIdentifier].character.getIdArea(), "craftingbuilding");
        let currentArea = Globals.connectedUsers[authorIdentifier].character.getArea();
        let tLootSystem = new LootSystem();
        let uIDGuild;
        let tGuildId = 0;
        let firstMention;
        let err = [];
        let apPage;
        let nb;
        let temp;
        let doIHaveThisItem = false;

        PStatistics.incrStat(Globals.connectedUsers[authorIdentifier].character.id, "commands_job", 1);

        switch (command) {
            case "craftlist":
                if (craftingbuilding != null) {
                    msg = craftingbuilding.craftingListToEmbed(args[0], lang);
                } else {
                    msg = Translator.getString(lang, "errors", "craft_no_building");
                }
                break;

            case "craftshow":
                if (craftingbuilding != null) {
                    msg = craftingbuilding.craftToEmbed(args[0], lang);
                } else {
                    msg = Translator.getString(lang, "errors", "craft_no_building");
                }
                break;

            case "craft":
                if (craftingbuilding != null) {
                    // ToCraft = Craft type
                    if (Globals.connectedUsers[authorIdentifier].character.canFightAt <= Date.now()) {
                        /**
                         * @type {Craft}
                         */
                        let toCraft = craftingbuilding.getCraft(args[0]);
                        if (toCraft) {
                            if (Globals.connectedUsers[authorIdentifier].character.isCraftable(toCraft)) {
                                if (Globals.connectedUsers[authorIdentifier].character.craft(toCraft)) {
                                    msg = Translator.getString(lang, "craft", "craft_done", [Translator.getString(lang, "itemsNames", toCraft.itemInfo.idBase)]) + "\n";

                                    Globals.connectedUsers[authorIdentifier].character.waitForNextCraft(toCraft.itemInfo.idRarity);

                                    PStatistics.incrStat(Globals.connectedUsers[authorIdentifier].character.id, "items_" + toCraft.getRarity() + "_craft", 1);
                                    // Seulement s'il n'est pas niveau max
                                    if (Globals.connectedUsers[authorIdentifier].character.getCraftLevel() < Globals.maxLevel) {
                                        let craftBonus = currentArea.getAllBonuses().xp_craft;
                                        let craftXP = CraftSystem.getXP(Globals.connectedUsers[authorIdentifier].character.itemCraftedLevel(toCraft.itemInfo.maxLevel), Globals.connectedUsers[authorIdentifier].character.getCraftLevel(), toCraft.itemInfo.idRarity, false);
                                        let craftXPBonus = craftBonus.getPercentageValue() * craftXP;
                                        let totalCraftXP = craftXP + craftXPBonus;

                                        let craftCraftUP = Globals.connectedUsers[authorIdentifier].character.addCraftXP(totalCraftXP);

                                        msg += Translator.getString(lang, "resources", "collect_gain_xp", [totalCraftXP, craftXPBonus]) + "\n";

                                        if (craftCraftUP > 0) {
                                            msg += Translator.getString(lang, "resources", craftCraftUP > 1 ? "job_level_up_plur" : "job_level_up", [craftCraftUP]);
                                        }
                                    }

                                } else {
                                    msg = Translator.getString(lang, "errors", "craft_dont_have_required_items");
                                }
                            } else {
                                msg = Translator.getString(lang, "errors", "craft_dont_have_required_level", [toCraft.itemInfo.minLevel]);
                            }
                        } else {
                            msg = Translator.getString(lang, "errors", "craft_dont_exist");
                        }
                    } else {
                        msg = Translator.getString(lang, "errors", "craft_tired_wait_x_seconds", [Math.ceil((Globals.connectedUsers[authorIdentifier].character.canFightAt - Date.now()) / 1000)]);
                    }
                } else {
                    msg = Translator.getString(lang, "errors", "craft_no_building");
                }
                break;
            case "collect":
                PStatistics.incrStat(Globals.connectedUsers[authorIdentifier].character.id, "commands_job", 1);
                let idToCollect = parseInt(args[0], 10);
                if (Globals.connectedUsers[authorIdentifier].character.canFightAt <= Date.now()) {
                    if (idToCollect && Number.isInteger(idToCollect)) {
                        let resourceToCollect = Globals.areasManager.getResource(Globals.connectedUsers[authorIdentifier].character.getIdArea(), idToCollect);
                        //idToCollect = Globals.areasManager.getResourceId(Globals.connectedUsers[authorIdentifier].character.getIdArea(), idToCollect);
                        if (resourceToCollect) {
                            if (resourceToCollect.requiredLevel <= Globals.connectedUsers[authorIdentifier].character.getCraftLevel()) {
                                let collectBonuses = currentArea.getAllBonuses();
                                Globals.connectedUsers[authorIdentifier].character.waitForNextResource(resourceToCollect.idRarity);
                                idToCollect = Globals.connectedUsers[authorIdentifier].character.getIdOfThisIdBase(resourceToCollect.idBaseItem);
                                if (CraftSystem.haveCollectItem(Globals.connectedUsers[authorIdentifier].character.getStat("intellect") + collectBonuses.collect_drop.getPercentage(), resourceToCollect.idRarity)) {
                                    if (idToCollect) {
                                        Globals.connectedUsers[authorIdentifier].character.inv.addToInventory(idToCollect, 1);
                                    } else {
                                        let idInsert = conn.query("INSERT INTO items(idItem, idBaseItem, level) VALUES(NULL, " + resourceToCollect.idBaseItem + ", " + 1 + ")")["insertId"];
                                        Globals.connectedUsers[authorIdentifier].character.inv.addToInventory(idInsert, 1);
                                    }

                                    PStatistics.incrStat(Globals.connectedUsers[authorIdentifier].character.id, "items_" + resourceToCollect.nomRarity + "_collected", 1);

                                    msg = Translator.getString(lang, "resources", "collected_x_resource", [1, resourceToCollect.nomItem]) + "\n";
                                } else {
                                    msg = Translator.getString(lang, "resources", "not_collected") + "\n";
                                }

                                // Si le joueur n'est pas max level en craft
                                if (Globals.connectedUsers[authorIdentifier].character.getCraftLevel() < Globals.maxLevel) {
                                    let collectXP = CraftSystem.getXP(resourceToCollect.requiredLevel, Globals.connectedUsers[authorIdentifier].character.getCraftLevel(), resourceToCollect.idRarity, true);
                                    let collectXPBonus = collectBonuses.xp_collect.getPercentageValue() * collectXP;
                                    let totalCollectXP = collectXP + collectXPBonus;
                                    let collectCraftUP = Globals.connectedUsers[authorIdentifier].character.addCraftXP(totalCollectXP);
                                    msg += Translator.getString(lang, "resources", "collect_gain_xp", [totalCollectXP, collectXPBonus]) + "\n";
                                    if (collectCraftUP > 0) {
                                        msg += Translator.getString(lang, "resources", collectCraftUP > 1 ? "job_level_up_plur" : "job_level_up", [collectCraftUP]);
                                    }
                                }


                            } else {
                                msg = Translator.getString(lang, "errors", "collect_dont_have_required_level", [resourceToCollect.requiredLevel]);
                            }

                        } else {
                            // error object don't exist
                            msg = Translator.getString(lang, "resources", "resource_dont_exist");
                        }
                    } else {
                        msg = Translator.getString(lang, "errors", "collect_enter_id_to_collect");
                    }
                } else {
                    msg = Translator.getString(lang, "errors", "collect_tired_wait_x_seconds", [Math.ceil((Globals.connectedUsers[authorIdentifier].character.canFightAt - Date.now()) / 1000)]);
                }
                break;
        }

        this.sendMessage(message, msg);
    }
}

module.exports = CraftinModule;