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
const Stats = require("../../Stats/Stats");
const AreaBonus = require("../../Areas/AreaBonus");

class CraftingModule extends GModule {
    constructor() {
        super();
        this.commands = ["craftlist", "craftshow", "craft", "collect", "resources"];
        this.startLoading("Crafting");
        this.init();
        this.endLoading("Crafting");
    }

    init() {
        super.init();
        this.router.use((req, res, next) => {
            PStatistics.incrStat(Globals.connectedUsers[res.locals.id].character.id, "commands_job", 1);
            next();
        });
    }

    loadRoutes() {
        this.router.get("/craftlist/:page?", async (req, res, next) => {
            let data = {};

            if (res.locals.craftingbuilding != null) {
                data = await res.locals.craftingbuilding.craftingListToApi(req.params.page, this.getSearchParams(req), res.locals.lang);
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "craft_no_building");
            }
            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.get("/craftshow/:idCraft?", async (req, res, next) => {
            let data = {};

            if (res.locals.craftingbuilding != null) {
                let craft = await res.locals.craftingbuilding.getCraft(req.params.idCraft, res.locals.lang);
                if (craft != null) {
                    craft = await Globals.connectedUsers[res.locals.id].character.inv.getCraftMissingComponents(craft);
                    data.craft = await craft.toApi(res.locals.lang);
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "craft_dont_exist");
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "craft_no_building");
            }

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.post("/craft", async (req, res, next) => {
            let data = await this.doCraft(req, res);
            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.post("/collect", async (req, res, next) => {
            let data = await this.doCollect(req, res);
            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.get("/resources", async (req, res, next) => {
            let data = {};

            data.success = Translator.getString(res.locals.lang, "area", "follow_the_link") + "\n";
            data.success += "http://api.fight-rpg.com/helpers/areas/resources?lang=" + res.locals.lang;

            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

    }

    /**
    *
    * @param {express.Request} req
    * @param {express.Response} res
    */
    async doCollect(req, res) {
        let idToCollect = parseInt(req.body.idResource, 10);
        let numberToCollect = parseInt(req.body.number, 10);
        numberToCollect = !isNaN(numberToCollect) && numberToCollect > 0 && numberToCollect <= Globals.collectTriesOnce ? numberToCollect : 1;

        let character = Globals.connectedUsers[res.locals.id].character;

        if (!character.canDoAction()) {
            return this.asError(Translator.getString(res.locals.lang, "errors", "collect_tired_wait_x_seconds", [character.getExhaust()]));
        }

        if (!(idToCollect && Number.isInteger(idToCollect))) {
            return this.asError(Translator.getString(res.locals.lang, "errors", "collect_enter_id_to_collect"));
        }

        let resourceToCollect = Globals.areasManager.getResource(character.getIdArea(), idToCollect);

        if (!resourceToCollect) {
            return this.asError(Translator.getString(res.locals.lang, "resources", "resource_dont_exist"));
        }

        if (resourceToCollect.minLevel > character.getCraftLevel() || resourceToCollect.minRebirthLevel > character.getCraftRebirthLevel()) {
            return this.asError(Translator.getString(res.locals.lang, "errors", "collect_dont_have_required_level", [resourceToCollect.minLevel, resourceToCollect.minRebirthLevel]));
        }

        let collectBonuses = await res.locals.currentArea.getAllBonuses();

        character.waitForNextResource(resourceToCollect.idRarity, numberToCollect);
        idToCollect = await character.getIdOfThisIdBase(resourceToCollect.idBaseItem);

        let numberItemsCollected = CraftSystem.getNumberOfItemsCollected(character.getStat(Stats.possibleStats.Intellect) * (1 + collectBonuses[AreaBonus.identifiers.collectDrop].getPercentage()), resourceToCollect.idRarity, character.getArea().areaClimate.currentWeather, numberToCollect);

        let data = this.asSuccess(Translator.getString(res.locals.lang, "resources", "tried_to_collect_x_times", [numberToCollect]) + "\n");

        // Give to player items
        if (numberItemsCollected > 0) {
            if (idToCollect) {
                await character.inv.addToInventory(idToCollect, numberItemsCollected);
            } else {
                let idInsert = await Item.lightInsert(resourceToCollect.idBaseItem, 1);
                await character.inv.addToInventory(idInsert, numberItemsCollected);
            }

            PStatistics.incrStat(character.id, "items_" + resourceToCollect.nomRarity + "_collected", numberItemsCollected);

            data.success += Translator.getString(res.locals.lang, "resources", "collected_x_resource", [numberItemsCollected, Translator.getString(res.locals.lang, "itemsNames", resourceToCollect.idBaseItem)]) + "\n";
        } else {
            data.success += Translator.getString(res.locals.lang, "resources", "not_collected") + "\n";
        }

        // If player is not max level give exp
        if (character.getCraftLevel() < Globals.maxLevel) {
            let collectXP = CraftSystem.getXP(character.getCraftLevel(), character.getCraftLevel(), resourceToCollect.idRarity, true) * numberToCollect;
            let collectXPBonus = collectBonuses[AreaBonus.identifiers.xpCollect].getPercentageValue() * collectXP;
            let totalCollectXP = collectXP + collectXPBonus;
            let collectCraftUP = await character.addCraftXP(totalCollectXP);
            data.success += Translator.getString(res.locals.lang, "resources", "collect_gain_xp", [totalCollectXP, collectXPBonus]) + "\n";
            if (collectCraftUP > 0) {
                data.success += Translator.getString(res.locals.lang, "resources", collectCraftUP > 1 ? "job_level_up_plur" : "job_level_up", [collectCraftUP]);
            }
        }

        return data;

    }

    /**
    *
    * @param {express.Request} req
    * @param {express.Response} res
    */
    async doCraft(req, res) {
        if (res.locals.craftingbuilding == null) {
            return this.asError(Translator.getString(res.locals.lang, "errors", "craft_no_building"));
        }

        if (!Globals.connectedUsers[res.locals.id].character.canDoAction()) {
            return this.asError(Translator.getString(res.locals.lang, "errors", "craft_tired_wait_x_seconds", [Globals.connectedUsers[res.locals.id].character.getExhaust()]));
        }

        /* ToCraft = Craft type
        * @type {Craft}
        */
        let toCraft = await res.locals.craftingbuilding.getCraft(req.body.idCraft, res.locals.lang);

        if (!toCraft) {
            return this.asError(Translator.getString(res.locals.lang, "errors", "craft_dont_exist"));
        }

        if (!Globals.connectedUsers[res.locals.id].character.isCraftable(toCraft)) {
            return this.asError(Translator.getString(res.locals.lang, "errors", "craft_dont_have_required_level", [toCraft.itemInfo.minLevel]));
        }

        let isCraftLevelCorrect = req.body.level == null || res.locals.craftingbuilding.isCraftLevelPossible(req.body.level);

        if (!isCraftLevelCorrect) {
            return this.asError(Translator.getString(res.locals.lang, "errors", "craft_level_incorrect"));
        }


        let rebirthLevel = req.body.rebirthLevel == null ? Globals.connectedUsers[res.locals.id].character.getCraftRebirthLevel() : req.body.rebirthLevel;

        if (!res.locals.craftingbuilding.isCraftRebirthLevelPossible(rebirthLevel)) {
            return this.asError(Translator.getString(res.locals.lang, "errors", "craft_rebirth_level_incorrect"))
        }

        let isCraftDone = await Globals.connectedUsers[res.locals.id].character.craft(toCraft, req.body.level, rebirthLevel);

        if (!isCraftDone) {
            return this.asError(Translator.getString(res.locals.lang, "errors", "craft_dont_have_required_items"));
        }

        let data = this.asSuccess(Translator.getString(res.locals.lang, "craft", "craft_done", [Translator.getString(res.locals.lang, "itemsNames", toCraft.itemInfo.idBase)]) + "\n")

        Globals.connectedUsers[res.locals.id].character.waitForNextCraft(toCraft.itemInfo.idRarity);

        PStatistics.incrStat(Globals.connectedUsers[res.locals.id].character.id, "items_" + toCraft.getRarity() + "_craft", 1);

        // Seulement s'il n'est pas niveau max
        if (Globals.connectedUsers[res.locals.id].character.getCraftLevel() < Globals.maxLevel) {
            let craftBonus = (await res.locals.currentArea.getAllBonuses())[AreaBonus.identifiers.xpCraft];
            let craftXP = CraftSystem.getXP(Globals.connectedUsers[res.locals.id].character.itemCraftedLevel(toCraft.itemInfo.maxLevel), Globals.connectedUsers[res.locals.id].character.getCraftLevel(), toCraft.itemInfo.idRarity, false);
            let craftXPBonus = Math.round(craftBonus.getPercentageValue() * craftXP);
            let totalCraftXP = craftXP + craftXPBonus;

            let numberOfLevelGained = await Globals.connectedUsers[res.locals.id].character.addCraftXP(totalCraftXP);

            data.success += Translator.getString(res.locals.lang, "resources", "collect_gain_xp", [totalCraftXP, craftXPBonus]) + "\n";

            if (numberOfLevelGained > 0) {
                data.success += Translator.getString(res.locals.lang, "resources", numberOfLevelGained > 1 ? "job_level_up_plur" : "job_level_up", [numberOfLevelGained]);
            }
        }

        return data;
    }
}






module.exports = CraftingModule;