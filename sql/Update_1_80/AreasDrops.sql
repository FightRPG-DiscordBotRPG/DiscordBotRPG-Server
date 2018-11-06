-- MySQL Workbench Synchronization
-- Generated: 2018-11-05 15:41
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

ALTER TABLE `discord_bot_rpg`.`areasresources`
DROP FOREIGN KEY `fk_AreasResources_LevelsRequire1`;

ALTER TABLE `discord_bot_rpg`.`areasresources`
DROP COLUMN `requiredLevel`,
DROP INDEX `fk_AreasResources_LevelsRequire1_idx` ;


SET SQL_MODE
=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS
=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS
=@OLD_UNIQUE_CHECKS;

-- MySQL Workbench Synchronization
-- Generated: 2018-11-05 19:39
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

ALTER TABLE `discord_bot_rpg`.`localizationareas` 
CHANGE COLUMN `descArea` `descArea` TEXT NULL DEFAULT NULL ;


SET SQL_MODE
=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS
=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS
=@OLD_UNIQUE_CHECKS;

