const GModule = require("./GModule");
const Translator = require("../Translator/Translator");
const Globals = require("../Globals");
const fs = require("fs");
const conn = require("../../conf/mysql");
const Discord = require("discord.js");
const User = require("../User");
const Guild = require("../Guild");
const PStatistics = require("../Achievement/PStatistics");

class ModuleHandler extends GModule {
    constructor() {
        super();
        this.isReloadable = false;
        this.prefixes = {};
        this.prefix = "::";
        /**
         * @type {Array<GModule>}
         */
        this.modules = {};
        /**
         * @type {Array<GModule>}
         */
        this.commandsReact = {};
        this.startLoading("ModuleHandler");
        this.init();
        this.endLoading("ModuleHandler");
    }

    init() {
        this.loadAllModules();
        this.loadPrefixes();
    }

    loadAllModules() {
        fs.readdirSync(__dirname + "/Modules/").forEach(file => {
            this.loadModule(file);
        });
    }

    async run(message) {
        if (Globals.activated === false && Globals.admins.indexOf(message.author.id) === -1) {
            return;
        }

        let msg = "";
        let authorIdentifier = message.author.id;
        let isAdmin = Globals.admins.indexOf(message.author.id) > -1;
        let prefix = this.getPrefix(message.channel.guild ? message.channel.guild.id : null);
        if (!message.content.startsWith(prefix)) return;

        let args = [].concat.apply([], message.content.slice(prefix.length).trim().split('"').map(function (v, i) {
            return i % 2 ? v : v.split(' ')
        })).filter(Boolean);

        let command = args.shift();
        command = command != null ? command.toLowerCase() : "";


        if (!message.author.bot && command != null) {
            PStatistics.logCommand(authorIdentifier, command, Date.now());
            await this.connectUser(message);

            // exec module corresponding to command
            await this.executeCommand(message, command, args);


            switch (command) {
                case "prefix":
                    msg = this.prefixCommand(message, command, args, "en");
                    break;
                case "load_module":
                    if (isAdmin) {
                        if (this.loadModule(args[0])) {
                            msg = "Module " + args[0] + " loaded successfully !";
                        } else {
                            msg = "An error occured when loading the module, module may not exist or can't be reloaded";
                        }
                    }
                    break;
                case "disable_module":
                    if (isAdmin) {
                        if (this.disableModule(args[0])) {
                            msg = "Module " + args[0] + " disabled successfully !";
                        } else {
                            msg = "This module doesn't exist";
                        }
                    }
                    break;
                case "enable_module":
                    if (isAdmin) {
                        if (this.enableModule(args[0])) {
                            msg = "Module " + args[0] + " enabled successfully !";
                        } else {
                            msg = "This module doesn't exist";
                        }
                    }
                    break;
                case "load_all_modules":
                    if (isAdmin) {
                        this.loadAllModules();
                        msg = "Done, check console for errors / warning";
                    }
                    break;
                case "disabled_modules":
                    if(isAdmin) {
                        msg = this.getDisabledModules();
                    }
                    break;
            }

            this.sendMessage(message, msg);
        }
    }

    getDisabledModules() {
        let cmds = "";
        for(let m in this.modules) {
            if(!this.modules[m].isActive) {
                cmds += this.modules[m].commands.toString() + "\n";
            }
        }
        return cmds != "" ? cmds : "Tous les modules fonctionnent";
    }

    loadModule(moduleName) {
        if (moduleName != null) {
            moduleName = moduleName.split(".")[0];
            if (fs.existsSync(__dirname + "/Modules/" + moduleName + ".js")) {
                if (this.modules[moduleName] != null) {
                    if (this.modules[moduleName].isReloadable) {
                        for (let cmd of this.modules[moduleName].commands) {
                            if (this.commandsReact[cmd]) delete this.commandsReact[cmd];
                        }
                        delete this.modules[moduleName];
                        delete require.cache[require.resolve("./Modules/" + moduleName + ".js")];
                        return this.loadModule(moduleName);
                    }
                } else {
                    // new module
                    let moduleObject = require("./Modules/" + moduleName);
                    if (moduleObject != null && typeof (moduleObject) == "function") {
                        let mod = new moduleObject();
                        if (mod.isModule) {
                            this.modules[moduleName] = mod;
                            for (let cmd of mod.commands) {
                                this.commandsReact[cmd] = mod;
                            }
                            return true;
                        } else {
                            delete require.cache[require.resolve("./Modules/" + moduleName + ".js")];
                        }
                    } else {
                        delete require.cache[require.resolve("./Modules/" + moduleName + ".js")];
                    }
                }
            }

        }

        return false;
    }

