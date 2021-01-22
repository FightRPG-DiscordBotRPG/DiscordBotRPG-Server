const conn = require("../conf/mysql");
const Item = require("../bin/Items/Item");
const Globals = require("../bin/Globals");

async function start() {

    console.time("reforge");
    await Globals.loadGlobals();


    let res = await conn.query("SELECT * FROM items INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem WHERE itemsbase.idRarity = 6");

    let promises = [];
    for (let item of res) {
        promises.push(reforgeItem(item.idItem));
    }

    await Promise.all(promises);
    console.timeEnd("reforge");
    process.exit();
}

async function reforgeItem(idItem) {
    let item = await Item.newItem(idItem, "");
    await item.reforge();
}


start();