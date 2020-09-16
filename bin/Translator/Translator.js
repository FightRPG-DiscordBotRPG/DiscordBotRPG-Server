const fs = require("fs");
const conn = require("../../conf/mysql");
const Intl = require("intl");
const TranslatorConf = require("../../conf/translator");
const axios = require("axios").default;

class Translator {

    /**
     * 
     * @param {String} lang 
     * @param {String} type 
     * @param {String} name 
     * @param {Array} args 
     * @returns {String} Translated String / Or null
     */
    static getString(lang, type, name, args, returnNull = false) {
        if (!this.translations[lang]) {
            lang = "en";
        }
        if (this.translations[lang][type] && this.translations[lang][type][name]) {
            return this.formatString(this.translations[lang][type][name], args, lang);
        }
        if (lang != "en") {
            return this.getString("en", type, name, args, returnNull);
        }

        return returnNull ? null : lang + " | " + type + " | " + name;
    }

    static formatString(s, args = [], lang = "en") {
        let str = "",
            tempStr;
        let argsAlreadyPassed = 0;
        let lastPos = 0;
        for (let i = 0; i < s.length - 1; i++) {
            if (s.charCodeAt(i) === 37) {
                let nc = s.charCodeAt(++i);
                switch (nc) {
                    case 115:
                        tempStr = String(args[argsAlreadyPassed]);
                        break;
                    case 100: {
                        let num = args[argsAlreadyPassed];
                        if (!isNaN(num)) {
                            tempStr = this.getFormater(lang).format(num);
                        } else {
                            tempStr = "NaN";
                        }
                        break;
                    }
                    default:
                        continue;
                }
                if (lastPos !== i - 1) {
                    str += s.slice(lastPos, i - 1);
                }
                str += tempStr;
                lastPos = i + 1;
                argsAlreadyPassed++;
            }
        }
        if (lastPos === 0) {
            str = s;
        } else if (lastPos < s.length) {
            str += s.slice(lastPos);
        }
        return str;
    }

    static loadFormaters() {
        for (let i in this.translations) {
            this.formaters[i] = new Intl.NumberFormat(i);
        }
    }

    /**
     * 
     * @param {string} lang
     * @returns {Intl.NumberFormat}
     */
    static getFormater(lang = "en") {
        return this.formaters[lang];
    }

    /**
     * 
     * @param {String} lang 
     * @returns {boolean}
     */
    static isLangExist(lang) {
        return this.translations[lang] ? true : false
    }

    /**
     * 
     * @param {string} lang 
     * @returns {string} List of available language Localized
     */
    static getAvailableLanguages(lang) {
        let data = {};
        for (let i in this.translations) {
            data[i] = this.getString(lang, "languages", i);
            //+= this.getString(lang, "languages", i) + " (" + i + ")" + (count == this.nbOfTranslations ? "" : ", ");
        }
        return data;
    }

    static async loadFromJson() {
        try {
            var conf = await axios.get(TranslatorConf.cdn_translator_url + 'config.json', { timeout: 2000 });
            conf = conf.data;
        } catch (e) {
            console.log("ERROR WHEN READING CONFIG FILE:\n");
            console.log(e.message + "\n");

            console.log("Unable to read Config File...\nLoading saved translations...");
            if (!fs.existsSync(__dirname + "/locale/")) {
                fs.mkdirSync(__dirname + "/locale");
            }
            let localeList = await fs.readdirSync(__dirname + "/locale/");
            var conf = { published_langs: [] };
            for (let item of localeList) {
                conf.published_langs.push(item.split(".")[0]);
            }
        }

        for (let lang of conf.published_langs) {
            try {
                let res = await axios.get(TranslatorConf.cdn_translator_url + lang + '.json', { timeout: 2000 });
                if (res.status == 200) {
                    this.translations[lang] = res.data;
                    this.nbOfTranslations++;
                    try {
                        fs.writeFileSync(__dirname + "/locale/" + lang + ".json", JSON.stringify(res.data));
                    } catch (e) {
                        console.log(e);
                        console.log("WARNING: Unable to save a backup for the translation file : " + lang + ".json");
                    }
                } else {
                    console.log("Unable to read from CDN the translation file : " + lang + ".json");
                    console.log("Loading from Backup files...");
                    try {
                        this.translations[lang] = JSON.parse(fs.readFileSync(__dirname + "/locale/" + lang + ".json"));
                        this.nbOfTranslations++;
                        console.log("Backup Successfully Loaded !");
                    } catch (e) {
                        console.log("ERROR: Unable to read from backup file for the translation file : " + lang + ".json");
                    }
                }
            } catch (e) {
                console.log("CDN Unavailable for : " + lang + ".json");
                console.log("Loading from Backup files...");
                try {
                    this.translations[lang] = JSON.parse(fs.readFileSync(__dirname + "/locale/" + lang + ".json"));
                    this.nbOfTranslations++;
                    console.log("Backup Successfully Loaded !");
                } catch (e) {
                    console.log("ERROR: Unable to read from backup file for the translation file : " + lang + ".json");
                }
            }
        }
    }

