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


class TravelModule extends GModule {
    constructor() {
        super();
        this.commands = ["area", "areas", "travel", "areaplayers"];
        this.startLoading("Travel");
        this.init();
        this.endLoading("Travel");
    }

    async run(message, command, args) {
        let msg = "";
        let authorIdentifier = message.author.id;
        let mentions = message.mentions.users;
        let group = Globals.connectedUsers[authorIdentifier].character.group;
        let lang = Globals.connectedUsers[authorIdentifier].getLang();
        let pending = Globals.connectedUsers[authorIdentifier].character.pendingPartyInvite;
        let marketplace = Globals.areasManager.getService(Globals.connectedUsers[authorIdentifier].character.getIdArea(), "marketplace");
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

        PStatistics.incrStat(Globals.connectedUsers[authorIdentifier].character.id, "commands_areas", 1);

        switch (command) {
            case "area":
                msg = Globals.areasManager.seeThisArea(Globals.connectedUsers[authorIdentifier].character.getIdArea(), lang);
                break;

            case "areas":
                msg = Globals.areasManager.seeAllAreasInThisRegion(currentArea, lang);
                break;

            case "travel":
                let wantedAreaToTravel = parseInt(args[0], 10);
                if (Globals.connectedUsers[authorIdentifier].character.canFightAt <= Date.now()) {
                    if (Globals.areasManager.existInRegion(Globals.connectedUsers[authorIdentifier].character.getIDRegion(), wantedAreaToTravel)) {
                        let areaObjectTravel = Globals.areasManager.getAreaForThisRegion(Globals.connectedUsers[authorIdentifier].character.getIDRegion(), wantedAreaToTravel);
                        if (areaObjectTravel.getID() == Globals.connectedUsers[authorIdentifier].character.getIdArea()) {
                            msg = Translator.getString(lang, "errors", "travel_already_here");
                        } else {

                            let costs = Globals.areasManager.getPathCosts(Globals.connectedUsers[authorIdentifier].character.getIdArea(), areaObjectTravel.getID());
                            let checkEmoji = Emojis.getID("vmark");
                            let xmarkEmoji = Emojis.getID("xmark");
                            let tempMsg = await message.channel.send(new Discord.RichEmbed()
                                .setColor([0, 255, 0])
                                .setAuthor(Translator.getString(lang, "travel", "travel_planning", [Globals.connectedUsers[authorIdentifier].character.getArea().getName(lang), areaObjectTravel.getName(lang)]))
                                .addField(Translator.getString(lang, "travel", "wait_time_title"), Translator.getString(lang, "travel", "wait_time_body", [costs.timeToWait]), true)
                                .addField(Translator.getString(lang, "travel", "gold_price_title"), Translator.getString(lang, "travel", "gold_price_body", [costs.goldPrice]), true)
                                .addField(Translator.getString(lang, "travel", "sure_to_travel_title"), Translator.getString(lang, "travel", "sure_to_travel_body", [Emojis.getString("vmark"), Emojis.getString("xmark")]))
                            ).catch(e => null);
                            await Promise.all([
                                tempMsg.react(checkEmoji),
                                tempMsg.react(xmarkEmoji)
                            ]).catch(e => null);

                            const filter = (reaction, user) => {
                                return [checkEmoji, xmarkEmoji].includes(reaction.emoji.id) && user.id === message.author.id;
                            };


                            const collected = await tempMsg.awaitReactions(filter, {
                                max: 1,
                                time: 10000
                            });
                            const reaction = collected.first();
                            if (reaction != null) {
                                switch (reaction.emoji.id) {
                                    case checkEmoji:
                                        if (Globals.connectedUsers[authorIdentifier].character.canFightAt <= Date.now()) {
                                            // Update le compte de joueurs
                                            wantedAreaToTravel = Globals.areasManager.getArea(areaObjectTravel.getID());

                                            // change de zone
                                            Globals.connectedUsers[authorIdentifier].character.changeArea(wantedAreaToTravel, Globals.areasManager.getPathCosts(Globals.connectedUsers[authorIdentifier].character.getIdArea(), parseInt(args[0], 10)).timeToWait);

                                            // Messages
                                            msg = Translator.getString(lang, "travel", "travel_to_area", [wantedAreaToTravel.getName(lang)]);
                                            msg += "\n" + Translator.getString(lang, "travel", "travel_to_area_exhaust", [Math.ceil((Globals.connectedUsers[authorIdentifier].character.canFightAt - Date.now()) / 1000)]);
                                        } else {
                                            msg = Translator.getString(lang, "errors", "travel_tired_wait_x", [Math.ceil((Globals.connectedUsers[authorIdentifier].character.canFightAt - Date.now()) / 1000)]);
                                        }

                                        break;

                                    case xmarkEmoji:
                                        msg = Translator.getString(lang, "travel", "travel_cancel");
                                        break;
                                }
                            }
                            tempMsg.delete().catch(e => null);
                        }

                    } else {
                        msg = Translator.getString(lang, "errors", "travel_area_dont_exist");
                    }
                } else {
                    msg = Translator.getString(lang, "errors", "travel_tired_wait_x", [Math.ceil((Globals.connectedUsers[authorIdentifier].character.canFightAt - Date.now()) / 1000)]);
                }
                break;

            case "areaplayers":
                apPage = parseInt(args[0], 10);
                if (!apPage || !Number.isInteger(apPage)) {
                    apPage = 1;
                }
                msg = Globals.areasManager.getPlayersOf(Globals.connectedUsers[authorIdentifier].character.getIdArea(), apPage, lang);
                break;
        }

        this.sendMessage(message, msg);
    }
}

module.exports = TravelModule;