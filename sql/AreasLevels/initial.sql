-- MySQL Workbench Synchronization
-- Generated: 2018-11-04 14:18
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS
, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS
, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE
, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

ALTER TABLE `discord_bot_rpg`.`areas`
DROP COLUMN `AreaLevels`;

CREATE TABLE
IF NOT EXISTS `discord_bot_rpg`.`areasmonsterslevels`
(
  `idArea` INT
(10) UNSIGNED NOT NULL,
  `minLevel` INT
(10) UNSIGNED NOT NULL DEFAULT 1,
  `maxLevel` INT
(10) UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY
(`idArea`),
  CONSTRAINT `fk_AreasMonstersLevels_Areas1`
    FOREIGN KEY
(`idArea`)
    REFERENCES `discord_bot_rpg`.`areas`
(`idArea`)
    ON
DELETE NO ACTION
    ON
UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER
SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


SET SQL_MODE
=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS
=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS
=@OLD_UNIQUE_CHECKS;

INSERT INTO areasmonsterslevels
VALUES(1, 1, 5),
    (2, 5, 10),
    (3, 10, 15),
    (4, 15, 20),
    (5, 20, 20),
    (6, 1, 1),
    (7, 20, 20);
