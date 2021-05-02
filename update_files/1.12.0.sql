-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema discord_bot_rpg
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema discord_bot_rpg
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `discord_bot_rpg` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci ;
USE `discord_bot_rpg` ;

-- -----------------------------------------------------
-- Table `discord_bot_rpg`.`EventsTypes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `discord_bot_rpg`.`eventstypes` ;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`eventstypes` (
  `idEventType` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idEventType`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `discord_bot_rpg`.`Events`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `discord_bot_rpg`.`events` ;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`events` (
  `idEvent` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idEventType` INT UNSIGNED NOT NULL,
  `backgroundImage` TEXT NOT NULL,
  `iconImage` TEXT NOT NULL,
  `occurence` BIGINT UNSIGNED NOT NULL DEFAULT 86400,
  `length` BIGINT UNSIGNED NOT NULL DEFAULT 43200,
  `startDate` DATETIME NOT NULL,
  `endDate` DATETIME,
  PRIMARY KEY (`idEvent`),
  INDEX `fk_Events_EventsTypes1_idx` (`idEventType` ASC) VISIBLE,
  CONSTRAINT `fk_Events_EventsTypes1`
    FOREIGN KEY (`idEventType`)
    REFERENCES `discord_bot_rpg`.`eventstypes` (`idEventType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `discord_bot_rpg`.`EventsGlobalModifiers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `discord_bot_rpg`.`eventsglobalmodifiers` ;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`eventsglobalmodifiers` (
  `idEvent` INT UNSIGNED NOT NULL,
  `idBonusTypes` INT UNSIGNED NOT NULL,
  `value` INT NOT NULL,
  PRIMARY KEY (`idEvent`, `idBonusTypes`),
  INDEX `fk_EventsBonuses_BonusTypes1_idx` (`idBonusTypes` ASC) VISIBLE,
  CONSTRAINT `fk_EventsBonuses_Events1`
    FOREIGN KEY (`idEvent`)
    REFERENCES `discord_bot_rpg`.`events` (`idEvent`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_EventsBonuses_BonusTypes1`
    FOREIGN KEY (`idBonusTypes`)
    REFERENCES `discord_bot_rpg`.`bonustypes` (`idBonusTypes`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `discord_bot_rpg`.`EventSpecificDrops`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `discord_bot_rpg`.`eventspecificdrops` ;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`eventspecificdrops` (
  `idEvent` INT UNSIGNED NOT NULL,
  `idBaseItem` INT UNSIGNED NOT NULL,
  `percentage` FLOAT UNSIGNED NOT NULL,
  `min` INT UNSIGNED NOT NULL,
  `max` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idEvent`, `idBaseItem`),
  INDEX `fk_EventSpecificDrops_ItemsBase1_idx` (`idBaseItem` ASC) VISIBLE,
  CONSTRAINT `fk_EventSpecificDrops_Events1`
    FOREIGN KEY (`idEvent`)
    REFERENCES `discord_bot_rpg`.`events` (`idEvent`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_EventSpecificDrops_ItemsBase1`
    FOREIGN KEY (`idBaseItem`)
    REFERENCES `discord_bot_rpg`.`itemsbase` (`idBaseItem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `discord_bot_rpg`.`EventsAreasTypesDrops`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `discord_bot_rpg`.`eventsareastypesdrops` ;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`eventsareastypesdrops` (
  `idAreaType` INT UNSIGNED NOT NULL,
  `idEvent` INT UNSIGNED NOT NULL,
  `idBaseItem` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idAreaType`, `idEvent`, `idBaseItem`),
  INDEX `fk_EventsAreasTypesDrops_EventSpecificDrops1_idx` (`idEvent` ASC, `idBaseItem` ASC) VISIBLE,
  CONSTRAINT `fk_EventsAreasTypesDrops_AreasTypes1`
    FOREIGN KEY (`idAreaType`)
    REFERENCES `discord_bot_rpg`.`areastypes` (`idAreaType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_EventsAreasTypesDrops_EventSpecificDrops1`
    FOREIGN KEY (`idEvent` , `idBaseItem`)
    REFERENCES `discord_bot_rpg`.`eventspecificdrops` (`idEvent` , `idBaseItem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `discord_bot_rpg`.`EventsAreasDrops`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `discord_bot_rpg`.`eventsareasdrops` ;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`eventsareasdrops` (
  `idArea` INT UNSIGNED NOT NULL,
  `idEvent` INT UNSIGNED NOT NULL,
  `idBaseItem` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idArea`, `idEvent`, `idBaseItem`),
  INDEX `fk_EventsAreasDrops_EventSpecificDrops1_idx` (`idEvent` ASC, `idBaseItem` ASC) VISIBLE,
  CONSTRAINT `fk_EventsAreasDrops_Areas1`
    FOREIGN KEY (`idArea`)
    REFERENCES `discord_bot_rpg`.`areas` (`idArea`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_EventsAreasDrops_EventSpecificDrops1`
    FOREIGN KEY (`idEvent` , `idBaseItem`)
    REFERENCES `discord_bot_rpg`.`eventspecificdrops` (`idEvent` , `idBaseItem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

REPLACE INTO eventstypes VALUES
(1, "uncategorized"),
(2, "reccuring"),
(3, "special");

REPLACE INTO events VALUES
(1, 3, "https://freesvg.org/img/nicubunu_Chocolate_birthday_cake.png", "https://cdn.fight-rpg.com/images/events/anniversary_icon.png", 525600, 10080, "2021-06-11 00:00:00", null);

REPLACE INTO eventsglobalmodifiers VALUES
(1, 1, 20), (1, 2, 20), (1, 3, 20), (1, 4, 20), (1, 5, 20), (1, 6, 20);

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`localizationevents` (
  `idEvent` INT(10) UNSIGNED NOT NULL,
  `lang` VARCHAR(5) NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `desc` TEXT NOT NULL,
  PRIMARY KEY (`idEvent`, `lang`),
  INDEX `fk_LocalizationEvents_Events1_idx` (`idEvent` ASC) VISIBLE,
  CONSTRAINT `fk_LocalizationEvents_Languages1`
    FOREIGN KEY (`lang`)
    REFERENCES `discord_bot_rpg`.`languages` (`lang`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_LocalizationEvents_Events1`
    FOREIGN KEY (`idEvent`)
    REFERENCES `discord_bot_rpg`.`events` (`idEvent`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

REPLACE INTO localizationevents VALUES
(1, "en", "Fight RPG - Anniversary!", "One more year for FightRPG! Ah, how time flies. Let's celebrate together!"),
(1, "fr", "Fight RPG - Anniversaire !", "Un an de plus pour FightRPG ! Ah, que le temps passe vite. Célébrons ça ensemble !");

ALTER TABLE `discord_bot_rpg`.`itemsbase` 
ADD COLUMN `isInDefaultLootTable` TINYINT(4) NOT NULL DEFAULT 0 AFTER `idSousType`

UPDATE itemsbase SET isInDefaultLootTable = 1 WHERE idType IN (1,2,3,4)



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
