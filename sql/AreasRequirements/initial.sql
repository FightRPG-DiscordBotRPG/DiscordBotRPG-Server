-- MySQL Workbench Synchronization
-- Generated: 2019-02-23 19:11
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

ALTER SCHEMA `discord_bot_rpg`  DEFAULT COLLATE utf8mb4_unicode_ci ;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`areasrequirements` (
  `idArea` INT(10) UNSIGNED NOT NULL,
  `idAchievement` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`idArea`, `idAchievement`),
  INDEX `fk_AreasRequirements_Achievement1_idx` (`idAchievement` ASC),
  CONSTRAINT `fk_AreasRequirements_Areas1`
    FOREIGN KEY (`idArea`)
    REFERENCES `discord_bot_rpg`.`areas` (`idArea`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_AreasRequirements_Achievement1`
    FOREIGN KEY (`idAchievement`)
    REFERENCES `discord_bot_rpg`.`achievement` (`idAchievement`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


