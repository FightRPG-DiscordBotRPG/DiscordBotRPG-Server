-- MySQL Workbench Synchronization
-- Generated: 2018-08-08 11:56
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

ALTER TABLE `discord_bot_rpg`.`users` 
ADD COLUMN `isConnected` TINYINT(3) UNSIGNED NOT NULL DEFAULT 0 AFTER `token`;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- MySQL Workbench Synchronization
-- Generated: 2018-08-09 12:26
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';


DELIMITER $$
USE `discord_bot_rpg`$$
CREATE PROCEDURE `doesPlayerHaveEnoughMatsToCraftThisItem` (IN idCharacterToLook INT, IN idCaftToLook INT)
BEGIN
	SELECT 
    IF((SELECT 
                COUNT(*)
            FROM
                charactersinventory
                    INNER JOIN
                items ON items.idItem = charactersinventory.idItem
            WHERE
                charactersinventory.idCharacter = idCharacterToLook
                    AND items.idBaseItem IN (SELECT 
                        craftitemsneeded.NeededItem
                    FROM
                        craftitemsneeded
                    WHERE
                        craftitemsneeded.IdCraftItem = idCaftToLook)
                    AND charactersinventory.number >= (SELECT 
                        craftitemsneeded.number
                    FROM
                        craftitemsneeded
                    WHERE
                        craftitemsneeded.IdCraftItem = idCaftToLook
                            AND craftitemsneeded.NeededItem = items.idBaseItem)) = (SELECT 
                COUNT(*)
            FROM
                craftitemsneeded
            WHERE
                craftitemsneeded.IdCraftItem = idCaftToLook),
        'true',
        'false') AS doesPlayerHaveEnoughMats;
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


