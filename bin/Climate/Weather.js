const conn = require("../../conf/mysql");

class Weather {
    constructor(id) {
        this.id = id;
        this.shorthand = "";
        this.travelSpeed = 1;
        this.collectSpeed = 1;
        this.collectChances = 1;
    }

    async load() {
        const res = (await conn.query("SELECT * FROM weathers WHERE idWeather = ?;", [this.id]))[0];

        this.shorthand = res.shorthand;
        this.travelSpeed = res.travelSpeed / 100;
        this.collectSpeed = res.collectSpeed / 100;
        this.collectChances = res.collectChances / 100;

    }
}


module.exports = Weather;