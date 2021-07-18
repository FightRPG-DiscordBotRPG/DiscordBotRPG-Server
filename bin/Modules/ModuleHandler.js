const GModule = require("./GModule");
const Translator = require("../Translator/Translator");
const Globals = require("../Globals");
const fs = require("fs");
const conn = require("../../conf/mysql");
const User = require("../User");
const Guild = require("../Guild");
const PStatistics = require("../Achievement/PStatistics");
const path = require('path');
const conf = require("../../conf/conf");
const versions = require("../../conf/versions");
const TournamentViewer = require("../Helper/TournamentViewer");
const express = require("express"),
    app = express(),
    port = conf.port,
    url = require('url'),
    compression = require('compression');
require('express-async-errors');
app.listen(port, () => console.log("Starting RESTful api server on: " + port));

class ModuleHandler extends GModule {
    constructor() {
        super();
        this.isReloadable = false;
        this.devMode = false;
        this.isActive = false;
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
        app.use(express.urlencoded({
            extended: true
        }));
        app.use(express.json());
        app.use(compression());
        app.use("/game", async (req, res, next) => {
            let urlParam1 = req.url.split("/");
            urlParam1 = urlParam1 != null ? urlParam1[1] == "admin" : false;
            if (Globals.activated || urlParam1) {
                next();
            } else {
                return res.json({
                    error: "The game is under maintenance. " + (Globals.maintenance_message != null ? "Reason: " + Globals.maintenance_message : ""),
                });
            }
        });
        app.use("/game", this.checkAuth);
        app.use("/game", async (req, res, next) => {
            if (res.locals.id != null) {
                if (Globals.connectedUsers[res.locals.id] != null) {
                    next();
                } else {
                    await this.connectUser(res.locals.id);
                    await next();
                }
            } else {
                return res.status(403).json({
                    error: 'No credentials sent!'
                });
            }
        });

        this.router = express.Router();
        this.router.use(this.checkAuth);
        this.router.use(this.isAdmin);



        app.use("/handler", this.router);

        this.loadAllModules();
        this.loadRoutes();
        this.loadHelper();
        this.crashHandler();

    }

    loadHelper() {
        let helpersRouter = express.Router();
        helpersRouter.get("/areas/resources", async (req, res) => {
            let urlParts = url.parse(req.url, true);
            let parameters = urlParts.query;
            let lang = "en";
            lang = parameters.lang != null ? (Translator.isLangExist(parameters.lang) ? parameters.lang : "en") : "en";
            let ressources = await conn.query("SELECT localizationareas.nameArea, localizationitems.nameItem FROM areasresources INNER JOIN collectableresources USING(idCollectableResource) INNER JOIN localizationareas ON areasresources.idArea = localizationareas.idArea INNER JOIN localizationitems ON collectableresources.idBaseItem = localizationitems.idBaseItem WHERE localizationareas.lang = ? AND localizationitems.lang = ? ORDER BY localizationareas.idArea", [lang, lang]);

            let html = "<p>Res" + (lang == "fr" ? "s" : "") + "ources : ";
            let precedName = "";
            for (let r of ressources) {
                if (precedName != r.nameArea) {
                    html += "</p>";
                    html += "<p>" + r.nameArea + "<br>";
                    precedName = r.nameArea;
                }
                html += r.nameItem + ", ";
            }
            html += "</p>";
            res.send(html);
        });
        helpersRouter.get("/versions", async (req, res) => {
            res.send(versions);
        });
        helpersRouter.get("/areas/tournaments", async (req, res) => {
            let urlParts = url.parse(req.url, true);
            let parameters = urlParts.query;
            res.send(new TournamentViewer().toHtml(parameters.lang != null ? (Translator.isLangExist(parameters.lang) ? parameters.lang : "en") : "en" ));
        });

        helpersRouter.get("/help/", async (req, res, next) => {
            await next();
            return res.json({
                guildsBasePriceLevel: Globals.guilds.basePriceLevel,
                collectTriesOnce: Globals.collectTriesOnce,
            });
        });

        helpersRouter.get("/characters/appearances", async (req, res, next) => {
            await next();
            return res.json({ possibleAppearances: await Appearance.getAllPossibleAppearances(), bodyAppearances: await Appearance.getAllPossibleBodyTypes(), itemsAppearances: ItemAppearance.appearances });
        });

        app.use("/helpers", helpersRouter);
    }

    loadAllModules() {

        fs.readdirSync(__dirname + "/Modules/").forEach(file => {
            console.log(file)
            this.loadModule(file);
        });
        this.getAllRoutes();
    }

