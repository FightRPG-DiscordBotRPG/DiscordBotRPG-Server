-- MySQL Workbench Synchronization
-- Generated: 2018-11-02 13:39
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

CREATE TABLE
IF NOT EXISTS `discord_bot_rpg`.`achievement`
(
  `idAchievement` INT
(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name_identifier` VARCHAR
(50) NOT NULL,
  `points` INT
(11) NOT NULL DEFAULT 10,
  PRIMARY KEY
(`idAchievement`),
  UNIQUE INDEX `idAchievement_UNIQUE`
(`idAchievement` ASC),
  UNIQUE INDEX `name_identifier_UNIQUE`
(`name_identifier` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER
SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE
IF NOT EXISTS `discord_bot_rpg`.`localizationachievements`
(
  `idAchievement` INT
(10) UNSIGNED NOT NULL,
  `lang` VARCHAR
(3) NOT NULL,
  `nameAchievement` VARCHAR
(50) NOT NULL,
  `descAchievement` TEXT NULL DEFAULT NULL,
  PRIMARY KEY
(`idAchievement`, `lang`),
  INDEX `fk_LocalizationAchievements_Languages1_idx`
(`lang` ASC),
  CONSTRAINT `fk_LocalizationAchievements_Achievement1`
    FOREIGN KEY
(`idAchievement`)
    REFERENCES `discord_bot_rpg`.`achievement`
(`idAchievement`)
    ON
DELETE NO ACTION
    ON
UPDATE NO ACTION,
  CONSTRAINT `fk_LocalizationAchievements_Languages1`
    FOREIGN KEY
(`lang`)
    REFERENCES `discord_bot_rpg`.`languages`
(`lang`)
    ON
DELETE NO ACTION
    ON
UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER
SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE
IF NOT EXISTS `discord_bot_rpg`.`charactersachievements`
(
  `idCharacter` INT
(10) UNSIGNED NOT NULL,
  `idAchievement` INT
(10) UNSIGNED NOT NULL,
  PRIMARY KEY
(`idCharacter`, `idAchievement`),
  INDEX `fk_CharactersAchievements_Achievement1_idx`
(`idAchievement` ASC),
  CONSTRAINT `fk_CharactersAchievements_Characters1`
    FOREIGN KEY
(`idCharacter`)
    REFERENCES `discord_bot_rpg`.`characters`
(`idCharacter`)
    ON
DELETE NO ACTION
    ON
UPDATE NO ACTION,
  CONSTRAINT `fk_CharactersAchievements_Achievement1`
    FOREIGN KEY
(`idAchievement`)
    REFERENCES `discord_bot_rpg`.`achievement`
(`idAchievement`)
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


INSERT INTO achievement
VALUES
    (NULL, "founder", 100);
INSERT INTO localizationachievements
VALUES
    (1, "en", "Founder", NULL),
    (1, "fr", "Fondateur", NULL);