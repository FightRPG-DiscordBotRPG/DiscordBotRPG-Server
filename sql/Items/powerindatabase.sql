-- MySQL Workbench Synchronization
-- Generated: 2019-07-30 14:21
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`itemspower` (
  `idItem` INT(10) UNSIGNED NOT NULL,
  `power` INT(10) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`idItem`),
  CONSTRAINT `fk_ItemsPower_Items1`
    FOREIGN KEY (`idItem`)
    REFERENCES `discord_bot_rpg`.`items` (`idItem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


SET SESSION MAX_EXECUTION_TIME=10000;
INSERT INTO itemspower SELECT idItem,
ROUND(COALESCE((SELECT DISTINCT
    (
    SELECT
        COALESCE(SUM(itemsstats.value) / 100, 0) AS powerValue
    FROM
        itemsstats
    WHERE
        idItem = subItems.idItem AND itemsstats.idStat IN(1, 3)
)+
(
    SELECT
        COALESCE(
            SUM(itemsstats.value) / 100 * 0.25
        , 0) AS powerValue
    FROM
        itemsstats
    WHERE
        idItem = subItems.idItem AND itemsstats.idStat IN(2, 6, 8, 10)
)+
(
    SELECT
        COALESCE(
            SUM(itemsstats.value) / 100 * 0.8
        , 0) AS powerValue
    FROM
        itemsstats
    WHERE
        idItem = subItems.idItem AND itemsstats.idStat = 5
)+
(
    SELECT
        COALESCE(
            SUM(itemsstats.value) / 100 * 0.6
        , 0) AS powerValue
    FROM
        itemsstats
    WHERE
        idItem = subItems.idItem AND itemsstats.idStat IN(7, 9)
)+
(
    SELECT
        COALESCE(
            SUM(itemsstats.value) / CEIL((8 *(POW(50, 2)) / 7) / 4.5) * 0.6
        , 0) AS powerValue
    FROM
        itemsstats
    WHERE
        idItem = subItems.idItem AND itemsstats.idStat = 4
) AS power
FROM
    itemsstats
WHERE
    itemsstats.idItem = subItems.idItem), 0) / 5 * 100)
as power FROM items subItems


















































INSERT INTO itemspower SELECT idItem,
ROUND(COALESCE((SELECT DISTINCT
    (
    SELECT
        COALESCE(SUM(itemsstats.value) / 100, 0) AS powerValue
    FROM
        itemsstats
    WHERE
        idItem = subItems.idItem AND itemsstats.idStat IN(1, 3)
)+
(
    SELECT
        COALESCE(
            SUM(itemsstats.value) / 100 * 0.25
        , 0) AS powerValue
    FROM
        itemsstats
    WHERE
        idItem = subItems.idItem AND itemsstats.idStat IN(2, 6, 8, 10)
)+
(
    SELECT
        COALESCE(
            SUM(itemsstats.value) / 100 * 0.8
        , 0) AS powerValue
    FROM
        itemsstats
    WHERE
        idItem = subItems.idItem AND itemsstats.idStat = 5
)+
(
    SELECT
        COALESCE(
            SUM(itemsstats.value) / 100 * 0.6
        , 0) AS powerValue
    FROM
        itemsstats
    WHERE
        idItem = subItems.idItem AND itemsstats.idStat IN(7, 9)
)+
(
    SELECT
        COALESCE(
            SUM(itemsstats.value) / CEIL((8 *(POW(50, 2)) / 7) / 4.5) * 0.6
        , 0) AS powerValue
    FROM
        itemsstats
    WHERE
        idItem = subItems.idItem AND itemsstats.idStat = 4
) AS power
FROM
    itemsstats
WHERE
    itemsstats.idItem = subItems.idItem), 0) / 5 * 100)
as power FROM items subItems WHERE idItem NOT IN (SELECT idItem FROM itemspower)













