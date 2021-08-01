ALTER TABLE `discord_bot_rpg`.`areasclimates` 
ADD COLUMN `nextWeatherChange` DATETIME NULL DEFAULT NULL AFTER `intensity`;

ALTER TABLE `discord_bot_rpg`.`characters` 
ADD COLUMN `health` INT UNSIGNED NULL DEFAULT NULL AFTER `talentPoints`,
ADD COLUMN `mana` INT UNSIGNED NULL DEFAULT NULL AFTER `health`,
ADD COLUMN `nextPvEAction` DATETIME NULL DEFAULT NULL AFTER `mana`,
ADD COLUMN `nextPvPAction` DATETIME NULL DEFAULT NULL AFTER `nextPveAction`;

ALTER TABLE `discord_bot_rpg`.`users` 
ADD COLUMN `isDoingSomething` TINYINT NOT NULL DEFAULT 0 AFTER `isConnected`;