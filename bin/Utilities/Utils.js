Math.randomInt = function (max) {
    return Math.floor(max * Math.random())
}

class Utils {

    static randRangeInt(min, max) {
        min = Math.ceil(min);
        max = Math.floor(max);
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }

    static randRangeFloat(min, max) {
        return Math.random() * (max - min) + min;
    }

	/**
	 * 
	 * @param {Array} pool
	 * @param {number} k
	 * @param {boolean} destructive
	 * @returns {Array}
	 */
    static sample(pool, k, destructive) {
        var n = pool.length;

        if (k < 0 || k > n)
            throw new RangeError("Sample larger than population or is negative");

        if (destructive || n <= (k <= 5 ? 21 : 21 + Math.pow(4, Math.ceil(Math.log(k * 3, 4))))) {
            if (!destructive)
                pool = Array.prototype.slice.call(pool);
            for (let i = 0; i < k; i++) { // invariant: non-selected at [i,n)
                var j = i + Math.random() * (n - i) | 0;
                var x = pool[i];
                pool[i] = pool[j];
                pool[j] = x;
            }
            pool.length = k; // truncate
            return pool;
        } else {
            var selected = new Set();
            while (selected.add(Math.random() * n | 0).size < k) { }
            return Array.prototype.map.call(selected, i => population[i]);
        }
    }

	/**
	 * 
	 * @param {Array} arr
	 * @param {number} n
	 */
    static getRandomItemsInArray(arr, n) {
        return this.sample(arr, Utils.getProtectedNValue(arr, n), false);
    }

    static getVariance(val, variance) {
        var amp = Math.floor(Math.max(Math.abs(val) * variance / 100, 0));
        var v = Math.randomInt(amp + 1) + Math.randomInt(amp + 1) - amp;
        return val >= 0 ? val + v : val - v;
    }

    static getWeightedRandomItemsInArray(items, arrWeight, n) {

        let itemsNonDestructive = [...items];

        let itemsToReturn = [];

        n = this.getProtectedNValue(items, n);

        for (let i = 0; i < n; i++) {
            let weightTotal = 0;
            let distrib = [];

            for (let j = 0; j < itemsNonDestructive.length; j++) {
                weightTotal += arrWeight[j];
            }


            for (let j = 0; j < itemsNonDestructive.length; j++) {
                distrib[j] = arrWeight[j] / weightTotal;
            }

            let key = 0;
            let selector = Math.random();
            while (selector > 0) {
                selector -= distrib[key];
                key++;
            }

            key--;

            itemsToReturn.push(itemsNonDestructive[key]);


            itemsNonDestructive.splice(key, 1);

        }

        return itemsToReturn;

    }

    /**
    *
    * @param {Array} arr
    * @param {number} n
    */
    static getProtectedNValue(arr, n) {
        if (n > arr.length) {
            return arr.length;
        } else if (n < 0) {
            return 1;
        }
        return n;
    }

    /**
     * 
     * @param {any[]} arr
     * @param {any} itemToSwap
     * @param {number} indexMoveTo
     * Returns if successful
     */
    static swapArrayItemToIndex(arr, itemToSwap, indexMoveTo) {
        let indexOfSwap = arr.indexOf(itemToSwap);

        if (indexOfSwap > -1) {
            if (indexMoveTo >= arr.length && indexMoveTo >= 0) {
                indexMoveTo -= 1;
            } else if (indexMoveTo < 0) {
                indexMoveTo = 0;
            }
            [arr[indexMoveTo], arr[indexOfSwap]] = [arr[indexOfSwap], arr[indexMoveTo]];
            return true;
        }

        return false;
    }

    /**
     * 
     * @param {any[]} arr
     * @param {any} item
     */
    static removeItemFromArray(arr, item) {
        for (var i = 0; i < arr.length; i++) {
            if (arr[i] === item) {
                arr.splice(i, 1);
                return true;
            }
        }
        return false;
    }
}


module.exports = Utils