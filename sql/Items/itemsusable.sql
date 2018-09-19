-- MySQL Workbench Synchronization
-- Generated: 2018-09-18 19:03
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

ALTER TABLE `discord_bot_rpg`.`itemstypes` 
ADD COLUMN `usable` TINYINT(4) NOT NULL DEFAULT 0 AFTER `stackable`;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

INSERT INTO itemstypes VALUES (NULL, "lootbox", 0, 1, 1);
INSERT INTO itemssoustypes VALUES (NULL, 'loot_box_equipment');
INSERT INTO itemsbase VALUES (NULL, 7, 5, 'unknown', 8); -- 52
INSERT INTO localizationitems VALUES (40, 'en', 'Luxury equipment box', NULL), (40, 'fr', "Boîte d'équipement de luxe", NULL);


INSERT INTO itemstypes VALUES (NULL, "potion", 0, 1, 1);
INSERT INTO itemssoustypes VALUES (NULL, 'reset_time_potion');
INSERT INTO itemsbase VALUES (NULL, 8, 1, 'unknown', 9); -- 53
INSERT INTO localizationitems VALUES (41, 'en', 'Anti-tiredness potion', NULL), (41, 'fr', 'Potion anti-fatigue', NULL);