    static async loadItemsBases() {
        let res = await conn.query("SELECT * FROM localizationitems");
        let languages = await conn.query("SELECT * FROM languages");
        for (let language of languages) {
            this.translations[language.lang]["itemsNames"] = {};
            this.translations[language.lang]["itemsDesc"] = {};
        }

        for (let trad of res) {
            this.translations[trad.lang]["itemsNames"][trad.idBaseItem] = trad.nameItem;
            this.translations[trad.lang]["itemsDesc"][trad.idBaseItem] = trad.descItem != "" ? trad.descItem : null;
        }
    }

    static async loadBosses() {
        let res = await conn.query("SELECT * FROM localizationbosses");
        let languages = await conn.query("SELECT * FROM languages");
        for (let language of languages) {
            this.translations[language.lang]["bossesNames"] = {};
        }

        for (let trad of res) {
            this.translations[trad.lang]["bossesNames"][trad.idBoss] = trad.nameBoss;
        }
    }

    static async loadAreasBases() {
        let res = await conn.query("SELECT * FROM localizationareas");
        let languages = await conn.query("SELECT * FROM languages");
        for (let language of languages) {
            this.translations[language.lang]["areasNames"] = {};
            this.translations[language.lang]["areasDesc"] = {};
        }
        for (let trad of res) {
            this.translations[trad.lang]["areasNames"][trad.idArea] = trad.nameArea;
            this.translations[trad.lang]["areasDesc"][trad.idArea] = trad.descArea != "" ? trad.descArea : null;
        }
    }

    static async loadRegionsBases() {
        let res = await conn.query("SELECT * FROM localizationregions");
        let languages = await conn.query("SELECT * FROM languages");
        for (let language of languages) {
            this.translations[language.lang]["regionsNames"] = {};
            this.translations[language.lang]["regionsImages"] = {};
        }
        for (let trad of res) {
            this.translations[trad.lang]["regionsNames"][trad.idRegion] = trad.nameRegion;
            this.translations[trad.lang]["regionsImages"][trad.idRegion] = trad.imageRegion;
        }
    }

    static async loadMonstersBases() {
        let res = await conn.query("SELECT * FROM localizationmonsters");
        let languages = await conn.query("SELECT * FROM languages");
        for (let language of languages) {
            this.translations[language.lang]["monstersNames"] = {};
        }
        for (let trad of res) {
            this.translations[trad.lang]["monstersNames"][trad.idMonstre] = trad.nameMonster;
        }
    }

    static async loadSkillBases() {
        let res = await conn.query("SELECT * FROM localizationskills");
        let languages = await conn.query("SELECT * FROM languages");
        for (let language of languages) {
            this.translations[language.lang]["skillNames"] = {};
            this.translations[language.lang]["skillDesc"] = {};
            this.translations[language.lang]["skillMessages"] = {};
        }

        for (let trad of res) {
            this.translations[trad.lang]["skillNames"][trad.idSkill] = trad.nameSkill;
            this.translations[trad.lang]["skillDesc"][trad.idSkill] = trad.nameSkill;
            this.translations[trad.lang]["skillMessages"][trad.idSkill] = trad.messageSkill.trimLeft();
        }
    }

    static async loadStatesBases() {
        let res = await conn.query("SELECT * FROM localizationstates");
        let languages = await conn.query("SELECT * FROM languages");
        for (let language of languages) {
            this.translations[language.lang]["statesNames"] = {};
            this.translations[language.lang]["stateDesc"] = {};
        }

        for (let trad of res) {
            this.translations[trad.lang]["statesNames"][trad.idState] = trad.nameState;
            this.translations[trad.lang]["stateDesc"][trad.idState] = trad.descState;
        }
    }

    // IDEA: Use Promise.all ?
    static async load() {
        this.translations = {};
        this.formaters = {};
        this.nbOfTranslations = 0;
        await this.loadFromJson();
        this.loadFormaters();
        await this.loadItemsBases();
        await this.loadAreasBases();
        await this.loadRegionsBases();
        await this.loadMonstersBases();
        await this.loadBosses();
        await this.loadSkillBases();
        await this.loadStatesBases();
    }
}



/*
var sizeof = require('object-sizeof');
console.log(sizeof(Translator.translations));*/

module.exports = Translator;