const Globals = require("../Globals");
const LootSystem = require("../LootSystem");
const axios = require("axios").default;


class GModule {
    constructor() {
        this.isReloadable = true;
        this.loadingTime = 0;
        this.isModule = true;
        this.isLoaded = false;
        this.isActive = true;
        this.router = null;
        this.commands = [];
    }

    async run() {}

    init() {

    }

    startLoading(name = "Generic Module") {
        this.loadingTime = Date.now();
        console.log("Loading module : " + name);
    }

    endLoading(name = "Generic Module") {
        console.log("Module : " + name + " loaded. Took : " + ((Date.now() - this.loadingTime) / 1000) + " seconds.");
        this.isLoaded = true;
    }

    sendMessage(message, msg) {
        msg != null && msg != "" ? message.channel.send(msg).catch((error) => {
            message.author.send(error.message).catch((e) => {
                console.log(e)
            });
        }) : null;
    }

    crashHandler() {
        if (this.router != null) {
            this.router.use(async (err, req, res, next) => {
                console.log(err);
                if (this.isReloadable) {
                    if (!this.devMode) {
                        this.isActive = false;
                        let msgError = "Due to an error, this module is deactivated. The following commands will be disabled : " + this.commands.toString() + "\n";
                        msgError += "Oops something goes wrong, report the issue here (https://github.com/FightRPG-DiscordBotRPG/FightRPG-Discord-BugTracker/issues)\n";

                        let errorsLines = err.stack.split("\n");
                        let nameAndLine = errorsLines[1].split(" ");
                        nameAndLine = nameAndLine[nameAndLine.length - 1].split("\\");
                        nameAndLine = nameAndLine[nameAndLine.length - 1].split(")")[0];

                        msgError += "```js\n" + errorsLines[0] + "\nat " + nameAndLine + "\n```";

                        let adminTell = "A module has crashed.\n" + mod.commands.toString() + "\n" + "User that have crashed the command : " + Globals.connectedUsers[res.locals.id] ? Globals.connectedUsers[res.locals.id].character.getName() : "Unknown";
                        try {
                            await axios.post("http://127.0.0.1:48921", {
                                id: "241564725870198785",
                                message: adminTell,
                            });
                        } catch (e) {
                            console.log(e);
                        }

                        return res.json({
                            error: msgError,
                        });
                    }
                }
                return res.json({
                    error: "There is something wrong with this module :/",
                });
            });
        }
    }

    reactHandler() {
        this.router.use((req, res, next) => {
            if (this.isActive == true || this.devMode == true) {
                next();
            } else {
                return res.json({
                    error: "Due to an error, this module is deactivated. The following commands will be disabled : " + this.commands.toString(),
                });
            }
        });
    }

    loadNeededVariables() {
        this.router.use((req, res, next) => {
            res.locals.group = Globals.connectedUsers[res.locals.id].character.group;
            res.locals.lang = Globals.connectedUsers[res.locals.id].getLang();
            res.locals.pending = Globals.connectedUsers[res.locals.id].character.pendingPartyInvite;
            res.locals.marketplace = Globals.areasManager.getService(Globals.connectedUsers[res.locals.id].character.getIdArea(), "marketplace");
            res.locals.craftingbuilding = Globals.areasManager.getService(Globals.connectedUsers[res.locals.id].character.getIdArea(), "craftingbuilding");
            res.locals.currentArea = Globals.connectedUsers[res.locals.id].character.getArea();
            res.locals.tLootSystem = new LootSystem();
            next();
        });

    }


    getToStrShort(stat, lang) {
        switch (stat) {
            // Principaux
            case "str":
                stat = "strength";
                break;
            case "int":
                stat = "intellect";
                break;
            case "con":
                stat = "constitution";
                break;
            case "dex":
                stat = "dexterity";
                break;

                // Secondaires

            case "cha":
                stat = "charisma";
                break;
            case "wis":
                stat = "wisdom";
                break;
            case "will":
                stat = "will";
                break;
            case "per":
                stat = "perception";
                break;
            case "luck":
                stat = "luck";
                break;
        }
        return stat;
    }

    getEquipableIDType(string) {
        return Globals.equipableCorresponds[string] != null ? Globals.equipableCorresponds[string] : -1;
    }

    async isAdmin(req, res, next) {
        if (res.locals.id && Globals.admins.indexOf(res.locals.id) > -1) {
            next();
        } else {
            return res.status(403).json({
                error: 'Not Authorized!'
            });
        }
    }



}



module.exports = GModule;