const conn = require("../../conf/mysql");
const AreaClimate = require("../Climate/AreaClimate");

class AreasClusterManager {
    constructor() {
        /**
         * @type {Object<number, AreaClimate>}
         **/
        this.areasWeathers = {};
    }

    async load() {

        const allPromises = [];

        // Handle updates of weather
        const resAreaWeather = await conn.query("SELECT idArea FROM areas");

        for (let area of resAreaWeather) {
            this.areasWeathers[area.idArea] = new AreaClimate(area.idArea);
            allPromises.push(this.areasWeathers[area.idArea].load());
        }

        await Promise.all(allPromises);

    }
}


module.exports = new AreasClusterManager();