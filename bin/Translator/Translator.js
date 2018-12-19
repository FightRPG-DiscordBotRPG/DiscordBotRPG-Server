const fs = require("fs");
const conn = require("../../conf/mysql");
const Intl = require("intl");

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

    static formatString(s, args, lang = "en") {
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
                    case 100:
                        let num = args[argsAlreadyPassed];
                        if (!isNaN(num)) {
                            tempStr = this.getFormater(lang).format(num);
                        } else {
                            tempStr = "NaN";
                        }
                        break;
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

    static load(callback) {
        var self = this;
        fs.readdir(__dirname + "/locale", (err, filenames) => {
            if (!err) {
                for (let i of filenames) {
                    self.translations[i.split(".")[0]] = JSON.parse(fs.readFileSync(__dirname + "/locale/" + i));
                    self.nbOfTranslations++;
                }
                callback ? callback() : null;
            }
        })
    }

    static loadSync() {
        var filenames = fs.readdirSync(__dirname + "/locale");
        for (let i of filenames) {
            this.translations[i.split(".")[0]] = JSON.parse(fs.readFileSync(__dirname + "/locale/" + i));
            this.nbOfTranslations++;
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

    static async load() {
        this.translations = {};
        this.formaters = {};
        this.nbOfTranslations = 0;
        this.loadSync();
        this.loadFormaters();
        await this.loadItemsBases();
        await this.loadAreasBases();
        await this.loadRegionsBases();
        await this.loadMonstersBases();
        await this.loadBosses();
    }
}



/*
var sizeof = require('object-sizeof');
console.log(sizeof(Translator.translations));*/

module.exports = Translator;