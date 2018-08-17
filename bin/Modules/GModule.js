class GModule {
    constructor() {
        this.isReloadable = true;
        this.loadingTime = 0;
        this.isModule = true;
        this.isLoaded = false;
        this.isActive = true;
        this.commands = [];
    }

    async run() {
    }

    init() {
        
    }

    startLoading(name="Generic Module") {
        this.loadingTime = Date.now();
        console.log("Loading module : " + name);
    }

    endLoading(name="Generic Module") {
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
        let r = -1;
        switch (string) {
            case "weapon":
                r = 1;
                break;
            case "chest":
                r = 2;
                break;
            case "legs":
                r = 3;
                break;
            case "head":
                r = 4;
                break;
        }
        return r;
    }

}



module.exports = GModule;