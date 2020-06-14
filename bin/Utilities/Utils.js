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
			for (var i = 0; i < k; i++) { // invariant: non-selected at [i,n)
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
		if (n > arr.length) {
			n = arr.length;
		} else if (n < 0) {
			n = 1;
		}
		return this.sample(arr, n, false);
	}

	static getVariance(val, variance) {
		var amp = Math.floor(Math.max(Math.abs(val) * variance / 100, 0));
		var v = Math.randomInt(amp + 1) + Math.randomInt(amp + 1) - amp;
		return val >= 0 ? val + v : val - v;
    }
}


module.exports = Utils