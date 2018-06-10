-- MySQL Workbench Synchronization
-- Generated: 2018-06-10 16:58
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

ALTER TABLE `discord_bot_rpg`.`Users`
DROP COLUMN `lang`;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`UsersPreferences` (
  `idUser` VARCHAR(20) NOT NULL,
  `groupmute` TINYINT(4) NOT NULL DEFAULT 0,
  `lang` VARCHAR(3) NOT NULL DEFAULT 'en',
  PRIMARY KEY (`idUser`),
  UNIQUE INDEX `idUser_UNIQUE` (`idUser` ASC),
  CONSTRAINT `fk_UsersPreferences_Users1`
    FOREIGN KEY (`idUser`)
    REFERENCES `discord_bot_rpg`.`Users` (`idUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

INSERT INTO userspreferences (idUser)
SELECT users.idUser
FROM users
LEFT JOIN userspreferences ON userspreferences.idUser = users.idUser
WHERE userspreferences.idUser IS NULL
