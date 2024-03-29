//const Utils = require("../bin/Utilities/Utils");

//console.time("Time");
//let repartition = {};
//for (let i = 0; i < 10000; i++) {
//    let result = Utils.getWeightedRandomItemsInArray(["a", "b", "c", "d"], [1, 1, 1, 1], 5)[0];

//    if (repartition[result] == null) {
//        repartition[result] = 0;
//    }

//    repartition[result]++;
//}
//console.timeEnd("Time");
//console.log(repartition);

//let obj = { 1: 1, 2: true, 4: true, 56: false, 99: 6666, 79: "tryue" };
//let obj = {};

//for (let i = 0; i < 1000; i++) {
//    obj[i] = Math.random() * 10000;
//}


//const testMax = 10000;
//console.time("Object Keys");
//for (let i = 0; i < testMax; i++) {
//    Object.keys(obj);
//}
//console.timeEnd("Object Keys");

//console.time("Object Entries");
//for (let i = 0; i < testMax; i++) {
//    Object.entries(obj);
//}
//console.timeEnd("Object Entries");

//console.time("Object Values");
//for (let i = 0; i < testMax; i++) {
//    Object.values(obj);
//}
//console.timeEnd("Object Values");

//console.time("Object For In")
//for (let i = 0; i < testMax; i++) {
//    //let arr = [];
//    for (let o in obj) {
//        //arr.push(i);
//    }
//}
//console.timeEnd("Object For In")

//console.time("Object For I In Keys")
//for (let i = 0; i < testMax; i++) {
//    for (let o in Object.keys(obj)) {
//        //
//    }
//}
//console.timeEnd("Object For I In Keys")

console.time("Spread");
let firstObject = { sampleData: 'Hello world' }
let secondObject = { moreData: 'foo bar' }
let finalObject = {
    ...firstObject,
    ...secondObject
};
console.timeEnd("Spread");
console.log(finalObject);


console.time("Assign");
firstObject = { sampleData: 'Hello world' }
secondObject = { moreData: 'foo bar' }
finalObject = Object.assign(firstObject, secondObject);
console.timeEnd("Assign");
console.log(finalObject);


