-- MySQL Workbench Synchronization
-- Generated: 2018-07-10 14:47
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`conquesttournamentinscriptions` (
  `idGuild` INT(10) UNSIGNED NOT NULL,
  `idArea` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`idGuild`),
  INDEX `fk_AreaConquestTournament_Guilds1_idx` (`idGuild` ASC),
  UNIQUE INDEX `idGuild_UNIQUE` (`idGuild` ASC),
  INDEX `fk_ConquestTournamentIncriptions_Areas1_idx` (`idArea` ASC),
  CONSTRAINT `fk_AreaConquestTournament_Guilds1`
    FOREIGN KEY (`idGuild`)
    REFERENCES `discord_bot_rpg`.`guilds` (`idGuild`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ConquestTournamentIncriptions_Areas1`
    FOREIGN KEY (`idArea`)
    REFERENCES `discord_bot_rpg`.`areas` (`idArea`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`conquesttournamentrounds` (
  `idArea` INT(10) UNSIGNED NOT NULL,
  `idRound` INT(10) UNSIGNED NOT NULL,
  `idGuild_1` INT(10) UNSIGNED NOT NULL,
  `idGuild_2` INT(10) UNSIGNED NULL DEFAULT NULL,
  `winner` TINYINT(3) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`idArea`, `idRound`, `idGuild_1`),
  INDEX `fk_ConquestTournamentRounds_ConquestTournamentInscriptions1_idx` (`idGuild_1` ASC),
  INDEX `fk_ConquestTournamentRounds_ConquestTournamentInscriptions2_idx` (`idGuild_2` ASC),
  INDEX `fk_ConquestTournamentRounds_Areas1_idx` (`idArea` ASC),
  CONSTRAINT `fk_ConquestTournamentRounds_ConquestTournamentInscriptions1`
    FOREIGN KEY (`idGuild_1`)
    REFERENCES `discord_bot_rpg`.`conquesttournamentinscriptions` (`idGuild`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ConquestTournamentRounds_ConquestTournamentInscriptions2`
    FOREIGN KEY (`idGuild_2`)
    REFERENCES `discord_bot_rpg`.`conquesttournamentinscriptions` (`idGuild`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ConquestTournamentRounds_Areas1`
    FOREIGN KEY (`idArea`)
    REFERENCES `discord_bot_rpg`.`areas` (`idArea`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`conquesttournamentinfo` (
  `idArea` INT(10) UNSIGNED NOT NULL,
  `actualRound` INT(10) UNSIGNED NOT NULL DEFAULT 0,
  `started` TINYINT(3) UNSIGNED NOT NULL DEFAULT 0,
  `nextTournament` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`idArea`),
  CONSTRAINT `fk_ConquestTournamentInfo_Areas1`
    FOREIGN KEY (`idArea`)
    REFERENCES `discord_bot_rpg`.`areas` (`idArea`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
