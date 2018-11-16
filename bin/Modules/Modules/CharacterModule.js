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



class CharacterModule extends GModule {
    constructor() {
        super();
        this.commands = ["reset", "leaderboard", "info", "up"];
        this.startLoading("Character");
        this.init();
        this.endLoading("Character");

        this.authorizedAttributes = ["str", "int", "con", "dex", "cha", "will", "luck", "wis", "per"];
    }

    init() {
        this.router = express.Router();
        this.loadNeededVariables();
        this.router.use((req, res, next) => {
            PStatistics.incrStat(Globals.connectedUsers[res.locals.id].character.id, "commands_character", 1);
            next();
        });
        this.reactHandler();
        this.loadRoutes();
        this.crashHandler();
    }

    loadRoutes() {
        this.router.get("/leaderboard", async (req, res) => {
            let data = Leaderboard.getPlayerLeaderboard(Globals.connectedUsers[res.locals.id].character.id);
            data.lang = res.locals.lang;
            return res.json(
                data
            )
        });

        this.router.get("/reset", async (req, res) => {
            if (Globals.connectedUsers[res.locals.id].character.resetStats()) {
                return res.json({
                    success: Translator.getString(res.locals.lang, "character", "reset_done"),
                    lang: res.locals.lang,
                });
            } else {
                return res.json({
                    error: Translator.getString(res.locals.lang, "errors", "character_you_dont_have_enough_to_reset"),
                    lang: res.locals.lang,
                });
            }

        });

        this.router.get("/info", async (req, res) => {
            let data = Globals.connectedUsers[res.locals.id].apiInfoPanel(res.locals.lang);
            return res.json(
                data
            );
        });

        this.router.post("/up", async (req, res) => {
            let err;
            if (this.authorizedAttributes.indexOf(req.body.attr) !== -1) {
                let done = Globals.connectedUsers[res.locals.id].character.upStat(req.body.attr, parseInt(req.body.number));
                if (done) {
                    return res.json({
                        value: Globals.connectedUsers[res.locals.id].character.stats[this.getToStrShort(req.body.attr)],
                        pointsLeft: Globals.connectedUsers[res.locals.id].character.statPoints,
                        lang: res.locals.lang
                    });
                } else {
                    err = Translator.getString(res.locals.lang, "errors", "character_you_cant_distribute_this_amount_of_points");
                }
            } else {
                err = Translator.getString(res.locals.lang, "errors", "character_attribute_dont_exist");
            }
            res.json({
                error: err,
                lang: res.locals.lang,
            });
        });


    }

}

module.exports = CharacterModule;