    async checkAuth(req, res, next) {
        if (!req.headers.authorization) {
            return res.status(403).json({
                error: 'No credentials sent!'
            });
        } else {
            let authToken = req.headers.authorization.slice(7);
            let id = await User.getUserId(authToken + "");
            if (id) {
                res.locals.id = id;
                next();
            } else {
                return res.status(401).json({
                    error: 'Unknown User!'
                });
            }
        }

    }

    loadRoutes() {
        app.post("/register", async (req, res) => {
            if (req.body.key != null && req.body.key === conf.registerkey) {
                if (req.body.username != null) {
                    await this.connectUser(req.body.id, req.body.username, req.body.avatar);
                    let result = await conn.query("SELECT token FROM users WHERE idUser = ?;", [req.body.id]);
                    let token;
                    if (result[0]) {
                        token = result[0].token;
                    }
                    return res.json({
                        token: token
                    });
                }
            }
            return res.status(400).json({
                error: 'Bad Request'
            });
        });

        this.router.post("/test", async (req, res) => {
            res.send(req.body);
        });

        this.router.post("/load_module", async (req, res) => {
            if (this.loadModule(req.body.moduleName)) {
                return res.json({
                    success: "Module " + req.body.moduleName + " loaded successfully !"
                });
            } else {
                return res.json({
                    error: "An error occured when loading the module, module may not exist or can't be reloaded"
                })
            }
        });

        this.router.post("/disable_module", async (req, res) => {
            if (this.disableModule(req.body.moduleName)) {
                return res.json({
                    success: "Module " + req.body.moduleName + " disabled successfully !"
                });
            } else {
                return res.json({
                    error: "This module doesn't exist"
                })

            }
        });

        this.router.post("/enable_module", async (req, res) => {
            if (this.enableModule(req.body.moduleName)) {
                return res.json({
                    success: "Module " + req.body.moduleName + " enabled successfully !"
                });
            } else {
                return res.json({
                    error: "This module doesn't exist"
                });
            }
        });

        this.router.post("/load_all_modules", async (req, res) => {
            this.loadAllModules();
            return res.json({
                msg: "Done, check console for errors / warning"
            });
        });

        this.router.get("/disabled_modules", async (req, res) => {
            return res.json({
                msg: this.getDisabledModules()
            });
        });
    }

    getAllRoutes() {
        //console.log(app._router);
    }

    getDisabledModules() {
        let cmds = "";
        for (let m in this.modules) {
            if (!this.modules[m].isActive) {
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
                            if (mod.router != null) {
                                app.use("/game/" + moduleName.split("Module")[0].toLowerCase(), this.modules[moduleName].router);
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

    async connectUser(id, username, avatar) {
        let authorIdentifier = id;

        if (!Globals.connectedUsers[authorIdentifier]) {
            // Load User
            Globals.connectedUsers[authorIdentifier] = new User(authorIdentifier, username, avatar);
            await Globals.connectedUsers[authorIdentifier].loadUser();

            if (Globals.connectedUsers[authorIdentifier].isNew) {
                Globals.connectedUsers[authorIdentifier].character.setArea(Globals.areasManager.getArea(1));
            } else {
                // Making user moving out of dungeon when connecting
                let area = Globals.areasManager.getArea(Globals.connectedUsers[authorIdentifier].character.idArea);
                if (area.constructor === DungeonArea) {
                    area = await area.getEntrance();
                }
                Globals.connectedUsers[authorIdentifier].character.setArea(area);
            }


            // Load Guild
            if (await Globals.connectedUsers[authorIdentifier].character.isInGuild()) {
                let idGuild = await Globals.connectedUsers[authorIdentifier].character.getIDGuild();
                if (!Globals.connectedGuilds[idGuild]) {
                    Globals.connectedGuilds[idGuild] = new Guild();
                    await Globals.connectedGuilds[idGuild].loadGuild(idGuild);
                }
            }
            Globals.connectedUsers[authorIdentifier].isLoaded = true;
        }
        if (Globals.connectedUsers[authorIdentifier].isNew) {
            Globals.connectedUsers[authorIdentifier].isNew = false;
        }

    }




}

module.exports = ModuleHandler;

const DungeonArea = require("../Areas/DungeonArea");
const CharacterAppearance = require("../Appearance/CharacterAppearance");
const Appearance = require("../Appearance/Appearance");
const ItemAppearance = require("../Appearance/ItemAppearance");
