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
  `startDate` DATETIME NOT NULL,
  `endDate` DATETIME NOT NULL,
  `backgroundImage` TEXT NOT NULL,
  `iconImage` TEXT NOT NULL,
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


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
