ALTER TABLE `areasclimates` 
ADD COLUMN `nextWeatherChange` DATETIME NULL DEFAULT NULL AFTER `intensity`;

ALTER TABLE `characters` 
ADD COLUMN `health` INT UNSIGNED NULL DEFAULT NULL AFTER `talentPoints`,
ADD COLUMN `mana` INT UNSIGNED NULL DEFAULT NULL AFTER `health`,
ADD COLUMN `nextPvEAction` DATETIME NULL DEFAULT NULL AFTER `mana`,
ADD COLUMN `nextPvPAction` DATETIME NULL DEFAULT NULL AFTER `nextPveAction`;

ALTER TABLE `users` 
ADD COLUMN `isDoingSomething` TINYINT NOT NULL DEFAULT 0 AFTER `isConnected`;

CREATE TABLE IF NOT EXISTS `groupsdata` (
  `idUserLeader` VARCHAR(20) NOT NULL,
  `isDoingSomething` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`idUserLeader`),
  CONSTRAINT `fk_Groups_Users1`
    FOREIGN KEY (`idUserLeader`)
    REFERENCES `users` (`idUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `groupsplayers` (
  `idUserLeader` VARCHAR(20) NOT NULL,
  `idUser` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`idUserLeader`, `idUser`),
  INDEX `fk_GroupsCharacters_Users1_idx` (`idUser` ASC) VISIBLE,
  CONSTRAINT `fk_GroupsCharacters_Groups1`
    FOREIGN KEY (`idUserLeader`)
    REFERENCES `groupsdata` (`idUserLeader`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_GroupsCharacters_Users1`
    FOREIGN KEY (`idUser`)
    REFERENCES `users` (`idUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `groupspendingplayers` (
  `idUserLeader` VARCHAR(20) NOT NULL,
  `idUser` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`idUserLeader`, `idUser`),
  INDEX `fk_GroupsPendingPlayers_Users1_idx` (`idUser` ASC) VISIBLE,
  CONSTRAINT `fk_GroupsPendingPlayers_Groups1`
    FOREIGN KEY (`idUserLeader`)
    REFERENCES `groupsdata` (`idUserLeader`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_GroupsPendingPlayers_Users1`
    FOREIGN KEY (`idUser`)
    REFERENCES `users` (`idUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `playersequipmentsets` (
  `idSet` BIGINT(19) UNSIGNED NOT NULL,
  `name` VARCHAR(50) NOT NULL DEFAULT 'Nouveau Set',
  `isFavorite` TINYINT(4) NOT NULL DEFAULT 0,
  `creator` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`idSet`),
  INDEX `fk_PlayersEquipmentSets_Characters1_idx` (`creator` ASC) VISIBLE,
  CONSTRAINT `fk_PlayersEquipmentSets_Characters1`
    FOREIGN KEY (`creator`)
    REFERENCES `Characters` (`idCharacter`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `playersequipmentsetsitems` (
  `idSet` BIGINT(19) UNSIGNED NOT NULL,
  `idItem` BIGINT(19) UNSIGNED NOT NULL,
  PRIMARY KEY (`idSet`, `idItem`),
  INDEX `fk_PlayersEquipmentSetsItems_Items1_idx` (`idItem` ASC) VISIBLE,
  CONSTRAINT `fk_PlayersEquipmentSetsItems_PlayersEquipmentSets1`
    FOREIGN KEY (`idSet`)
    REFERENCES `playersequipmentsets` (`idSet`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PlayersEquipmentSetsItems_Items1`
    FOREIGN KEY (`idItem`)
    REFERENCES `items` (`idItem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `tradependingplayers` (
  `idUserAsking` VARCHAR(20) NOT NULL,
  `idUserInvited` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`idUserAsking`),
  INDEX `fk_TradePendingPlayers_Users2_idx` (`idUserInvited` ASC) VISIBLE,
  CONSTRAINT `fk_TradePendingPlayers_Users1`
    FOREIGN KEY (`idUserAsking`)
    REFERENCES `users` (`idUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TradePendingPlayers_Users2`
    FOREIGN KEY (`idUserInvited`)
    REFERENCES `users` (`idUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `tradeongoingdata` (
  `idUser` VARCHAR(20) NOT NULL,
  `idUserTradeWith` VARCHAR(20) NOT NULL,
  `money` BIGINT(19) UNSIGNED NOT NULL DEFAULT 0,
  `isValidated` TINYINT(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`idUser`),
  INDEX `fk_TradeOnGoingData_Users2_idx` (`idUserTradeWith` ASC) VISIBLE,
  CONSTRAINT `fk_TradeOnGoingData_Users1`
    FOREIGN KEY (`idUser`)
    REFERENCES `users` (`idUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TradeOnGoingData_Users2`
    FOREIGN KEY (`idUserTradeWith`)
    REFERENCES `users` (`idUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `tradeitems` (
  `idUser` VARCHAR(20) NOT NULL,
  `idItem` BIGINT(19) UNSIGNED NOT NULL,
  `number` INT(10) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`idUser`, `idItem`),
  INDEX `fk_TradeItems_Items1_idx` (`idItem` ASC) VISIBLE,
  CONSTRAINT `fk_TradeItems_TradeOnGoingData1`
    FOREIGN KEY (`idUser`)
    REFERENCES `tradeongoingdata` (`idUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TradeItems_Items1`
    FOREIGN KEY (`idItem`)
    REFERENCES `items` (`idItem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;