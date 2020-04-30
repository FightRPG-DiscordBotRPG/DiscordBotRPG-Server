const Area = require("./Area");
const Translator = require("../Translator/Translator");

class Region {
    constructor(id) {
        this.id = id;
        /**
         * @type {Map<number, Area>}
         */
        this.areas = new Map();
        this.areaIncrementIndex = 1;
        /**
         * @type {Map<number, Area>}
         */
        this.connectedAreas = new Map();
        this.connectedAreasIncrementIndex = 1;
    }

    static staticGetName(id, lang = "en") {
        return Translator.getString(lang, "regionsNames", id);
    }

    getName(lang = "en") {
        return Translator.getString(lang, "regionsNames", this.id);
    }

    getImage(lang = "en") {
        return Translator.getString(lang, "regionsImages", this.id);
    }

    getArea(index) {
        return this.areas.get(index);
    }

    getConnectedArea(index) {
        return this.connectedAreas.get(index);
    }

    /**
     * 
     * @param {Area} area 
     */
    addArea(area) {
        this.areas.set(this.areaIncrementIndex, area);
        this.areaIncrementIndex++;
    }

    addConnectedArea(area) {
        this.connectedAreas.set(this.connectedAreasIncrementIndex, area);
        this.connectedAreasIncrementIndex++;
    }

    exist(index) {
        return this.areas.get(index) != null;
    }

    isConnected(index) {
        return this.connectedAreas.get(index) != null;
    }

    async toApi(lang) {
        let areas = [];
        for (let [key, value] of this.areas) {
            if (await this.areas.get(key).canTravelTo()) {
                areas.push({
                    id: key,
                    name: this.areas.get(key).getName(lang),
                    levels: this.areas.get(key).minMaxLevelToString(),
                    type: this.areas.get(key).areaType,
                });
            }
        }

        let connectedAreas = [];
        for (let [key, value] of this.connectedAreas) {
            if (await this.connectedAreas.get(key).canTravelTo()) {
                connectedAreas.push({
                    id: key,
                    name: this.connectedAreas.get(key).getName(lang),
                    levels: this.connectedAreas.get(key).minMaxLevelToString(),
                    region_name: Region.staticGetName(this.connectedAreas.get(key).idRegion, lang),
                    type: this.connectedAreas.get(key).areaType
                });
            }
        }

        return {
            name: this.getName(lang),
            image: this.getImage(lang),
            areas: areas,
            connectedAreas: connectedAreas,
        }
    }

}

module.exports = Region;