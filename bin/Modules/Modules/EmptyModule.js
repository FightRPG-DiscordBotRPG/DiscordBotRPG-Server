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

class NonameModule extends GModule {
    constructor() {
        super();
        this.commands = ["command1"];
        this.startLoading("Noname");
        this.init();
        this.endLoading("Noname");
    }

    init() {
        //this.router = express.Router();
        //app.use("/", this.router);
        super.init();
        this.loadRoutes();
        //this.crashHandler();
    }

    loadRoutes() {

    }

    async run(message, command, args) {
        let msg = "";
        this.sendMessage(message, msg);
    }
}

module.exports = NonameModule;