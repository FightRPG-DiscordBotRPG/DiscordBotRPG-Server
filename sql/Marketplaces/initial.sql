-- MySQL Workbench Synchronization
-- Generated: 2018-06-15 15:18
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`Marketplaces` (
  `idMarketplace` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `tax` FLOAT(11) NOT NULL DEFAULT 0.05,
  `idArea` INT(10) UNSIGNED NOT NULL,
  `active` TINYINT(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`idMarketplace`),
  UNIQUE INDEX `idMarketplace_UNIQUE` (`idMarketplace` ASC),
  INDEX `fk_Marketplaces_Areas1_idx` (`idArea` ASC),
  UNIQUE INDEX `idArea_UNIQUE` (`idArea` ASC),
  CONSTRAINT `fk_Marketplaces_Areas1`
    FOREIGN KEY (`idArea`)
    REFERENCES `discord_bot_rpg`.`Areas` (`idArea`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`MarketplacesOrders` (
  `idMarketplace` INT(10) UNSIGNED NOT NULL,
  `idItem` INT(10) UNSIGNED NOT NULL,
  `idCharacter` INT(10) UNSIGNED NOT NULL,
  `number` INT(10) UNSIGNED NOT NULL DEFAULT 1,
  `price` BIGINT(19) UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (`idMarketplace`, `idItem`, `idCharacter`),
  INDEX `fk_MarketplacesOrders_Items1_idx` (`idItem` ASC),
  INDEX `fk_MarketplacesOrders_Characters1_idx` (`idCharacter` ASC),
  UNIQUE INDEX `idItem_UNIQUE` (`idItem` ASC),
  CONSTRAINT `fk_MarketplacesOrders_Marketplaces1`
    FOREIGN KEY (`idMarketplace`)
    REFERENCES `discord_bot_rpg`.`Marketplaces` (`idMarketplace`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_MarketplacesOrders_Items1`
    FOREIGN KEY (`idItem`)
    REFERENCES `discord_bot_rpg`.`Items` (`idItem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_MarketplacesOrders_Characters1`
    FOREIGN KEY (`idCharacter`)
    REFERENCES `discord_bot_rpg`.`Characters` (`idCharacter`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

INSERT IGNORE INTO marketplaces (idArea)
SELECT idArea
FROM areas
INNER JOIN areastypes
ON areas.idAreaType = areastypes.idAreaType
WHERE areastypes.NomAreaType = "city"

-- MySQL Workbench Synchronization
-- Generated: 2018-06-17 13:31
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

ALTER TABLE `discord_bot_rpg`.`Characters`
CHANGE COLUMN `money` `money` BIGINT(19) UNSIGNED NOT NULL ;

ALTER TABLE `discord_bot_rpg`.`Guilds`
CHANGE COLUMN `argent` `argent` BIGINT(19) UNSIGNED NOT NULL DEFAULT 0 ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


-- MySQL Workbench Synchronization
-- Generated: 2018-06-17 15:55
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

ALTER TABLE `discord_bot_rpg`.`UsersPreferences`
ADD COLUMN `marketplacemute` TINYINT(4) NOT NULL DEFAULT 0 AFTER `lang`;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
