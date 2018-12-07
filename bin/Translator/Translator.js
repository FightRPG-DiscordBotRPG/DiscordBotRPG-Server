const fs = require("fs");
const util = require("util");
const conn = require("../../conf/mysql");

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

            args = Array.isArray(args) ? args : [];
            args.unshift(this.translations[lang][type][name]);
            return util.format.apply(util, args);
        }
        if (lang != "en") {
            return this.getString("en", type, name, args, returnNull);
        }

        return returnNull ? null : lang + " | " + type + " | " + name;
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

    static loadItemsBases() {
        let res = conn.query("SELECT * FROM localizationitems");
        let languages = conn.query("SELECT * FROM languages");
        for (let language of languages) {
            this.translations[language.lang]["itemsNames"] = {};
            this.translations[language.lang]["itemsDesc"] = {};
        }

        for (let trad of res) {
            this.translations[trad.lang]["itemsNames"][trad.idBaseItem] = trad.nameItem;
            this.translations[trad.lang]["itemsDesc"][trad.idBaseItem] = trad.descItem != "" ? trad.descItem : null;
        }
    }

    static loadBosses() {
        let res = conn.query("SELECT * FROM localizationbosses");
        let languages = conn.query("SELECT * FROM languages");
        for (let language of languages) {
            this.translations[language.lang]["bossesNames"] = {};
        }

        for (let trad of res) {
            this.translations[trad.lang]["bossesNames"][trad.idBoss] = trad.nameBoss;
        }
    }

    static loadAreasBases() {
        let res = conn.query("SELECT * FROM localizationareas");
        let languages = conn.query("SELECT * FROM languages");
        for (let language of languages) {
            this.translations[language.lang]["areasNames"] = {};
            this.translations[language.lang]["areasDesc"] = {};
        }
        for (let trad of res) {
            this.translations[trad.lang]["areasNames"][trad.idArea] = trad.nameArea;
            this.translations[trad.lang]["areasDesc"][trad.idArea] = trad.descArea != "" ? trad.descArea : null;
        }
    }

    static loadRegionsBases() {
        let res = conn.query("SELECT * FROM localizationregions");
        let languages = conn.query("SELECT * FROM languages");
        for (let language of languages) {
            this.translations[language.lang]["regionsNames"] = {};
            this.translations[language.lang]["regionsImages"] = {};
        }
        for (let trad of res) {
            this.translations[trad.lang]["regionsNames"][trad.idRegion] = trad.nameRegion;
            this.translations[trad.lang]["regionsImages"][trad.idRegion] = trad.imageRegion;
        }
    }

    static loadMonstersBases() {
        let res = conn.query("SELECT * FROM localizationmonsters");
        let languages = conn.query("SELECT * FROM languages");
        for (let language of languages) {
            this.translations[language.lang]["monstersNames"] = {};
        }
        for (let trad of res) {
            this.translations[trad.lang]["monstersNames"][trad.idMonstre] = trad.nameMonster;
        }
    }
}

Translator.translations = {};
Translator.nbOfTranslations = 0;
Translator.loadSync();
Translator.loadItemsBases();
Translator.loadAreasBases();
Translator.loadRegionsBases();
Translator.loadMonstersBases();
Translator.loadBosses();

/*
var sizeof = require('object-sizeof');
console.log(sizeof(Translator.translations));*/

module.exports = Translator;