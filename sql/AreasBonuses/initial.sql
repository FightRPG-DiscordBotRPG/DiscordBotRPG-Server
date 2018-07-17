
-- MySQL Workbench Synchronization
-- Generated: 2018-07-16 15:57
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

ALTER TABLE `discord_bot_rpg`.`areas` 
ADD COLUMN `AreaLevel` INT(10) UNSIGNED NOT NULL AFTER `idAreaType`,
ADD INDEX `fk_Areas_AreasLevels1_idx` (`AreaLevel` ASC);

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`bonustypes` (
  `idBonusTypes` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`idBonusTypes`),
  UNIQUE INDEX `idbonusTypes_UNIQUE` (`idBonusTypes` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`areasbonuses` (
  `idArea` INT(10) UNSIGNED NOT NULL,
  `idBonusTypes` INT(10) UNSIGNED NOT NULL,
  `value` INT(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`idArea`, `idBonusTypes`),
  INDEX `fk_AreasBonuses_BonusTypes1_idx` (`idBonusTypes` ASC),
  CONSTRAINT `fk_AreasBonuses_Areas1`
    FOREIGN KEY (`idArea`)
    REFERENCES `discord_bot_rpg`.`areas` (`idArea`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_AreasBonuses_BonusTypes1`
    FOREIGN KEY (`idBonusTypes`)
    REFERENCES `discord_bot_rpg`.`bonustypes` (`idBonusTypes`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`areaslevels` (
  `idAreaLevel` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `price` BIGINT(19) UNSIGNED NOT NULL DEFAULT 1000000,
  PRIMARY KEY (`idAreaLevel`),
  UNIQUE INDEX `idAreaLevel_UNIQUE` (`idAreaLevel` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

ALTER TABLE `discord_bot_rpg`.`areas` 
ADD CONSTRAINT `fk_Areas_AreasLevels1`
  FOREIGN KEY (`AreaLevel`)
  REFERENCES `discord_bot_rpg`.`areaslevels` (`idAreaLevel`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;


ALTER TABLE `discord_bot_rpg`.`areas` 
ADD COLUMN `statPoints` INT(10) UNSIGNED NOT NULL DEFAULT 5 AFTER `AreaLevel`;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

INSERT INTO `bonustypes` (`idBonusTypes`, `nom`) VALUES (NULL, 'xp_fight'), (NULL, 'xp_collect'), (NULL, 'xp_craft'), (NULL, 'gold_drop'), (NULL, 'item_drop'), (NULL, 'collect_drop');
INSERT INTO `areaslevels` (`idAreaLevel`, `price`) VALUES (NULL, '250000'), (NULL, '500000'), (NULL, '300000'), (NULL, '10000000');
UPDATE areas SET AreaLevel = 1