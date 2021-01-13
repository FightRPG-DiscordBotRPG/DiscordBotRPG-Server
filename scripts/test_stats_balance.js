const Stats = require("../bin/Stats/Stats");
const SecondaryStats = require("../bin/Stats/Secondary/SecondaryStats");

let totalStatsPerSubtypes = {};
let totalSecondaryStatsPerSubtypes = {};

let possiblePrimaryStats = Object.values(Stats.possibleStats);
let possibleSecondaryStats = [...Object.values(SecondaryStats.possibleStats), ...Object.values(SecondaryStats.possibleElementalResists)]

for (let stat of possiblePrimaryStats) {
    for (let subtype of Object.keys(Stats.ratiosBasedOnSubtype[stat])) {

        if (totalStatsPerSubtypes[subtype] == null) {
            totalStatsPerSubtypes[subtype] = 0;
        }

        if (stat === "armor" && !["metal", "cloth", "leather"].includes(subtype)) {
            totalStatsPerSubtypes[subtype] += 1;
        } else {
            totalStatsPerSubtypes[subtype] += Stats.ratiosBasedOnSubtype[stat][subtype];
        }


    }
}

for (let secondaryStat of possibleSecondaryStats) {
    for (let subtype of Object.keys(SecondaryStats.ratiosBasedOnSubtype[secondaryStat])) {

        if (totalSecondaryStatsPerSubtypes[subtype] == null) {
            totalSecondaryStatsPerSubtypes[subtype] = 0;
        }

        totalSecondaryStatsPerSubtypes[subtype] += SecondaryStats.ratiosBasedOnSubtype[secondaryStat][subtype];

    }
}

/**
 * 
 * @param {{}} stats
 * @param {Array<string>} possibleStats
 */
function TestStats(stats, possibleStats) {
    for (let item in stats) {
        let missingOrNotValue = (stats[item] - possibleStats.length).toFixed(2);

        if (missingOrNotValue < 0) {
            console.log("\x1b[31m", `Subtype: ${item} - Missing => ${-missingOrNotValue}`);
        } else if (missingOrNotValue > 0) {
            console.log("\x1b[33m", `Subtype: ${item} - Too much by => ${missingOrNotValue}`);
        } else {
            console.log("\x1b[37m", `Subtype: ${item} - OK`);
        }

        stats[item] = -stats[item].toFixed(2);
    }
}

console.clear();
console.log("Values For Primary Stats\n");

TestStats(totalStatsPerSubtypes, possiblePrimaryStats);

console.log("\nValues For Secondary Stats\n");

TestStats(totalSecondaryStatsPerSubtypes, possibleSecondaryStats);

console.log("\x1b[0m");




//console.log(totalStatsPerSubtypes);