const conn = require("../../conf/mysql");




var subtypesDistribution = {
    4: {
        "1": 0.6,
        "3": 0.2,
        "19": 0.2,
    },
    6: {
        "1": 0.8,
        "18": 0.2,
    },
    18: {
        "18": 1
    },
    19: {
        "_19": 0.8,
        "18_": 0.2
    },
    20: {
        "3": 0.8,
        "18": 0.2
    },
    21: {
        "1": 0.5,
        "3": 0.2,
        "19": 0.3,
    },
    22: {
        "3": 1,
    },
    23: {
        "_3": 0.8,
        "1_": 0.2,
    }
}

var rarityDistribution = {
    3: {
        3: 1
    },
    4: {
        4: 1,
        3: 2,
    },
    5: {
        5: 2,
        4: 2,
        3: 3,
    }
}


async function start() {
    let res = await conn.query("SELECT * FROM itemsbase WHERE isInDefaultLootTable = true AND idRarity >= 3;");

    let craftItemsToAdd = [];
    let itemsRequiredToAdd = [];


    let itemAddNumber = 0;
    for (let item of res) {
        if (!subtypesDistribution[item.idSousType]) {
            continue;
        }


        let distri = rarityDistribution[item.idRarity];

        let levels = [1, 40, 60, 80];
        let maxLevels = { 1: 40, 40: 60, 60: 80, 80: 100 };

        for (let level of levels) {
            itemAddNumber++;
            if (itemAddNumber == 21) {
                itemAddNumber = 35;
            }

            //console.log("Level: " + level);
            let res = await conn.query("SELECT * FROM collectableresources INNER JOIN itemsbase USING(idBaseItem) WHERE minLevel = ?", [level]);
            craftItemsToAdd.push(`(${itemAddNumber}, ${maxLevels[level]}, ${level === 1 ? level : level+1}, ${item.idBaseItem}, 0, 0)`);
            let resourcesForThisLevelRange = {};

            for (let resource of res) {
                if (!resourcesForThisLevelRange[resource.idRarity]) {
                    resourcesForThisLevelRange[resource.idRarity] = {};
                }

                if (!resourcesForThisLevelRange[resource.idRarity][resource.idSousType]) {
                    resourcesForThisLevelRange[resource.idRarity][resource.idSousType] = resource;
                }

            }

            let totalToDsitribute = Object.values(distri).reduce((all, a) => all += a);

            let distriLeft = { ...distri };

            let str = "";
            let modIndex = 0;
            for (let toCraftIndex in subtypesDistribution[item.idSousType]) {

                toCraftIndex = parseInt(toCraftIndex.replace("_", ""));

                let mod = subtypesDistribution[item.idSousType][toCraftIndex];

                let totalThisModToDistribute = Math.ceil(mod * totalToDsitribute);


                if (modIndex == Object.keys(subtypesDistribution[item.idSousType]).length) {
                    totalThisModToDistribute = totalToDsitribute;
                }

                totalToDsitribute -= totalThisModToDistribute;

                //console.log(totalThisModToDistribute + " for " + toCraftIndex);




                for (let rarity of Object.keys(distri).sort((a, b) => b - a)) {

                    if (distriLeft[rarity] <= 0 && rarity > 3) {
                        //console.log("Distri left for rarity: " + rarity + " is: " + distriLeft[rarity]);
                        continue;
                    }

                    let toDistri = distri[rarity];

                    //console.log("Before: " + rarity + " is: " + toDistri);

                    //modIndex < Object.keys(subtypesDistribution[item.idSousType]).length



                    if (totalThisModToDistribute - toDistri < 0) {
                        toDistri = totalThisModToDistribute;
                    }

                    //console.log("Number to distri for rarity: " + rarity + " is: " + toDistri);


                    totalThisModToDistribute -= toDistri;
                    distriLeft[rarity] -= toDistri;

                    //console.log(resourcesForThisLevelRange);
                    //console.log(rarity + " " + toCraftIndex);
                    let resource = resourcesForThisLevelRange[rarity][toCraftIndex];
                    str += resource.idBaseItem + "(" + resource.idRarity + " - " + resource.idSousType + ")" + " => " + toDistri + "\n";

                    itemsRequiredToAdd.push(`(${itemAddNumber}, ${resource.idBaseItem}, ${toDistri}, 0)`);



                    if (totalThisModToDistribute <= 0) {
                        break;
                    }


                }




                if (totalToDsitribute <= 0) {
                    //console.log("Total distributed...");
                    break;
                }

                //process.exit();



            }

            //console.log(item.idSousType);
            //console.log(str);

        }

        //console.log("-------------------------------------");

    }

    let addBase = `REPLACE INTO craftitem VALUES\r\n${craftItemsToAdd.join(",\r\n")};`;
    let addRequire = `REPLACE INTO craftitemsneeded\r\nVALUES ${itemsRequiredToAdd.join(",\r\n")};`;

    var fs = require("fs");
    fs.writeFileSync("./testSql.sql", addBase + "\r\n" + addRequire);

    process.exit();

}

start();