    prefixCommand(message, command, args, lang) {
        if (message.guild && message.author.id === message.guild.ownerID) {
            if (args[0]) {
                if (args[0].length <= 10) {
                    let oldPrefix = this.getPrefix(message.guild.id);
                    this.prefixChange(message.guild.id, args[0]);
                    return new Discord.RichEmbed()
                        .setColor([0, 128, 128])
                        .setAuthor(Translator.getString(lang, "other", "prefix_changed"))
                        .addField(Translator.getString(lang, "other", "old_prefix"), oldPrefix)
                        .addField(Translator.getString(lang, "other", "new_prefix"), this.getPrefix(message.guild.id));
                } else {
                    return Translator.getString(lang, "errors", "prefix_max_length", [10]);
                }
            } else {
                return Translator.getString(lang, "errors", "prefix_undefined");
            }
        } else {
            return Translator.getString(lang, "errors", "prefix_not_owner_server");
        }
    }

    prefixChange(idServer, newPrefix) {
        this.prefixes[idServer] = newPrefix;
        conn.query("UPDATE serversstats SET serverPrefix = ? WHERE idServer = ?", [newPrefix, idServer]);
    }

    loadPrefixes() {
        let prefixes = conn.query("SELECT idServer, serverPrefix FROM serversstats WHERE serverPrefix != '::'");
        for (let result of prefixes) {
            this.prefixes[result.idServer] = result.serverPrefix;
        }
    }

    getPrefix(idServer) {
        if (this.prefixes[idServer]) {
            return this.prefixes[idServer];
        }
        return this.prefix;
    }

    disableModule(moduleName) {
        if (moduleName != null) {
            moduleName = moduleName.split(".")[0];
            if (this.modules[moduleName] != null) {
                this.modules[moduleName].isActive = false;
                return true;
            }
        }
        return false;
    }

    enableModule(moduleName) {
        if (moduleName != null) {
            moduleName = moduleName.split(".")[0];
            if (this.modules[moduleName] != null) {
                this.modules[moduleName].isActive = true;
                return true;
            }
        }
        return false;
    }

    async executeCommand(message, command, args) {
        let mod = this.commandsReact[command];
        if (mod != null) {
            if (mod.isActive) {
                try {
                    await mod.run(message, command, args);
                } catch (err) {
                    mod.isActive = false;
                    message.channel.send("Due to an error, this module is deactivated. The following commands will be disabled : " + mod.commands.toString());
                    throw err;
                }
            } else {
                message.channel.send("Due to an error, this module is currently deactivated. The following commands will be disabled : " + mod.commands.toString() + "\nSorry for the inconvenience.");
            }
        }
    }

    async connectUser(message) {
        let authorIdentifier = message.author.id;
        let lang;
        if (!Globals.connectedUsers[authorIdentifier]) {
            let characterLoadingMessage = null;
            try {
                characterLoadingMessage = await message.channel.send("<a:loading:393852367751086090> " + Translator.getString("en", "other", "loading_character"));
            } catch (err) {}

            // Load User
            Globals.connectedUsers[authorIdentifier] = new User(authorIdentifier, message.author.tag);
            Globals.connectedUsers[authorIdentifier].loadUser();

            Globals.connectedUsers[authorIdentifier].avatar = message.author.avatarURL;
            Globals.connectedUsers[authorIdentifier].character.setArea(Globals.areasManager.getArea(Globals.connectedUsers[authorIdentifier].character.idArea));

            lang = Globals.connectedUsers[authorIdentifier].getLang();

            // Load Guild
            if (Globals.connectedUsers[authorIdentifier].character.isInGuild()) {
                if (!Globals.connectedGuilds[Globals.connectedUsers[authorIdentifier].character.idGuild]) {
                    Globals.connectedGuilds[Globals.connectedUsers[authorIdentifier].character.idGuild] = new Guild();
                    Globals.connectedGuilds[Globals.connectedUsers[authorIdentifier].character.idGuild].loadGuild(Globals.connectedUsers[authorIdentifier].character.idGuild);
                }
            }
            if (characterLoadingMessage != null) {
                try {
                    await characterLoadingMessage.edit("<:check:314349398811475968> " + Translator.getString(lang, "other", "character_loaded"));
                } catch (err) {}
            }

        } else {
            lang = Globals.connectedUsers[authorIdentifier].getLang();
        }

        

        if (Globals.connectedUsers[authorIdentifier].isNew) {
            message.author.send(Translator.getString(lang, "help_panel", "tutorial", [Globals.help.tutorialLink])).catch((e) => {
                console.log(e)
            });
            Globals.connectedUsers[authorIdentifier].isNew = false;
        }

    }




}

module.exports = ModuleHandler;