-- MySQL Workbench Synchronization
-- Generated: 2018-10-07 12:59
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

ALTER TABLE `discord_bot_rpg`.`StatsMonstres` 
DROP FOREIGN KEY `fk_StatsMonstres_Stats1`;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`statsprofil` (
  `idStatsProfil` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`idStatsProfil`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`statsrepartition` (
  `idStatsProfil` INT(10) UNSIGNED NOT NULL,
  `idStat` INT(10) UNSIGNED NOT NULL,
  `percentage` TINYINT(3) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`idStatsProfil`, `idStat`),
  INDEX `fk_StatsRepartition_Stats1_idx` (`idStat` ASC),
  CONSTRAINT `fk_StatsRepartition_StatsProfil1`
    FOREIGN KEY (`idStatsProfil`)
    REFERENCES `discord_bot_rpg`.`statsprofil` (`idStatsProfil`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_StatsRepartition_Stats1`
    FOREIGN KEY (`idStat`)
    REFERENCES `discord_bot_rpg`.`stats` (`idStat`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

DELETE FROM statsmonstres

ALTER TABLE `discord_bot_rpg`.`statsmonstres` 
DROP COLUMN `value`,
DROP COLUMN `idStat`,
ADD COLUMN `idStatsProfil` INT(10) UNSIGNED NOT NULL AFTER `idMonstre`,
DROP PRIMARY KEY,
ADD PRIMARY KEY (`idMonstre`),
ADD INDEX `fk_StatsMonstres_StatsProfil1_idx` (`idStatsProfil` ASC),
DROP INDEX `fk_StatsMonstres_Stats1_idx` ;

ALTER TABLE `discord_bot_rpg`.`statsmonstres` 
ADD CONSTRAINT `fk_StatsMonstres_StatsProfil1`
  FOREIGN KEY (`idStatsProfil`)
  REFERENCES `discord_bot_rpg`.`StatsProfil` (`idStatsProfil`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

INSERT INTO `statsprofil` (`idStatsProfil`, `name`) VALUES (NULL, 'balance');
INSERT INTO `statsrepartition` (`idStatsProfil`, `idStat`, `percentage`) VALUES ('1', '1', '25'), ('1', '3', '25'), ('1', '5', '25'), ('1', '9', '25'), ('1', '4', '15');
INSERT INTO statsmonstres SELECT idMonstre, 1 FROM monstres
