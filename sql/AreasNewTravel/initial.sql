-- MySQL Workbench Synchronization
-- Generated: 2018-08-04 17:40
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`areaspaths` (
  `idArea1` INT(10) UNSIGNED NOT NULL,
  `idArea2` INT(10) UNSIGNED NOT NULL,
  `time` INT(10) UNSIGNED NOT NULL DEFAULT 120,
  `goldPrice` INT(10) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`idArea1`, `idArea2`),
  INDEX `fk_AreasPaths_Areas2_idx` (`idArea2` ASC),
  CONSTRAINT `fk_AreasPaths_Areas1`
    FOREIGN KEY (`idArea1`)
    REFERENCES `discord_bot_rpg`.`areas` (`idArea`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_AreasPaths_Areas2`
    FOREIGN KEY (`idArea2`)
    REFERENCES `discord_bot_rpg`.`areas` (`idArea`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

INSERT INTO `areaspaths`(`idArea1`, `idArea2`, `time`, `goldPrice`) VALUES (6,1,30,0),(1,2,45,0),(1,3,45,0),(2,5,60,0),(3,4,45,0),(5,4,60,0),(4,7,30,0);

INSERT IGNORE INTO areaspaths
SELECT idArea2 as idArea1, idArea1 as idArea2, time, goldPrice FROM areaspaths;

