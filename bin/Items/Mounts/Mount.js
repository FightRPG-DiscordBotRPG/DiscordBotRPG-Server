const Item = require("../Item");
const Translator = require("../../Translator/Translator");
const InverseObjectProperties = require("../../Utilities/InverseObjectProperties");

class Mount extends Item {
    constructor(id) {
        super(id);

        /**
         * Reduction is a percentage that we take off the travel time for a specific climate
         * 0.1 means 10% faster, at 0.5 it means it's 50% faster to travel ->
         * This don't take into account climate modifiers that change the base travel time due to bonus/penalties
         * based on the mount type
         */
        this.reductionPerRarity = 0.1;
        /**
         * The climate modifer define the bonus/penalty when traveling a time of area
         * Higher than one means is slower
         * Lower than one means is faster
         */
        this.climateModifiers = {
            "temperate_oceanic": 0,
            "volcanic_hell": 0,
            "hot_desert": 0,
            "eternal_snow": 0,
        }
    }

    getTravelReductionModifier(climate) {
        /**
         * If climate is not referenced we still use 1 as a base (so we can still have a reduction even if the climate
         * is not already implemented for a specific area)
         * The reduction should always be 0.1 minimum, since 0 means instant travel, i don't want players to teleport
         */
        let reduction;
        if (climate != null && this.climateModifiers[climate] != null) {
            reduction = 1 - (this.climateModifiers[climate] * this.getFlatModifer());
        } else {
            reduction = 1;
        }
        return reduction < 0.1 ? 0.1 : reduction.toFixed(2);
    }

    getFlatModifer() {
        return this.reductionPerRarity * this.getIdRarity() + (this.getIdRarity() > 4 ? this.reductionPerRarity * (this.getIdRarity() - 4) : 0);
    }

    /**
     * 
     * @param {*} climate 
     * Should be used to get a human readable reduction percentage for a specific climate (ex: return 50% if the mount for this climate
     * reduce the time by 50%, could be negative percentage meaning it's a penalty)
     * The base is 1 because the displayed travel time on maps is fixed (the map is not updated depending of the mount), so to avoid any
     * confusion we base our reduction based on this
     */
    getClimateReduction(climate) {
        return (1 - this.getTravelReductionModifier(climate)) * 100;
    }

    getDesc(lang = "en") {
        let desc = super.getDesc(lang);


        /**
         * We will need to find if all climate is the same so we can display one sentence for all reductions
         * One pass through the object is faster than loading a sentence for every areas and then test this
         */
        let isAllClimateModifiersTheSame = true;
        let last = null;

        /**
         * This will be used in the second part to get the reduction from one climate (without me doing anything)
         * if all climate modifiers is the same
         * And so i'm avoiding the "1 is base" when calling getClimateReduction()
         */
        let lastClimateName = null;

        for (let i in this.climateModifiers) {
            if (last != null) {
                if (last != this.climateModifiers[i]) {
                    isAllClimateModifiersTheSame = false;
                    break;
                }
                lastClimateName = i;
            } else {
                last = this.climateModifiers[i];
            }
        }

        // First desc part
        desc += "\n\n" + Translator.getString(lang, "mounts", "reduction") + "\n";


        if (isAllClimateModifiersTheSame == false) {
            let inversedPropertiesObject = InverseObjectProperties(this.climateModifiers);
            let everythingElseID;

            // Reusing last variable
            let highest = 0;

            for (let i in inversedPropertiesObject) {
                if (inversedPropertiesObject[i].length > highest) {
                    highest = inversedPropertiesObject[i].length;
                    everythingElseID = i;
                }
            }

            for (let i in inversedPropertiesObject) {
                if (i != everythingElseID) {
                    for (let climate of inversedPropertiesObject[i]) {
                        desc += " • " + Translator.getString(lang, "climates", climate) + ": " +  Translator.getFormater(lang).format(this.getClimateReduction(climate)) + "%\n";
                    }
                }
            }

            let lastClimateEverythingElse = inversedPropertiesObject[everythingElseID][0];
            desc += " • " + Translator.getString(lang, "mounts", "everything_else", [this.getClimateReduction(lastClimateEverythingElse)]) + "\n";

        } else {
            desc += " • " + Translator.getString(lang, "mounts", "all_areas", [this.getClimateReduction(lastClimateName)]);
        }

        return desc;
    }
}

module.exports = Mount;