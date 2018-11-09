'use strict';
class ProgressBar {
    constructor() {
        this.fill = "█";
        this.empty = "░";
    }


    /**
     * Return String : progress bar
     */
    draw(min, max) {
        if (min == 0 && max == 0) {
            max = 1;
        }
        if (min > max) {
            min = max;
        }
        let ratio = min / max;
        ratio = Math.round(ratio * 10);
        return this.fill.repeat(ratio) + this.empty.repeat(10 - ratio);
    }

}

module.exports = ProgressBar;