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


class OtherModule extends GModule {
    constructor() {
        super();
        this.commands = ["lang", "settings"];
        this.startLoading("Other");
        this.init();
        this.endLoading("Other");
    }
    init() {
        super.init();
        this.router.use((req, res, next) => {
            PStatistics.incrStat(Globals.connectedUsers[res.locals.id].character.id, "commands_other", 1);
            next();
        });
    }

    loadRoutes() {
        this.router.get("/lang", async (req, res, next) => {
            let data = {};
            data.lang = res.locals.lang;
            data.languages = Translator.getAvailableLanguages(res.locals.lang);
            await next();
            return res.json(data);
        });

        this.router.post("/lang", async (req, res, next) => {
            let data = {};
            data.lang = res.locals.lang;
            if (req.body.lang) {
                if (Translator.isLangExist(req.body.lang)) {
                    await Globals.connectedUsers[res.locals.id].changeLang(req.body.lang);
                    data.lang = req.body.lang;
                    data.success = Translator.getString(req.body.lang, "languages", "lang_changed", [Translator.getString(req.body.lang, "languages", req.body.lang)])
                } else {
                    data.error = Translator.getString(res.locals.lang, "errors", "languages_lang_dont_exist");
                }
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "languages_lang_dont_exist");
            }
            await next();
            return res.json(data);
        });

        this.router.get("/settings", async (req, res, next) => {
            let data = {
                isGroupMuted: Globals.connectedUsers[res.locals.id].isGroupMuted(),
                isMarketplaceMuted: Globals.connectedUsers[res.locals.id].isMarketplaceMuted(),
                isFightMuted: Globals.connectedUsers[res.locals.id].isFightMuted(),
                isWorldBossesMuted: Globals.connectedUsers[res.locals.id].isWorldBossesMuted(),
            }
            data.lang = res.locals.lang;
            await next();
            return res.json(data);
        });

        this.router.post("/settings", async (req, res, next) => {
            let data = {};
            let success = "";
            data.lang = res.locals.lang;
            if (req.body.mGroup != null) {
                if (Globals.connectedUsers[res.locals.id].isGroupMuted()) {
                    await Globals.connectedUsers[res.locals.id].muteGroup(false);
                    success += Translator.getString(res.locals.lang, "group", "now_unmuted") + "\n";
                } else {
                    await Globals.connectedUsers[res.locals.id].muteGroup(true);
                    success += Translator.getString(res.locals.lang, "group", "now_muted") + "\n";
                }
            }
            if (req.body.mMarket != null) {
                if (Globals.connectedUsers[res.locals.id].isMarketplaceMuted()) {
                    await Globals.connectedUsers[res.locals.id].muteMarketplace(false);
                    success += Translator.getString(res.locals.lang, "marketplace", "now_unmuted") + "\n";
                } else {
                    await Globals.connectedUsers[res.locals.id].muteMarketplace(true);
                    success += Translator.getString(res.locals.lang, "marketplace", "now_muted") + "\n";
                }
            }
            if (req.body.mFight != null) {
                if (Globals.connectedUsers[res.locals.id].isFightMuted()) {
                    await Globals.connectedUsers[res.locals.id].muteFight(false);
                    success += Translator.getString(res.locals.lang, "fight_general", "now_unmuted") + "\n";
                } else {
                    await Globals.connectedUsers[res.locals.id].muteFight(true);
                    success += Translator.getString(res.locals.lang, "fight_general", "now_muted") + "\n";
                }
            }
            if (req.body.mTrade != null) {
                if (Globals.connectedUsers[res.locals.id].isTradeMuted()) {
                    await Globals.connectedUsers[res.locals.id].muteTrade(false);
                    success += Translator.getString(res.locals.lang, "trade", "now_unmuted") + "\n";
                } else {
                    await Globals.connectedUsers[res.locals.id].muteTrade(true);
                    success += Translator.getString(res.locals.lang, "trade", "now_muted") + "\n";
                }
            }

            if (req.body.mWorldBoss != null) {
                if (Globals.connectedUsers[res.locals.id].isWorldBossesMuted()) {
                    await Globals.connectedUsers[res.locals.id].muteWorldBoss(false);
                    success += Translator.getString(res.locals.lang, "world_bosses", "now_unmuted") + "\n";
                } else {
                    await Globals.connectedUsers[res.locals.id].muteWorldBoss(true);
                    success += Translator.getString(res.locals.lang, "world_bosses", "now_muted") + "\n";
                }
            }
            if (success != "") {
                data.success = success;
            } else {
                data.error = Translator.getString(res.locals.lang, "errors", "generic_cant_do_that");
            }
            await next();
            return res.json(data);
        });

        this.router.get("/rarities", async (req, res, next) => {
            let data = {};

            let dbRes = await conn.query("SELECT * FROM itemsrarities");
            data.rarities = [];
            for (let result of dbRes) {
                data.rarities.push({
                    idRarity: result.idRarity,
                    rarityName: Translator.getString(res.locals.lang, "rarities", result.nomRarity),
                    rarityColor: result.couleurRarity
                })
            }

            data.lang = res.locals.lang;

            await next();
            return res.json(data);
        });

        this.router.get("/types", async (req, res, next) => {
            let data = {};

            let dbRes = await conn.query("SELECT * FROM itemstypes");
            data.types = [];
            for (let result of dbRes) {
                data.types.push({
                    idType: result.idType,
                    typeName: Translator.getString(res.locals.lang, "item_types", result.nomType),
                    equipable: result.equipable,
                    stackable: result.stackable,
                    usable: result.usable,
                });
            }

            data.lang = res.locals.lang;

            await next();
            return res.json(data);
        });
    }
}

module.exports = OtherModule;