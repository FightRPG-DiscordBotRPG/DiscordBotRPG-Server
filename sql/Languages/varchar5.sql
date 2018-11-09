-- MySQL Workbench Synchronization
-- Generated: 2018-11-09 13:07
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

ALTER TABLE `discord_bot_rpg`.`localizationitems`
DROP FOREIGN KEY `fk_LocalizationItems_Languages1`;

ALTER TABLE `discord_bot_rpg`.`localizationareas`
DROP FOREIGN KEY `fk_LocalizationAreas_Languages1`;

ALTER TABLE `discord_bot_rpg`.`localizationregions`
DROP FOREIGN KEY `fk_LocalizationRegions_Languages1`;

ALTER TABLE `discord_bot_rpg`.`localizationmonsters`
DROP FOREIGN KEY `fk_LocalizationMonsters_Languages1`;

ALTER TABLE `discord_bot_rpg`.`localizationachievements`
DROP FOREIGN KEY `fk_LocalizationAchievements_Languages1`;

ALTER TABLE `discord_bot_rpg`.`localizationitems` 
CHANGE COLUMN `lang` `lang` VARCHAR
(5) NOT NULL ;

ALTER TABLE `discord_bot_rpg`.`languages` 
CHANGE COLUMN `lang` `lang` VARCHAR
(5) NOT NULL DEFAULT 'en' ;

ALTER TABLE `discord_bot_rpg`.`localizationareas` 
CHANGE COLUMN `lang` `lang` VARCHAR
(5) NOT NULL ;

ALTER TABLE `discord_bot_rpg`.`localizationregions` 
CHANGE COLUMN `lang` `lang` VARCHAR
(5) NOT NULL ;

ALTER TABLE `discord_bot_rpg`.`localizationmonsters` 
CHANGE COLUMN `lang` `lang` VARCHAR
(5) NOT NULL ;

ALTER TABLE `discord_bot_rpg`.`localizationachievements` 
CHANGE COLUMN `lang` `lang` VARCHAR
(5) NOT NULL ;

ALTER TABLE `discord_bot_rpg`.`localizationitems`
ADD CONSTRAINT `fk_LocalizationItems_Languages1`
  FOREIGN KEY
(`lang`)
  REFERENCES `discord_bot_rpg`.`languages`
(`lang`)
  ON
DELETE NO ACTION
  ON
UPDATE NO ACTION;

ALTER TABLE `discord_bot_rpg`.`localizationareas`
ADD CONSTRAINT `fk_LocalizationAreas_Languages1`
  FOREIGN KEY
(`lang`)
  REFERENCES `discord_bot_rpg`.`languages`
(`lang`)
  ON
DELETE NO ACTION
  ON
UPDATE NO ACTION;

ALTER TABLE `discord_bot_rpg`.`localizationregions`
ADD CONSTRAINT `fk_LocalizationRegions_Languages1`
  FOREIGN KEY
(`lang`)
  REFERENCES `discord_bot_rpg`.`languages`
(`lang`)
  ON
DELETE NO ACTION
  ON
UPDATE NO ACTION;

ALTER TABLE `discord_bot_rpg`.`localizationmonsters`
ADD CONSTRAINT `fk_LocalizationMonsters_Languages1`
  FOREIGN KEY
(`lang`)
  REFERENCES `discord_bot_rpg`.`languages`
(`lang`)
  ON
DELETE NO ACTION
  ON
UPDATE NO ACTION;

ALTER TABLE `discord_bot_rpg`.`localizationachievements`
ADD CONSTRAINT `fk_LocalizationAchievements_Languages1`
  FOREIGN KEY
(`lang`)
  REFERENCES `discord_bot_rpg`.`languages`
(`lang`)
  ON
DELETE NO ACTION
  ON
UPDATE NO ACTION;


SET SQL_MODE
=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS
=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS
=@OLD_UNIQUE_CHECKS;


-- MySQL Workbench Synchronization
-- Generated: 2018-11-09 17:29
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

ALTER TABLE `discord_bot_rpg`.`userspreferences` 
CHANGE COLUMN `lang` `lang` VARCHAR
(5) NOT NULL DEFAULT 'en' ;


SET SQL_MODE
=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS
=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS
=@OLD_UNIQUE_CHECKS;
