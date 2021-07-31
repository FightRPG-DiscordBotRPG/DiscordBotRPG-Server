const conn = require("../../conf/mysql");
const Weather = require("./Weather");
const Climate = require("./Climate");
const Globals = require("../Globals");
const moment = require("moment");
const cluster = require("cluster");

class AreaClimate {
    constructor(id) {
        this.id = id;
        /**
        * @type {Climate}
        */
        this.climate = null;
        /**
        * @type {Weather}
        */
        this.currentWeather = null;
        this.intensity = 1;
        this.dateNextWeatherChange = moment();
    }

    async load() {
        const res = (await conn.query("SELECT * FROM areasclimates WHERE idArea = ?;", [this.id]))[0];
        this.climate = new Climate(res.idClimate);
        this.currentWeather = new Weather(res.currentWeather);
        this.intensity = res.intensity / 100;
        this.dateNextWeatherChange = moment(res.nextWeatherChange);
            
        await Promise.all([this.climate.load(), this.currentWeather.load()]);
        if (cluster.isMaster) {
            // On master (if activated) calculate next next weather
            this.changeWeather();
        } else {
            // On non master load time idff
            setTimeout(() => this.load(), this.dateNextWeatherChange.diff(moment()) + 10000);
        }
    }

    async changeWeather() {
        this.currentWeather = this.climate.getRandomWeather();
        await conn.query("UPDATE areasclimates SET currentWeather = ? WHERE idArea = ?;", [this.currentWeather.id, this.id]);
        await this.scheduleNextWeatherChange();
    }

    async scheduleNextWeatherChange() {
        let delay = (Math.random() * (Globals.weather.maxBeforeChange - Globals.weather.minBeforeChange) + Globals.weather.minBeforeChange) * 60000;
        this.dateNextWeatherChange = moment().add(delay, "millisecond");
        await conn.query("UPDATE areasclimates SET nextWeatherChange = ? WHERE idArea = ?;", [this.dateNextWeatherChange.format('YYYY/MM/DD HH:mm:ss'), this.id]);
        setTimeout(() => this.changeWeather(), delay);
    }

}

module.exports = AreaClimate;