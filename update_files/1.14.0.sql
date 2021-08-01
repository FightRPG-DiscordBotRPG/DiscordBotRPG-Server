ALTER TABLE `discord_bot_rpg`.`areasclimates` 
ADD COLUMN `nextWeatherChange` DATETIME NULL DEFAULT NULL AFTER `intensity`;

ALTER TABLE `discord_bot_rpg`.`characters` 
ADD COLUMN `health` INT UNSIGNED NULL DEFAULT NULL AFTER `talentPoints`,
ADD COLUMN `mana` INT UNSIGNED NULL DEFAULT NULL AFTER `health`,
ADD COLUMN `nextPvEAction` DATETIME NULL DEFAULT NULL AFTER `mana`,
ADD COLUMN `nextPvPAction` DATETIME NULL DEFAULT NULL AFTER `nextPveAction`;

ALTER TABLE `discord_bot_rpg`.`users` 
ADD COLUMN `isDoingSomething` TINYINT NOT NULL DEFAULT 0 AFTER `isConnected`;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`groupsdata` (
  `idUserLeader` VARCHAR(20) NOT NULL,
  `isDoingSomething` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`idUserLeader`),
  CONSTRAINT `fk_Groups_Users1`
    FOREIGN KEY (`idUserLeader`)
    REFERENCES `discord_bot_rpg`.`users` (`idUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`groupsplayers` (
  `idUserLeader` VARCHAR(20) NOT NULL,
  `idUser` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`idUserLeader`, `idUser`),
  INDEX `fk_GroupsCharacters_Users1_idx` (`idUser` ASC) VISIBLE,
  CONSTRAINT `fk_GroupsCharacters_Groups1`
    FOREIGN KEY (`idUserLeader`)
    REFERENCES `discord_bot_rpg`.`groupsdata` (`idUserLeader`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_GroupsCharacters_Users1`
    FOREIGN KEY (`idUser`)
    REFERENCES `discord_bot_rpg`.`users` (`idUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`groupspendingplayers` (
  `idUserLeader` VARCHAR(20) NOT NULL,
  `idUser` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`idUserLeader`, `idUser`),
  INDEX `fk_GroupsPendingPlayers_Users1_idx` (`idUser` ASC) VISIBLE,
  CONSTRAINT `fk_GroupsPendingPlayers_Groups1`
    FOREIGN KEY (`idUserLeader`)
    REFERENCES `discord_bot_rpg`.`groupsdata` (`idUserLeader`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_GroupsPendingPlayers_Users1`
    FOREIGN KEY (`idUser`)
    REFERENCES `discord_bot_rpg`.`users` (`idUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;