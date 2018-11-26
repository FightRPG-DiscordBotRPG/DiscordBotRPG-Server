-- MySQL Workbench Synchronization
-- Generated: 2018-11-25 13:55
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`shop` (
  `idShop` INT(10) UNSIGNED NOT NULL,
  `tax` FLOAT(10) UNSIGNED NOT NULL DEFAULT 0.05,
  `active` TINYINT(3) UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (`idShop`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`sellableitems` (
  `idSellableItems` INT(10) UNSIGNED NOT NULL,
  `idBaseItem` INT(10) UNSIGNED NOT NULL,
  `level` INT(11) NOT NULL,
  `number` INT(11) NOT NULL,
  PRIMARY KEY (`idSellableItems`),
  INDEX `fk_SellableItems_ItemsBase1_idx` (`idBaseItem` ASC),
  CONSTRAINT `fk_SellableItems_ItemsBase1`
    FOREIGN KEY (`idBaseItem`)
    REFERENCES `discord_bot_rpg`.`itemsbase` (`idBaseItem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`shopitems` (
  `idShop` INT(10) UNSIGNED NOT NULL,
  `idSellableItems` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`idShop`, `idSellableItems`),
  INDEX `fk_ShopItems_SellableItems1_idx` (`idSellableItems` ASC),
  CONSTRAINT `fk_ShopItems_Shop1`
    FOREIGN KEY (`idShop`)
    REFERENCES `discord_bot_rpg`.`shop` (`idShop`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ShopItems_SellableItems1`
    FOREIGN KEY (`idSellableItems`)
    REFERENCES `discord_bot_rpg`.`sellableitems` (`idSellableItems`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`areasshops` (
  `idArea` INT(10) UNSIGNED NOT NULL,
  `idShop` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`idArea`, `idShop`),
  INDEX `fk_AreasShops_Shop1_idx` (`idShop` ASC),
  CONSTRAINT `fk_AreasShops_Areas1`
    FOREIGN KEY (`idArea`)
    REFERENCES `discord_bot_rpg`.`areas` (`idArea`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_AreasShops_Shop1`
    FOREIGN KEY (`idShop`)
    REFERENCES `discord_bot_rpg`.`shop` (`idShop`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- MySQL Workbench Synchronization
-- Generated: 2018-11-25 15:15
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

ALTER TABLE `discord_bot_rpg`.`sellableitems` 
CHANGE COLUMN `level` `level` INT(11) NOT NULL DEFAULT 1 ,
CHANGE COLUMN `number` `number` INT(11) NOT NULL DEFAULT 1 ,
ADD COLUMN `price` INT(11) NOT NULL DEFAULT 1 AFTER `number`;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;



-- MySQL Workbench Synchronization
-- Generated: 2018-11-25 15:26
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

ALTER TABLE `discord_bot_rpg`.`shop` 
CHANGE COLUMN `idShop` `idShop` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ;

ALTER TABLE `discord_bot_rpg`.`sellableitems` 
CHANGE COLUMN `idSellableItems` `idSellableItems` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;



INSERT INTO shop VALUES (NULL, 0.05, 1), (NULL, 0.05, 1), (NULL, 0.05, 1), (NULL, 0.05, 1), (NULL, 0.05, 1), (NULL, 0.05, 1), (NULL, 0.05, 1);

INSERT INTO areasshops VALUES (6,1), (5,2), (8,3), (14,4), (15,5), (16,6), (22,7);


-- Epic
INSERT INTO sellableitems VALUES (NULL, 43, 10, 1, 65); -- 1
INSERT INTO sellableitems VALUES (NULL, 43, 20, 1, 130); -- 2
INSERT INTO sellableitems VALUES (NULL, 43, 30, 1, 195); -- 3
INSERT INTO sellableitems VALUES (NULL, 43, 40, 1, 260); -- 4
INSERT INTO sellableitems VALUES (NULL, 43, 50, 1, 320); -- 5
INSERT INTO sellableitems VALUES (NULL, 43, 60, 1, 385); -- 6
INSERT INTO sellableitems VALUES (NULL, 43, 70, 1, 450); -- 7
INSERT INTO sellableitems VALUES (NULL, 43, 80, 1, 510); -- 8

-- legs
INSERT INTO sellableitems VALUES (NULL, 44, 10, 1, 85); -- 9
INSERT INTO sellableitems VALUES (NULL, 44, 20, 1, 170); -- 10
INSERT INTO sellableitems VALUES (NULL, 44, 30, 1, 260); -- 11
INSERT INTO sellableitems VALUES (NULL, 44, 40, 1, 345); -- 12
INSERT INTO sellableitems VALUES (NULL, 44, 50, 1, 425); -- 13
INSERT INTO sellableitems VALUES (NULL, 44, 60, 1, 510); -- 14
INSERT INTO sellableitems VALUES (NULL, 44, 70, 1, 600); -- 15
INSERT INTO sellableitems VALUES (NULL, 44, 80, 1, 680); -- 16


INSERT INTO shopitems VALUES 
(1, 1), (1, 9),
(2, 2), (2, 10),
(3, 3), (3, 11),
(4, 4), (4, 12),
(5, 5), (5, 13),
(6, 6), (6, 14),
(7, 7), (7, 15),
(7, 8), (7, 16);