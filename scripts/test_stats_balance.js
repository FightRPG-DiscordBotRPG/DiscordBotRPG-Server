const Stats = require("../bin/Stats/Stats");

let totalStatsPerSubtypes = {};

for (let stat of Object.values(Stats.possibleStats)) {
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


console.clear();
console.log("Values For Primary Stats\n");

for (let item in totalStatsPerSubtypes) {
    let missingOrNotValue = (totalStatsPerSubtypes[item] - Object.keys(Stats.possibleStats).length).toFixed(2);

    if (missingOrNotValue < 0) {
        console.log("\x1b[32m", `Subtype: ${item} - Missing => ${-missingOrNotValue}`);
    } else if (missingOrNotValue > 0) {
        console.log("\x1b[33m", `Subtype: ${item} - Too much by => ${missingOrNotValue}`);
    } else {
        console.log(`Subtype: ${item} - OK`);
    }

    totalStatsPerSubtypes[item] = -totalStatsPerSubtypes[item].toFixed(2);
}

//console.log(totalStatsPerSubtypes);