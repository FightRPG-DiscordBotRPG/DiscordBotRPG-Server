/**
 * This function will return a copy object with inversed properties
 * exemple: {a: 1; b:1, c:2}
 * will become: {1: ["a", "b"], c: [2]}
 */

module.exports = (object) => {
    let newObject = {};
    for (let i in object) {
        if (newObject[object[i]] == null) {
            newObject[object[i]] = []
        }

        newObject[object[i]].push(i);
    }
    return newObject;
}