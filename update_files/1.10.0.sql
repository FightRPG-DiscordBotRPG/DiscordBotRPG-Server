-- MySQL Workbench Synchronization
-- Generated: 2020-07-04 14:55
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

ALTER SCHEMA `discord_bot_rpg`  DEFAULT COLLATE utf8mb4_unicode_ci ;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`traits` (
  `idTrait` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idTraitType` INT UNSIGNED NOT NULL,
  `valueFloat` FLOAT(11) NULL DEFAULT 0,
  `valueState` INT UNSIGNED NULL DEFAULT NULL,
  `valueElementType` INT UNSIGNED NULL DEFAULT NULL,
  `valueSkillType` INT UNSIGNED NULL DEFAULT NULL,
  `valueStat` INT UNSIGNED NULL DEFAULT NULL,
  `valueSkill` INT UNSIGNED NULL DEFAULT NULL,
  `valueSecondaryStat` INT UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`idTrait`),
  UNIQUE INDEX `idTrait_UNIQUE` (`idTrait` ASC) VISIBLE,
  INDEX `fk_Traits_States1_idx` (`valueState` ASC) VISIBLE,
  INDEX `fk_Traits_TraitsTypes1_idx` (`idTraitType` ASC) VISIBLE,
  INDEX `fk_Traits_ElementsTypes1_idx` (`valueElementType` ASC) VISIBLE,
  INDEX `fk_Traits_SkillsTypes1_idx` (`valueSkillType` ASC) VISIBLE,
  INDEX `fk_Traits_Stats1_idx` (`valueStat` ASC) VISIBLE,
  INDEX `fk_Traits_Skills1_idx` (`valueSkill` ASC) VISIBLE,
  INDEX `fk_Traits_SecondaryStats1_idx` (`valueSecondaryStat` ASC) VISIBLE,
  CONSTRAINT `fk_Traits_States1`
    FOREIGN KEY (`valueState`)
    REFERENCES `discord_bot_rpg`.`states` (`idState`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Traits_TraitsTypes1`
    FOREIGN KEY (`idTraitType`)
    REFERENCES `discord_bot_rpg`.`traitstypes` (`idTraitType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Traits_ElementsTypes1`
    FOREIGN KEY (`valueElementType`)
    REFERENCES `discord_bot_rpg`.`elementstypes` (`idElementType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Traits_SkillsTypes1`
    FOREIGN KEY (`valueSkillType`)
    REFERENCES `discord_bot_rpg`.`skillstypes` (`idSkillType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Traits_Stats1`
    FOREIGN KEY (`valueStat`)
    REFERENCES `discord_bot_rpg`.`stats` (`idStat`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Traits_Skills1`
    FOREIGN KEY (`valueSkill`)
    REFERENCES `discord_bot_rpg`.`skills` (`idSkill`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Traits_SecondaryStats1`
    FOREIGN KEY (`valueSecondaryStat`)
    REFERENCES `discord_bot_rpg`.`secondarystats` (`idSecondaryStat`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`traitstypes` (
  `idTraitType` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `typeShorthand` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idTraitType`),
  UNIQUE INDEX `typeShorthand_UNIQUE` (`typeShorthand` ASC) VISIBLE,
  UNIQUE INDEX `idTraitType_UNIQUE` (`idTraitType` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`states` (
  `idState` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idStateRestriction` INT UNSIGNED NULL DEFAULT NULL,
  `shorthand` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idState`),
  UNIQUE INDEX `idState_UNIQUE` (`idState` ASC) VISIBLE,
  INDEX `fk_States_StatesRestrictions1_idx` (`idStateRestriction` ASC) VISIBLE,
  CONSTRAINT `fk_States_StatesRestrictions1`
    FOREIGN KEY (`idStateRestriction`)
    REFERENCES `discord_bot_rpg`.`statesrestrictions` (`idStateRestriction`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`statesrestrictions` (
  `idStateRestriction` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `shorhand` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idStateRestriction`),
  UNIQUE INDEX `idStateRestriction_UNIQUE` (`idStateRestriction` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`statesremovalconditions` (
  `idState` INT UNSIGNED NOT NULL,
  `afterFight` TINYINT NOT NULL DEFAULT 0,
  `afterRounds` TINYINT NOT NULL DEFAULT 0,
  `roundMin` INT NOT NULL DEFAULT 0,
  `roundMax` INT NOT NULL DEFAULT 0,
  `afterDamage` TINYINT NOT NULL DEFAULT 0,
  `damageProbability` FLOAT(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`idState`),
  INDEX `fk_StatesRemovalConditions_States1_idx` (`idState` ASC) VISIBLE,
  CONSTRAINT `fk_StatesRemovalConditions_States1`
    FOREIGN KEY (`idState`)
    REFERENCES `discord_bot_rpg`.`states` (`idState`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`statestraits` (
  `idState` INT UNSIGNED NOT NULL,
  `idTrait` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idState`, `idTrait`),
  INDEX `fk_StatesTraits_Traits1_idx` (`idTrait` ASC) VISIBLE,
  CONSTRAINT `fk_StatesTraits_States1`
    FOREIGN KEY (`idState`)
    REFERENCES `discord_bot_rpg`.`states` (`idState`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_StatesTraits_Traits1`
    FOREIGN KEY (`idTrait`)
    REFERENCES `discord_bot_rpg`.`traits` (`idTrait`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`elementstypes` (
  `idElementType` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `shorthand` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idElementType`),
  UNIQUE INDEX `idElementType_UNIQUE` (`idElementType` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`skillstypes` (
  `idSkillType` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `shorthand` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idSkillType`),
  UNIQUE INDEX `idSkillType_UNIQUE` (`idSkillType` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`skills` (
  `idSkill` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `shorthand` VARCHAR(255) NOT NULL,
  `idSkillType` INT UNSIGNED NULL DEFAULT NULL,
  `energyCost` INT UNSIGNED NOT NULL DEFAULT 0,
  `manaCost` INT UNSIGNED NOT NULL DEFAULT 0,
  `idTargetRange` INT NOT NULL,
  PRIMARY KEY (`idSkill`),
  UNIQUE INDEX `idSkill_UNIQUE` (`idSkill` ASC) VISIBLE,
  INDEX `fk_Skills_SkillsTypes1_idx` (`idSkillType` ASC) VISIBLE,
  INDEX `fk_Skills_TargetRange1_idx` (`idTargetRange` ASC) VISIBLE,
  CONSTRAINT `fk_Skills_SkillsTypes1`
    FOREIGN KEY (`idSkillType`)
    REFERENCES `discord_bot_rpg`.`skillstypes` (`idSkillType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Skills_TargetRange1`
    FOREIGN KEY (`idTargetRange`)
    REFERENCES `discord_bot_rpg`.`targetrange` (`idTargetRange`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`targetrange` (
  `idTargetRange` INT NOT NULL,
  `shothand` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idTargetRange`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`castinfo` (
  `idSkill` INT UNSIGNED NOT NULL,
  `timeToCast` INT UNSIGNED NOT NULL DEFAULT 0,
  `successRate` FLOAT(10) UNSIGNED NOT NULL DEFAULT 0,
  `repeat` TINYINT(3) UNSIGNED NOT NULL DEFAULT 1,
  `energyGain` INT UNSIGNED NOT NULL DEFAULT 0,
  `idAttackType` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idSkill`),
  INDEX `fk_CastInfo_AttacksTypes1_idx` (`idAttackType` ASC) VISIBLE,
  CONSTRAINT `fk_CastInfo_Skills1`
    FOREIGN KEY (`idSkill`)
    REFERENCES `discord_bot_rpg`.`skills` (`idSkill`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CastInfo_AttacksTypes1`
    FOREIGN KEY (`idAttackType`)
    REFERENCES `discord_bot_rpg`.`attackstypes` (`idAttackType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`attackstypes` (
  `idAttackType` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `shorthand` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idAttackType`),
  UNIQUE INDEX `idAttackType_UNIQUE` (`idAttackType` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`requiredsubtypeequipped` (
  `idSousType` INT UNSIGNED NOT NULL,
  `idSkill` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idSousType`, `idSkill`),
  INDEX `fk_RequiredSubtypeEquipped_Skills1_idx` (`idSkill` ASC) VISIBLE,
  CONSTRAINT `fk_RequiredSubtypeEquipped_ItemsSousTypes1`
    FOREIGN KEY (`idSousType`)
    REFERENCES `discord_bot_rpg`.`itemssoustypes` (`idSousType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_RequiredSubtypeEquipped_Skills1`
    FOREIGN KEY (`idSkill`)
    REFERENCES `discord_bot_rpg`.`skills` (`idSkill`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`damagestypes` (
  `idDamageType` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `shorthand` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idDamageType`),
  UNIQUE INDEX `idDamageType_UNIQUE` (`idDamageType` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`damageinfo` (
  `idSkill` INT UNSIGNED NOT NULL,
  `idDamageType` INT UNSIGNED NOT NULL,
  `idElementType` INT UNSIGNED NULL DEFAULT NULL,
  `formula` VARCHAR(255) NOT NULL,
  `variance` TINYINT NOT NULL DEFAULT 0,
  `criticalHit` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`idSkill`),
  INDEX `fk_DamageInfo_DamagesTypes1_idx` (`idDamageType` ASC) VISIBLE,
  INDEX `fk_DamageInfo_ElementsTypes1_idx` (`idElementType` ASC) VISIBLE,
  CONSTRAINT `fk_DamageInfo_Skills1`
    FOREIGN KEY (`idSkill`)
    REFERENCES `discord_bot_rpg`.`skills` (`idSkill`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DamageInfo_DamagesTypes1`
    FOREIGN KEY (`idDamageType`)
    REFERENCES `discord_bot_rpg`.`damagestypes` (`idDamageType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DamageInfo_ElementsTypes1`
    FOREIGN KEY (`idElementType`)
    REFERENCES `discord_bot_rpg`.`elementstypes` (`idElementType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`effectstypes` (
  `idEffectType` INT NOT NULL,
  `shortname` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idEffectType`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`effectsskills` (
  `idEffectSkill` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idSkill` INT UNSIGNED NOT NULL,
  `idEffectType` INT NOT NULL,
  `percentageValue` FLOAT(11) NULL DEFAULT NULL,
  `fixedValue` INT NULL DEFAULT NULL,
  `stateValue` INT UNSIGNED NULL DEFAULT NULL,
  `statValue` INT UNSIGNED NULL DEFAULT NULL,
  `roundsValue` INT NULL DEFAULT NULL,
  INDEX `fk_EffectsSkills_Skills1_idx` (`idSkill` ASC) VISIBLE,
  INDEX `fk_EffectsSkills_EffectsTypes1_idx` (`idEffectType` ASC) VISIBLE,
  INDEX `fk_EffectsSkills_States1_idx` (`stateValue` ASC) VISIBLE,
  INDEX `fk_EffectsSkills_Stats1_idx` (`statValue` ASC) VISIBLE,
  PRIMARY KEY (`idEffectSkill`),
  UNIQUE INDEX `idEffectSkill_UNIQUE` (`idEffectSkill` ASC) VISIBLE,
  CONSTRAINT `fk_EffectsSkills_Skills1`
    FOREIGN KEY (`idSkill`)
    REFERENCES `discord_bot_rpg`.`skills` (`idSkill`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_EffectsSkills_EffectsTypes1`
    FOREIGN KEY (`idEffectType`)
    REFERENCES `discord_bot_rpg`.`effectstypes` (`idEffectType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_EffectsSkills_States1`
    FOREIGN KEY (`stateValue`)
    REFERENCES `discord_bot_rpg`.`states` (`idState`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_EffectsSkills_Stats1`
    FOREIGN KEY (`statValue`)
    REFERENCES `discord_bot_rpg`.`stats` (`idStat`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`secondarystats` (
  `idSecondaryStat` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(60) NOT NULL,
  `desc` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`idSecondaryStat`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE,
  UNIQUE INDEX `idSecondaryStat_UNIQUE` (`idSecondaryStat` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`itemssecondarystats` (
  `idItem` INT UNSIGNED NOT NULL,
  `idSecondaryStat` INT UNSIGNED NOT NULL,
  `value` INT NOT NULL,
  PRIMARY KEY (`idItem`, `idSecondaryStat`),
  INDEX `fk_ItemsSecondaryStats_SecondaryStats1_idx` (`idSecondaryStat` ASC) VISIBLE,
  CONSTRAINT `fk_ItemsSecondaryStats_Items1`
    FOREIGN KEY (`idItem`)
    REFERENCES `discord_bot_rpg`.`items` (`idItem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ItemsSecondaryStats_SecondaryStats1`
    FOREIGN KEY (`idSecondaryStat`)
    REFERENCES `discord_bot_rpg`.`secondarystats` (`idSecondaryStat`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`secondarystatsrepartition` (
  `idStatsProfil` INT UNSIGNED NOT NULL,
  `idSecondaryStat` INT UNSIGNED NOT NULL,
  `baseValue` INT NOT NULL,
  `multPerLevel` FLOAT NOT NULL DEFAULT 0.01,
  PRIMARY KEY (`idStatsProfil`, `idSecondaryStat`),
  INDEX `fk_SecondaryStatsRepartition_SecondaryStats1_idx` (`idSecondaryStat` ASC) VISIBLE,
  CONSTRAINT `fk_SecondaryStatsRepartition_StatsProfil1`
    FOREIGN KEY (`idStatsProfil`)
    REFERENCES `discord_bot_rpg`.`statsprofil` (`idStatsProfil`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SecondaryStatsRepartition_SecondaryStats1`
    FOREIGN KEY (`idSecondaryStat`)
    REFERENCES `discord_bot_rpg`.`secondarystats` (`idSecondaryStat`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

ALTER TABLE `discord_bot_rpg`.`ItemsStats` 
CHANGE COLUMN `value` `value` INT NOT NULL ;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`itemssecondarystatselementalresists` (
  `idItem` INT UNSIGNED NOT NULL,
  `idElementType` INT UNSIGNED NOT NULL,
  `value` FLOAT(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`idItem`, `idElementType`),
  INDEX `fk_ItemsSecondaryStatsElementalResists_ElementsTypes1_idx` (`idElementType` ASC) VISIBLE,
  CONSTRAINT `fk_ItemsSecondaryStatsElementalResists_Items1`
    FOREIGN KEY (`idItem`)
    REFERENCES `discord_bot_rpg`.`items` (`idItem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ItemsSecondaryStatsElementalResists_ElementsTypes1`
    FOREIGN KEY (`idElementType`)
    REFERENCES `discord_bot_rpg`.`elementstypes` (`idElementType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`secondarystatselementalresistsrepartition` (
  `idStatsProfil` INT UNSIGNED NOT NULL,
  `idElementType` INT UNSIGNED NOT NULL,
  `baseValue` INT NOT NULL DEFAULT 0,
  `multPerLevel` FLOAT(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`idStatsProfil`, `idElementType`),
  INDEX `fk_SecondaryStatsElementalResistsRepartition_StatsProfil1_idx` (`idStatsProfil` ASC) VISIBLE,
  CONSTRAINT `fk_SecondaryStatsElementalResistsRepartition_ElementsTypes1`
    FOREIGN KEY (`idElementType`)
    REFERENCES `discord_bot_rpg`.`elementstypes` (`idElementType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SecondaryStatsElementalResistsRepartition_StatsProfil1`
    FOREIGN KEY (`idStatsProfil`)
    REFERENCES `discord_bot_rpg`.`statsprofil` (`idStatsProfil`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`localizationskills` (
  `idSkill` INT UNSIGNED NOT NULL,
  `lang` VARCHAR(5) NOT NULL,
  `nameSkill` VARCHAR(255) NOT NULL,
  `descSkill` VARCHAR(255) NULL DEFAULT NULL,
  `messageSkill` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idSkill`, `lang`),
  INDEX `fk_LocalizationSkills_Languages1_idx` (`lang` ASC) VISIBLE,
  CONSTRAINT `fk_LocalizationSkills_Skills1`
    FOREIGN KEY (`idSkill`)
    REFERENCES `discord_bot_rpg`.`skills` (`idSkill`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_LocalizationSkills_Languages1`
    FOREIGN KEY (`lang`)
    REFERENCES `discord_bot_rpg`.`languages` (`lang`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`localizationstates` (
  `idState` INT UNSIGNED NOT NULL,
  `lang` VARCHAR(5) NOT NULL,
  `nameState` VARCHAR(255) NOT NULL,
  `descState` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`idState`, `lang`),
  INDEX `fk_LocalizationStates_Languages1_idx` (`lang` ASC) VISIBLE,
  CONSTRAINT `fk_LocalizationStates_States1`
    FOREIGN KEY (`idState`)
    REFERENCES `discord_bot_rpg`.`states` (`idState`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_LocalizationStates_Languages1`
    FOREIGN KEY (`lang`)
    REFERENCES `discord_bot_rpg`.`languages` (`lang`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`pstreepossiblesnodesvisuals` (
  `idNode` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `icon` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`idNode`),
  UNIQUE INDEX `idNode_UNIQUE` (`idNode` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`localizationnodespstree` (
  `idNode` INT UNSIGNED NOT NULL,
  `lang` VARCHAR(5) NOT NULL,
  `name` VARCHAR(64) NOT NULL,
  PRIMARY KEY (`idNode`, `lang`),
  INDEX `fk_LocalizationNodesPSTree_Languages1_idx` (`lang` ASC) VISIBLE,
  CONSTRAINT `fk_LocalizationNodesPSTree_PSTreePossiblesNodesVisuals1`
    FOREIGN KEY (`idNode`)
    REFERENCES `discord_bot_rpg`.`pstreepossiblesnodesvisuals` (`idNode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_LocalizationNodesPSTree_Languages1`
    FOREIGN KEY (`lang`)
    REFERENCES `discord_bot_rpg`.`languages` (`lang`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`pstreenodes` (
  `idNode` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idNodeVisual` INT UNSIGNED NULL,
  `x` FLOAT(11) NOT NULL,
  `y` FLOAT(11) NOT NULL,
  `cost` INT UNSIGNED NOT NULL DEFAULT 1,
  `isInitial` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`idNode`),
  INDEX `fk_PSTreeNodes_PSTreePossiblesNodesVisuals1_idx` (`idNodeVisual` ASC) VISIBLE,
  UNIQUE INDEX `idNode_UNIQUE` (`idNode` ASC) VISIBLE,
  CONSTRAINT `fk_PSTreeNodes_PSTreePossiblesNodesVisuals1`
    FOREIGN KEY (`idNodeVisual`)
    REFERENCES `discord_bot_rpg`.`pstreepossiblesnodesvisuals` (`idNode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`pstreenodesstatsdata` (
  `idNode` INT UNSIGNED NOT NULL,
  `idStat` INT UNSIGNED NOT NULL,
  `value` INT(11) NOT NULL,
  PRIMARY KEY (`idNode`, `idStat`),
  INDEX `fk_PSTreeNodesStatsData_Stats1_idx` (`idStat` ASC) VISIBLE,
  CONSTRAINT `fk_PSTreeNodesStatsData_PSTreeNodes1`
    FOREIGN KEY (`idNode`)
    REFERENCES `discord_bot_rpg`.`pstreenodes` (`idNode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PSTreeNodesStatsData_Stats1`
    FOREIGN KEY (`idStat`)
    REFERENCES `discord_bot_rpg`.`stats` (`idStat`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`pstreenodessecondarystatsdata` (
  `idNode` INT UNSIGNED NOT NULL,
  `idSecondaryStat` INT UNSIGNED NOT NULL,
  `value` INT(11) NOT NULL,
  PRIMARY KEY (`idNode`, `idSecondaryStat`),
  INDEX `fk_PSTreeNodesSecondaryStatsData_SecondaryStats1_idx` (`idSecondaryStat` ASC) VISIBLE,
  CONSTRAINT `fk_PSTreeNodesSecondaryStatsData_PSTreeNodes1`
    FOREIGN KEY (`idNode`)
    REFERENCES `discord_bot_rpg`.`pstreenodes` (`idNode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PSTreeNodesSecondaryStatsData_SecondaryStats1`
    FOREIGN KEY (`idSecondaryStat`)
    REFERENCES `discord_bot_rpg`.`secondarystats` (`idSecondaryStat`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`pstreenodessecondarystatselementalresistsdata` (
  `idNode` INT UNSIGNED NOT NULL,
  `idElementType` INT UNSIGNED NOT NULL,
  `value` INT NOT NULL,
  PRIMARY KEY (`idNode`, `idElementType`),
  INDEX `fk_PSTreeNodesSecondaryStatsElementalResistsData_ElementsTy_idx` (`idElementType` ASC) VISIBLE,
  CONSTRAINT `fk_PSTreeNodesSecondaryStatsElementalResistsData_PSTreeNodes1`
    FOREIGN KEY (`idNode`)
    REFERENCES `discord_bot_rpg`.`pstreenodes` (`idNode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PSTreeNodesSecondaryStatsElementalResistsData_ElementsTypes1`
    FOREIGN KEY (`idElementType`)
    REFERENCES `discord_bot_rpg`.`elementstypes` (`idElementType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`pstreenodesskillsunlockdata` (
  `idNode` INT UNSIGNED NOT NULL,
  `idSkill` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idNode`, `idSkill`),
  INDEX `fk_PSTreeNodesSkillsUnlockData_Skills1_idx` (`idSkill` ASC) VISIBLE,
  CONSTRAINT `fk_PSTreeNodesSkillsUnlockData_PSTreeNodes1`
    FOREIGN KEY (`idNode`)
    REFERENCES `discord_bot_rpg`.`pstreenodes` (`idNode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PSTreeNodesSkillsUnlockData_Skills1`
    FOREIGN KEY (`idSkill`)
    REFERENCES `discord_bot_rpg`.`skills` (`idSkill`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`pstreenodesstatesdata` (
  `idNode` INT UNSIGNED NOT NULL,
  `idState` INT UNSIGNED NOT NULL,  
  `isProtectedFrom` TINYINT NOT NULL DEFAULT 0,
  `isAdded` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`idNode`, `idState`),
  INDEX `fk_PSTreeNodesStatesData_States1_idx` (`idState` ASC) VISIBLE,
  CONSTRAINT `fk_PSTreeNodesStatesData_PSTreeNodes1`
    FOREIGN KEY (`idNode`)
    REFERENCES `discord_bot_rpg`.`pstreenodes` (`idNode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PSTreeNodesStatesData_States1`
    FOREIGN KEY (`idState`)
    REFERENCES `discord_bot_rpg`.`states` (`idState`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`pstreenodeslinks` (
  `idNodeParent` INT UNSIGNED NOT NULL,
  `PSTreeNodesChild` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idNodeParent`, `PSTreeNodesChild`),
  INDEX `fk_PSTreeNodesLinks_PSTreeNodes2_idx` (`PSTreeNodesChild` ASC) VISIBLE,
  CONSTRAINT `fk_PSTreeNodesLinks_PSTreeNodes1`
    FOREIGN KEY (`idNodeParent`)
    REFERENCES `discord_bot_rpg`.`pstreenodes` (`idNode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PSTreeNodesLinks_PSTreeNodes2`
    FOREIGN KEY (`PSTreeNodesChild`)
    REFERENCES `discord_bot_rpg`.`pstreenodes` (`idNode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`characterstalents` (
  `idCharacter` INT UNSIGNED NOT NULL,
  `idNode` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idCharacter`, `idNode`),
  INDEX `fk_CharactersTalents_PSTreeNodes1_idx` (`idNode` ASC) VISIBLE,
  CONSTRAINT `fk_CharactersTalents_Characters1`
    FOREIGN KEY (`idCharacter`)
    REFERENCES `discord_bot_rpg`.`characters` (`idCharacter`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CharactersTalents_PSTreeNodes1`
    FOREIGN KEY (`idNode`)
    REFERENCES `discord_bot_rpg`.`pstreenodes` (`idNode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`charactersbuilds` (
  `idCharacter` INT UNSIGNED NOT NULL,
  `idSkill` INT UNSIGNED NOT NULL,
  `priority` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (`idCharacter`, `idSkill`),
  INDEX `fk_CharactersBuilds_Skills1_idx` (`idSkill` ASC) VISIBLE,
  CONSTRAINT `fk_CharactersBuilds_Characters1`
    FOREIGN KEY (`idCharacter`)
    REFERENCES `discord_bot_rpg`.`characters` (`idCharacter`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CharactersBuilds_Skills1`
    FOREIGN KEY (`idSkill`)
    REFERENCES `discord_bot_rpg`.`skills` (`idSkill`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `discord_bot_rpg`.`MonstersBuildsProfil`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`monstersbuildsprofil` (
  `idMonstersBuildsProfil` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  PRIMARY KEY (`idMonstersBuildsProfil`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `discord_bot_rpg`.`MonstersBuilds`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `discord_bot_rpg`.`monstersbuilds` (
  `idMonstersBuildsProfil` INT UNSIGNED NOT NULL,
  `idSkill` INT UNSIGNED NOT NULL,
  `priority` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`idMonstersBuildsProfil`, `idSkill`),
  INDEX `fk_MonstersBuilds_Skills1_idx` (`idSkill` ASC) VISIBLE,
  INDEX `fk_MonstersBuilds_MonstersBuildsProfil1_idx` (`idMonstersBuildsProfil` ASC) VISIBLE,
  CONSTRAINT `fk_MonstersBuilds_Skills1`
    FOREIGN KEY (`idSkill`)
    REFERENCES `discord_bot_rpg`.`skills` (`idSkill`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_MonstersBuilds_MonstersBuildsProfil1`
    FOREIGN KEY (`idMonstersBuildsProfil`)
    REFERENCES `discord_bot_rpg`.`monstersbuildsprofil` (`idMonstersBuildsProfil`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

ALTER TABLE `discord_bot_rpg`.`statsmonstres` 
ADD COLUMN `idMonstersBuildsProfil` INT(10) UNSIGNED NOT NULL AFTER `idStatsProfil`,
ADD INDEX `fk_StatsMonstres_MonstersBuildsProfil1_idx` (`idMonstersBuildsProfil` ASC) VISIBLE;
;

ALTER TABLE `discord_bot_rpg`.`statsmonstres` 
ADD CONSTRAINT `fk_StatsMonstres_MonstersBuildsProfil1`
  FOREIGN KEY (`idMonstersBuildsProfil`)
  REFERENCES `discord_bot_rpg`.`monstersbuildsprofil` (`idMonstersBuildsProfil`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;








INSERT INTO statesrestrictions
VALUES
(1, "cant_target_enemy"),(2, "cant_target_ally"),(3, "cant_target_self"),(4, "cant_target_do_anything");


INSERT INTO traitstypes
VALUES
(1,	"element_attack"),
(2,	"state_attack"),
(3,	"stats_param"),
(4,	"element_rate"),
(5,	"stats_debuff"),
(6,	"state_debuff"),
(7,	"state_resist"),
(8,	"quiet_skill"),
(9, "secondary_stats_debuff"),
(10, "quiet_specific_skill"),
(11, "secondary_stats");

INSERT INTO skillstypes
VALUES
(1,	"magic"),
(2,	"special");

INSERT INTO attackstypes
VALUES
(1,	"sure"),
(2,	"physical"),
(3,	"magical");

INSERT INTO elementstypes
VALUES
(1, "physical"),
(2, "fire"),
(3, "water"),
(4, "earth"),
(5, "air"),
(6, "dark"),
(7,	"light");

INSERT INTO targetrange 
VALUES
(1,	"all_enemies"),
(2,	"1_random_enemy"),
(3,	"2_random_enemy"),
(4,	"3_random_enemy"),
(5,	"4_random_enemy"),
(6,	"1_random_ally"),
(7,	"2_random_ally"),
(8,	"3_random_ally"),
(9,	"all_allies"),
(10, "1_random_ally_dead"),
(11, "3_random_ally_dead"),
(12, "3_random_ally_dead"),
(13, "all_allies_dead"),
(14,"caster");

INSERT INTO effectstypes
VALUES
(1, "hpHeal"),
(2, "manaHeal"),
(3, "energyHeal"),
(4, "addState"),
(5, "removeState");

REPLACE INTO damagestypes
VALUES
(1, "hpDamage"),
(2, "manaDamage"),
(3, "healHp"),
(4, "healMp"),
(5, "lifeSteal"),
(6, "manaSteal");

REPLACE INTO secondarystats
VALUES 
(1, "hitRate", ""),
(2, "evadeRate", ""),
(3, "criticalRate", ""),
(4, "regenHp", ""),
(5, "regenMp", ""),
(6, "regenEnergy", ""),
(7, "skillManaCost", ""),
(8, "skillEnergyCost", ""),
(9, "criticalEvadeRate", ""),
(10, "magicalEvadeRate", ""),
(11, "threat", "");

REPLACE INTO itemssoustypes 
VALUES
(6, "metal"),
(18, "cloth"),
(19, "leather"),
(20, "bow"),
(21, "dagger"),
(22, "wand"),
(23, "staff");

INSERT INTO languages 
VALUES
("vi");

INSERT INTO `pstreepossiblesnodesvisuals` (`idNode`, `icon`) VALUES
(1, 'https://i.ibb.co/M8jsQ39/sword-strength.png'),
(2, 'https://i.ibb.co/q9sJ3Pb/constitution.png'),
(3, 'https://i.ibb.co/FVzwrp7/perception.png'),
(4, 'https://i.ibb.co/KVg1M3x/armor-energy.png'),
(5, 'https://i.ibb.co/qkZKBCV/breack-shield.png'),
(6, 'https://i.ibb.co/4g7j22Z/break-sword.png'),
(7, 'https://i.ibb.co/QPqfDXg/crossed-swords.png'),
(8, 'https://i.ibb.co/DQcFrBW/flag.png'),
(9, 'https://i.ibb.co/b1wbyB8/helmet-eye.png'),
(10, 'https://i.ibb.co/6s89w3x/multi-swords.png'),
(11, 'https://i.ibb.co/VN7NgwR/punch.png'),
(12, 'https://i.ibb.co/4TpYVfc/running.png'),
(13, 'https://i.ibb.co/58JKYBh/shield.png'),
(14, 'https://i.ibb.co/VHqRRfX/sword-skull.png'),
(15, 'https://i.ibb.co/hdz9JTY/taunt.png'),
(16, 'https://i.ibb.co/BGPdX6z/tornado.png'),
(17, 'https://i.ibb.co/sttMb8M/winner-cup.png'),
(18, 'https://i.ibb.co/Z1pzB8Z/Archer-Arrow-rain.png'),
(19, 'https://i.ibb.co/MsxtG2R/Archer-Charge-shot-2.png'),
(20, 'https://i.ibb.co/wCfYjP6/Archer-Charge-shot-3.png'),
(21, 'https://i.ibb.co/khGtk9w/Archer-lunge.png'),
(22, 'https://i.ibb.co/mCRwHgy/Flame-Blue.png'),
(23, 'https://i.ibb.co/8sHXydJ/Flame-Green.png'),
(24, 'https://i.ibb.co/C0jwt23/Flame-Original.png'),
(25, 'https://i.ibb.co/KDHfWQR/Samurai-Anger.png'),
(26, 'https://i.ibb.co/jyWF3xg/Samurai-Flower-vortex.png'),
(27, 'https://i.ibb.co/zStWvqw/Samurai-Prick.png'),
(28, 'https://i.ibb.co/8Dww2Vd/Samurai-Sword-Strike.png'),
(29, 'https://i.ibb.co/F8FsDGy/Archer-a-crack-shot.png'),
(30, 'https://i.ibb.co/7QHrwSt/Archer-a-small-arrow-shot-by-a-archer.png'),
(31, 'https://i.ibb.co/FqNj2Xh/Wizard-Dragon-Summon.png'),
(32, 'https://i.ibb.co/30xCBv7/Wizard-Finale.png'),
(33, 'https://i.ibb.co/zPnHBBk/Wizard-lightning-bolt.png'),
(34, 'https://i.ibb.co/L9GbmR5/Wizard-Spatial-distortion.png'),
(35, 'https://i.ibb.co/59ffkDP/Wizard-Trick.png'),
(36, 'https://i.ibb.co/N7qZqPk/Thief-Assassination.png'),
(37, 'https://i.ibb.co/F6C1kMq/battle-cry.png'),
(38, 'https://i.ibb.co/fDTmYS2/break-shield2.png'),
(39, 'https://i.ibb.co/x8hvy85/bullets.png'),
(40, 'https://i.ibb.co/c102RLm/dark-orb.png'),
(41, 'https://i.ibb.co/BcrQyqF/dead-hand.png'),
(42, 'https://i.ibb.co/KjFfFhY/eagle-claw.png'),
(43, 'https://i.ibb.co/w0GfKzy/eat.png'),
(44, 'https://i.ibb.co/cgCZ7tm/fire-attack.png'),
(45, 'https://i.ibb.co/sCL4YVP/fireball.png'),
(46, 'https://i.ibb.co/cxszLjG/heal.png'),
(47, 'https://i.ibb.co/tQ57ym5/hide-bush.png'),
(48, 'https://i.ibb.co/fXVFfyY/ice-block.png'),
(49, 'https://i.ibb.co/8MCQGkN/ice-shards.png'),
(50, 'https://i.ibb.co/Wv2YCVc/light-ray.png'),
(51, 'https://i.ibb.co/68yjbmv/lightning-blue.png'),
(52, 'https://i.ibb.co/hVdkw4w/lightning-purple.png'),
(53, 'https://i.ibb.co/VTSSt2X/meteor-blue.png'),
(54, 'https://i.ibb.co/b27LGV0/shield2.png'),
(55, 'https://i.ibb.co/R6PbF74/spider.png'),
(56, 'https://i.ibb.co/GTDxqth/star-purple.png'),
(57, 'https://i.ibb.co/k64vhWz/target-short.png'),
(58, 'https://i.ibb.co/mHTbWMw/thorns.png'),
(59, 'https://i.ibb.co/q0DGbvd/tornado.png'),
(60, 'https://i.ibb.co/LdB8SM9/venom.png'),
(61, 'https://i.ibb.co/LJM2fdw/world.png');

REPLACE INTO `localizationnodespstree` (`idNode`, `lang`, `name`) VALUES
(1, 'en', 'Strength'),
(1, 'es', 'Strength'),
(1, 'fr', 'Strength'),
(1, 'pt-BR', 'Strength'),
(1, 'ru', 'Strength'),
(1, 'vi', 'Strength'),
(2, 'en', 'Constitution'),
(2, 'es', 'Constitution'),
(2, 'fr', 'Constitution'),
(2, 'pt-BR', 'Constitution'),
(2, 'ru', 'Constitution'),
(2, 'vi', 'Constitution'),
(3, 'en', 'Perception'),
(3, 'es', 'Perception'),
(3, 'fr', 'Perception'),
(3, 'pt-BR', 'Perception'),
(3, 'ru', 'Perception'),
(3, 'vi', 'Perception'),
(4, 'en', 'Energy 1'),
(4, 'es', 'Energy 1'),
(4, 'fr', 'Energy 1'),
(4, 'pt-BR', 'Energy 1'),
(4, 'ru', 'Energy 1'),
(4, 'vi', 'Energy 1'),
(5, 'en', 'Break Shield'),
(5, 'es', 'Break Shield'),
(5, 'fr', 'Break Shield'),
(5, 'pt-BR', 'Break Shield'),
(5, 'ru', 'Break Shield'),
(5, 'vi', 'Break Shield'),
(6, 'en', 'Break Sword'),
(6, 'es', 'Break Sword'),
(6, 'fr', 'Break Sword'),
(6, 'pt-BR', 'Break Sword'),
(6, 'ru', 'Break Sword'),
(6, 'vi', 'Break Sword'),
(7, 'en', 'Crossed Swords'),
(7, 'es', 'Crossed Swords'),
(7, 'fr', 'Crossed Swords'),
(7, 'pt-BR', 'Crossed Swords'),
(7, 'ru', 'Crossed Swords'),
(7, 'vi', 'Crossed Swords'),
(8, 'en', 'Flag 1'),
(8, 'es', 'Flag 1'),
(8, 'fr', 'Flag 1'),
(8, 'pt-BR', 'Flag 1'),
(8, 'ru', 'Flag 1'),
(8, 'vi', 'Flag 1'),
(9, 'en', 'Helmet Eye'),
(9, 'es', 'Helmet Eye'),
(9, 'fr', 'Helmet Eye'),
(9, 'pt-BR', 'Helmet Eye'),
(9, 'ru', 'Helmet Eye'),
(9, 'vi', 'Helmet Eye'),
(10, 'en', 'Multi Swords'),
(10, 'es', 'Multi Swords'),
(10, 'fr', 'Multi Swords'),
(10, 'pt-BR', 'Multi Swords'),
(10, 'ru', 'Multi Swords'),
(10, 'vi', 'Multi Swords'),
(11, 'en', 'Punch'),
(11, 'es', 'Punch'),
(11, 'fr', 'Punch'),
(11, 'pt-BR', 'Punch'),
(11, 'ru', 'Punch'),
(11, 'vi', 'Punch'),
(12, 'en', 'Running'),
(12, 'es', 'Running'),
(12, 'fr', 'Running'),
(12, 'pt-BR', 'Running'),
(12, 'ru', 'Running'),
(12, 'vi', 'Running'),
(13, 'en', 'Shield'),
(13, 'es', 'Shield'),
(13, 'fr', 'Shield'),
(13, 'pt-BR', 'Shield'),
(13, 'ru', 'Shield'),
(13, 'vi', 'Shield'),
(14, 'en', 'Sword Skull'),
(14, 'es', 'Sword Skull'),
(14, 'fr', 'Sword Skull'),
(14, 'pt-BR', 'Sword Skull'),
(14, 'ru', 'Sword Skull'),
(14, 'vi', 'Sword Skull'),
(15, 'en', 'Taunt'),
(15, 'es', 'Taunt'),
(15, 'fr', 'Taunt'),
(15, 'pt-BR', 'Taunt'),
(15, 'ru', 'Taunt'),
(15, 'vi', 'Taunt'),
(16, 'en', 'Tornado'),
(16, 'es', 'Tornado'),
(16, 'fr', 'Tornado'),
(16, 'pt-BR', 'Tornado'),
(16, 'ru', 'Tornado'),
(16, 'vi', 'Tornado'),
(17, 'en', 'Winner Cup'),
(17, 'es', 'Winner Cup'),
(17, 'fr', 'Winner Cup'),
(17, 'pt-BR', 'Winner Cup'),
(17, 'ru', 'Winner Cup'),
(17, 'vi', 'Winner Cup'),
(18, 'en', 'Rain Arrow'),
(18, 'es', 'Rain Arrow'),
(18, 'fr', 'Rain Arrow'),
(18, 'pt-BR', 'Rain Arrow'),
(18, 'ru', 'Rain Arrow'),
(18, 'vi', 'Rain Arrow'),
(19, 'en', 'Charge Shot 1'),
(19, 'es', 'Charge Shot 1'),
(19, 'fr', 'Charge Shot 1'),
(19, 'pt-BR', 'Charge Shot 1'),
(19, 'ru', 'Charge Shot 1'),
(19, 'vi', 'Charge Shot 1'),
(20, 'en', 'Charge Shot 2'),
(20, 'es', 'Charge Shot 2'),
(20, 'fr', 'Charge Shot 2'),
(20, 'pt-BR', 'Charge Shot 2'),
(20, 'ru', 'Charge Shot 2'),
(20, 'vi', 'Charge Shot 2'),
(21, 'en', 'Dash Archer'),
(21, 'es', 'Dash Archer'),
(21, 'fr', 'Dash Archer'),
(21, 'pt-BR', 'Dash Archer'),
(21, 'ru', 'Dash Archer'),
(21, 'vi', 'Dash Archer'),
(22, 'en', 'Flame Blue'),
(22, 'es', 'Flame Blue'),
(22, 'fr', 'Flame Blue'),
(22, 'pt-BR', 'Flame Blue'),
(22, 'ru', 'Flame Blue'),
(22, 'vi', 'Flame Blue'),
(23, 'en', 'Flame Green'),
(23, 'es', 'Flame Green'),
(23, 'fr', 'Flame Green'),
(23, 'pt-BR', 'Flame Green'),
(23, 'ru', 'Flame Green'),
(23, 'vi', 'Flame Green'),
(24, 'en', 'Flame Red'),
(24, 'es', 'Flame Red'),
(24, 'fr', 'Flame Red'),
(24, 'pt-BR', 'Flame Red'),
(24, 'ru', 'Flame Red'),
(24, 'vi', 'Flame Red'),
(25, 'en', 'Anger 1'),
(25, 'es', 'Anger 1'),
(25, 'fr', 'Anger 1'),
(25, 'pt-BR', 'Anger 1'),
(25, 'ru', 'Anger 1'),
(25, 'vi', 'Anger 1'),
(26, 'en', 'Flower Vortex'),
(26, 'es', 'Flower Vortex'),
(26, 'fr', 'Flower Vortex'),
(26, 'pt-BR', 'Flower Vortex'),
(26, 'ru', 'Flower Vortex'),
(26, 'vi', 'Flower Vortex'),
(27, 'en', 'Sword 1'),
(27, 'es', 'Sword 1'),
(27, 'fr', 'Sword 1'),
(27, 'pt-BR', 'Sword 1'),
(27, 'ru', 'Sword 1'),
(27, 'vi', 'Sword 1'),
(28, 'en', 'Sword 2'),
(28, 'es', 'Sword 2'),
(28, 'fr', 'Sword 2'),
(28, 'pt-BR', 'Sword 2'),
(28, 'ru', 'Sword 2'),
(28, 'vi', 'Sword 2'),
(29, 'en', 'Crack Shot'),
(29, 'es', 'Crack Shot'),
(29, 'fr', 'Crack Shot'),
(29, 'pt-BR', 'Crack Shot'),
(29, 'ru', 'Crack Shot'),
(29, 'vi', 'Crack Shot'),
(30, 'en', 'Archer Shot'),
(30, 'es', 'Archer Shot'),
(30, 'fr', 'Archer Shot'),
(30, 'pt-BR', 'Archer Shot'),
(30, 'ru', 'Archer Shot'),
(30, 'vi', 'Archer Shot'),
(31, 'en', 'Dragon Summon'),
(31, 'es', 'Dragon Summon'),
(31, 'fr', 'Dragon Summon'),
(31, 'pt-BR', 'Dragon Summon'),
(31, 'ru', 'Dragon Summon'),
(31, 'vi', 'Dragon Summon'),
(32, 'en', 'Sparks'),
(32, 'es', 'Sparks'),
(32, 'fr', 'Sparks'),
(32, 'pt-BR', 'Sparks'),
(32, 'ru', 'Sparks'),
(32, 'vi', 'Sparks'),
(33, 'en', 'Lightning Bolt 1'),
(33, 'es', 'Lightning Bolt 1'),
(33, 'fr', 'Lightning Bolt 1'),
(33, 'pt-BR', 'Lightning Bolt 1'),
(33, 'ru', 'Lightning Bolt 1'),
(33, 'vi', 'Lightning Bolt 1'),
(34, 'en', 'Wizard Power'),
(34, 'es', 'Wizard Power'),
(34, 'fr', 'Wizard Power'),
(34, 'pt-BR', 'Wizard Power'),
(34, 'ru', 'Wizard Power'),
(34, 'vi', 'Wizard Power'),
(35, 'en', 'Wizard Thing'),
(35, 'es', 'Wizard Thing'),
(35, 'fr', 'Wizard Thing'),
(35, 'pt-BR', 'Wizard Thing'),
(35, 'ru', 'Wizard Thing'),
(35, 'vi', 'Wizard Thing'),
(36, 'en', 'Assassinate'),
(36, 'es', 'Assassinate'),
(36, 'fr', 'Assassinate'),
(36, 'pt-BR', 'Assassinate'),
(36, 'ru', 'Assassinate'),
(36, 'vi', 'Assassinate'),
(37, 'en', 'Battle Cry'),
(37, 'es', 'Battle Cry'),
(37, 'fr', 'Battle Cry'),
(37, 'pt-BR', 'Battle Cry'),
(37, 'ru', 'Battle Cry'),
(37, 'vi', 'Battle Cry'),
(38, 'en', 'Break Shield 2'),
(38, 'es', 'Break Shield 2'),
(38, 'fr', 'Break Shield 2'),
(38, 'pt-BR', 'Break Shield 2'),
(38, 'ru', 'Break Shield 2'),
(38, 'vi', 'Break Shield 2'),
(39, 'en', 'Bullets'),
(39, 'es', 'Bullets'),
(39, 'fr', 'Bullets'),
(39, 'pt-BR', 'Bullets'),
(39, 'ru', 'Bullets'),
(39, 'vi', 'Bullets'),
(40, 'en', 'Dark Orb'),
(40, 'es', 'Dark Orb'),
(40, 'fr', 'Dark Orb'),
(40, 'pt-BR', 'Dark Orb'),
(40, 'ru', 'Dark Orb'),
(40, 'vi', 'Dark Orb'),
(41, 'en', 'Dead Hand'),
(41, 'es', 'Dead Hand'),
(41, 'fr', 'Dead Hand'),
(41, 'pt-BR', 'Dead Hand'),
(41, 'ru', 'Dead Hand'),
(41, 'vi', 'Dead Hand'),
(42, 'en', 'Eagle Claw'),
(42, 'es', 'Eagle Claw'),
(42, 'fr', 'Eagle Claw'),
(42, 'pt-BR', 'Eagle Claw'),
(42, 'ru', 'Eagle Claw'),
(42, 'vi', 'Eagle Claw'),
(43, 'en', 'Eat'),
(43, 'es', 'Eat'),
(43, 'fr', 'Eat'),
(43, 'pt-BR', 'Eat'),
(43, 'ru', 'Eat'),
(43, 'vi', 'Eat'),
(44, 'en', 'Fire Magic Strike'),
(44, 'es', 'Fire Magic Strike'),
(44, 'fr', 'Fire Magic Strike'),
(44, 'pt-BR', 'Fire Magic Strike'),
(44, 'ru', 'Fire Magic Strike'),
(44, 'vi', 'Fire Magic Strike'),
(45, 'en', 'Fireball'),
(46, 'en', 'Heal 1'),
(47, 'en', 'Hide In Bush'),
(48, 'en', 'Ice Block'),
(49, 'en', 'Ice Shards'),
(50, 'en', 'Light Ray'),
(51, 'en', 'Lightning Blue'),
(52, 'en', 'Lightning Purple'),
(53, 'en', 'Meteor Blue'),
(54, 'en', 'Shield 2'),
(55, 'en', 'Spider'),
(56, 'en', 'Starfall Purple'),
(57, 'en', 'Target Shot'),
(58, 'en', 'Thorns'),
(59, 'en', 'Tornado'),
(60, 'en', 'Venom'),
(61, 'en', 'Wolf');


REPLACE INTO statsprofil VALUES
(1, "balance_low"),

(2, "elemental_strength_fire"),
(3, "elemental_strength_water"),
(4, "elemental_strength_earth"),
(5, "elemental_strength_wind"),

(6, "elemental_magical_fire"),
(7, "elemental_magical_water"),
(8, "elemental_magical_earth"),
(9, "elemental_magical_wind"),

(10, "elemental_dexterity_fire"),
(11, "elemental_dexterity_water"),
(12, "elemental_dexterity_earth"),
(13, "elemental_dexterity_wind"),

(14, "tank_strength"),
(15, "tank_stun"),
(16, "balance"),

(17, "mage_healer_intellect"),
(18, "dexterity");

REPLACE INTO secondarystatsrepartition VALUES
(1, 1, 100, 0),   
(1, 2, 0, 0),     
(1, 3, 0, 0),     
(1, 4, 0, 0),     
(1, 5, 0, 0),     
(1, 6, 5, 0),     
(1, 7, 0, 0),     
(1, 8, 0, 0),     
(1, 9, 0, 0),     
(1, 10, 0, 0),    
(1, 11, 0, 0),    

(2, 1, 100, 0),   
(2, 2, 0, 0),     
(2, 3, 0, 0),     
(2, 4, 1, 0.1),   
(2, 5, 1, 0.1),   
(2, 6, 5, 0),     
(2, 7, 0, 0),     
(2, 8, 0, 0),     
(2, 9, 0, 0),     
(2, 10, 0, 0),    
(2, 11, 0, 0),    

(3, 1, 100, 0),   
(3, 2, 0, 0),     
(3, 3, 0, 0),     
(3, 4, 1, 0.1),   
(3, 5, 1, 0.1),   
(3, 6, 5, 0),     
(3, 7, 0, 0),     
(3, 8, 0, 0),     
(3, 9, 0, 0),     
(3, 10, 0, 0),    
(3, 11, 0, 0),    

(4, 1, 100, 0),   
(4, 2, 0, 0),     
(4, 3, 0, 0),     
(4, 4, 1, 0.1),   
(4, 5, 1, 0.1),   
(4, 6, 5, 0),     
(4, 7, 0, 0),     
(4, 8, 0, 0),     
(4, 9, 0, 0),     
(4, 10, 0, 0),    
(4, 11, 0, 0),    

(5, 1, 100, 0),   
(5, 2, 0, 0),     
(5, 3, 0, 0),     
(5, 4, 1, 0.1),   
(5, 5, 1, 0.1),   
(5, 6, 5, 0),     
(5, 7, 0, 0),     
(5, 8, 0, 0),     
(5, 9, 0, 0),     
(5, 10, 0, 0),    
(5, 11, 0, 0),    

(6, 1, 100, 0),   
(6, 2, 0, 0),     
(6, 3, 0, 0),     
(6, 4, 0, 0),     
(6, 5, 1, 0.1),   
(6, 6, 5, 0),     
(6, 7, 0, 0),     
(6, 8, 0, 0),     
(6, 9, 0, 0),     
(6, 10, 5, 0),    
(6, 11, 0, 0),    

(7, 1, 100, 0),   
(7, 2, 0, 0),     
(7, 3, 0, 0),     
(7, 4, 0, 0),     
(7, 5, 1, 0.1),   
(7, 6, 5, 0),     
(7, 7, 0, 0),     
(7, 8, 0, 0),     
(7, 9, 0, 0),     
(7, 10, 5, 0),    
(7, 11, 0, 0),    

(8, 1, 100, 0),   
(8, 2, 0, 0),     
(8, 3, 0, 0),     
(8, 4, 0, 0),     
(8, 5, 1, 0.1),   
(8, 6, 5, 0),     
(8, 7, 0, 0),     
(8, 8, 0, 0),     
(8, 9, 0, 0),     
(8, 10, 5, 0),    
(8, 11, 0, 0),    

(9, 1, 100, 0),   
(9, 2, 0, 0),     
(9, 3, 0, 0),     
(9, 4, 0, 0),     
(9, 5, 1, 0.1),   
(9, 6, 5, 0),     
(9, 7, 0, 0),     
(9, 8, 0, 0),     
(9, 9, 0, 0),     
(9, 10, 5, 0),    
(9, 11, 0, 0),    

(10, 1, 100, 0),  
(10, 2, 30, 0),   
(10, 3, 30, 0),   
(10, 4, 0, 0),    
(10, 5, 5, 0.05), 
(10, 6, 15, 0),   
(10, 7, 0, 0),    
(10, 8, 0, 0),    
(10, 9, 15, 0),   
(10, 10, 0, 0),   
(10, 11, 0, 0),   

(11, 1, 100, 0),  
(11, 2, 30, 0),   
(11, 3, 30, 0),   
(11, 4, 0, 0),    
(11, 5, 5, 0.05), 
(11, 6, 15, 0),   
(11, 7, 0, 0),    
(11, 8, 0, 0),    
(11, 9, 15, 0),   
(11, 10, 0, 0),   
(11, 11, 0, 0),   

(12, 1, 100, 0),  
(12, 2, 30, 0),   
(12, 3, 30, 0),   
(12, 4, 0, 0),    
(12, 5, 5, 0.05), 
(12, 6, 15, 0),   
(12, 7, 0, 0),    
(12, 8, 0, 0),    
(12, 9, 15, 0),   
(12, 10, 0, 0),   
(12, 11, 0, 0),   

(13, 1, 100, 0),  
(13, 2, 30, 0),   
(13, 3, 30, 0),   
(13, 4, 0, 0),    
(13, 5, 5, 0.05), 
(13, 6, 15, 0),   
(13, 7, 0, 0),    
(13, 8, 0, 0),    
(13, 9, 15, 0),   
(13, 10, 0, 0),   
(13, 11, 0, 0),   

(14, 1, 100, 0),  
(14, 2, 0, 0),    
(14, 3, 0, 0),    
(14, 4, 0, 0),    
(14, 5, 0, 0),    
(14, 6, 5, 0),    
(14, 7, 0, 0),    
(14, 8, 0, 0),    
(14, 9, 0, 0),    
(14, 10, 0, 0),   
(14, 11, 7, 0),   

(15, 1, 100, 0),  
(15, 2, 0, 0),    
(15, 3, 0, 0),    
(15, 4, 0, 0),    
(15, 5, 0, 0),    
(15, 6, 5, 0),    
(15, 7, 0, 0),    
(15, 8, 0, 0),    
(15, 9, 0, 0),    
(15, 10, 0, 0),   
(15, 11, 7, 0),   

(16, 1, 100, 0),  
(16, 2, 0, 0),    
(16, 3, 0, 0),    
(16, 4, 1, 0.2),  
(16, 5, 1, 0.2),  
(16, 6, 5, 0),    
(16, 7, 0, 0),    
(16, 8, 0, 0),    
(16, 9, 0, 0),    
(16, 10, 0, 0),   
(16, 11, 7, 0),

(17, 1, 100, 0),  
(17, 2, 0, 0),    
(17, 3, 0, 0),    
(17, 4, 0, 0),  
(17, 5, 3, 0.2),  
(17, 6, 5, 0),    
(17, 7, 5, 0),    
(17, 8, 0, 0),    
(17, 9, 0, 0),    
(17, 10, 10, 0),   
(17, 11, 0, 0),

(18, 1, 110, 0),  
(18, 2, 10, 0),    
(18, 3, 20, 0),    
(18, 4, 0, 0),  
(18, 5, 0, 0),  
(18, 6, 10, 0),    
(18, 7, 0, 0),    
(18, 8, 5, 0),    
(18, 9, 5, 0),    
(18, 10, 0, 0),   
(18, 11, 0, 0);

REPLACE INTO secondarystatselementalresistsrepartition VALUES
(1, 1, 0, 0),      
(1, 2, 0, 0),      
(1, 3, 0, 0),      
(1, 4, 0, 0),      
(1, 5, 0, 0),      
(1, 6, 0, 0),      
(1, 7, 0, 0),      

(2, 1, 0, 0),      
(2, 2, 50, 0),     
(2, 3, -100, 0),   
(2, 4, 0, 0),      
(2, 5, 0, 0),      
(2, 6, 0, 0),      
(2, 7, 0, 0),      

(6, 1, 0, 0),      
(6, 2, 50, 0),     
(6, 3, -100, 0),   
(6, 4, 0, 0),      
(6, 5, 0, 0),      
(6, 6, 0, 0),      
(6, 7, 0, 0),      

(10, 1, 0, 0),     
(10, 2, 50, 0),    
(10, 3, -100, 0),  
(10, 4, 0, 0),     
(10, 5, 0, 0),     
(10, 6, 0, 0),     
(10, 7, 0, 0),     

(3, 1, 0, 0),      
(3, 2, 0, 0),      
(3, 3, 50, 0),     
(3, 4, -100, 0),   
(3, 5, 0, 0),      
(3, 6, 0, 0),      
(3, 7, 0, 0),      

(7, 1, 0, 0),      
(7, 2, 0, 0),      
(7, 3, 50, 0),     
(7, 4, -100, 0),   
(7, 5, 0, 0),      
(7, 6, 0, 0),      
(7, 7, 0, 0),      

(11, 1, 0, 0),     
(11, 2, 0, 0),     
(11, 3, 50, 0),    
(11, 4, -100, 0),  
(11, 5, 0, 0),     
(11, 6, 0, 0),     
(11, 7, 0, 0),     

(4, 1, 0, 0),      
(4, 2, 0, 0),      
(4, 3, 0, 0),      
(4, 4, 50, 0),     
(4, 5, -100, 0),   
(4, 6, 0, 0),      
(4, 7, 0, 0),      

(8, 1, 0, 0),      
(8, 2, 0, 0),      
(8, 3, 0, 0),      
(8, 4, 50, 0),     
(8, 5, -100, 0),   
(8, 6, 0, 0),      
(8, 7, 0, 0),      

(12, 1, 0, 0),     
(12, 2, 0, 0),     
(12, 3, 0, 0),     
(12, 4, 50, 0),    
(12, 5, -100, 0),  
(12, 6, 0, 0),     
(12, 7, 0, 0),     

(5, 1, 0, 0),      
(5, 2, -100, 0),   
(5, 3, 0, 0),      
(5, 4, 0, 0),      
(5, 5, 50, 0),     
(5, 6, 0, 0),      
(5, 7, 0, 0),      

(9, 1, 0, 0),      
(9, 2, -100, 0),   
(9, 3, 0, 0),      
(9, 4, 0, 0),      
(9, 5, 50, 0),     
(9, 6, 0, 0),      
(9, 7, 0, 0),      

(13, 1, 0, 0),     
(13, 2, -100, 0),  
(13, 3, 0, 0),     
(13, 4, 0, 0),     
(13, 5, 50, 0),    
(13, 6, 0, 0),     
(13, 7, 0, 0),     

(14, 1, 8, 0),     
(14, 2, 20, 0),    
(14, 3, 20, 0),    
(14, 4, 20, 0),    
(14, 5, 20, 0),    
(14, 6, 20, 0),    
(14, 7, 20, 0),    

(15, 1, 8, 0),     
(15, 2, 20, 0),    
(15, 3, 20, 0),    
(15, 4, 20, 0),    
(15, 5, 20, 0),    
(15, 6, 20, 0),    
(15, 7, 20, 0),    

(16, 1, 0, 0),     
(16, 2, 5, 0),     
(16, 3, 5, 0),     
(16, 4, 5, 0),     
(16, 5, 5, 0),     
(16, 6, 5, 0),     
(16, 7, 5, 0),

(17, 1, -30, 0),     
(17, 2, 10, 0),     
(17, 3, 10, 0),     
(17, 4, 10, 0),     
(17, 5, 10, 0),     
(17, 6, 10, 0),     
(17, 7, 10, 0),

(18, 1, 10, 0),     
(18, 2, 0, 0),     
(18, 3, 0, 0),     
(18, 4, 0, 0),     
(18, 5, 0, 0),     
(18, 6, 0, 0),     
(18, 7, 0, 0);




REPLACE INTO statsrepartition VALUES
(1, 1, 5),         
(1, 2, 0),         
(1, 3, 5),         
(1, 4, 10),        
(1, 5, 0),         
(1, 6, 0),         
(1, 7, 0),         
(1, 8, 0),         
(1, 9, 0),         
(1, 10, 0),        

(2, 1, 60),        
(2, 2, 0),         
(2, 3, 40),        
(2, 4, 40),        
(2, 5, 0),         
(2, 6, 30),        
(2, 7, 0),         
(2, 8, 0),         
(2, 9, 0),         
(2, 10, 0),        

(3, 1, 60),        
(3, 2, 0),         
(3, 3, 40),        
(3, 4, 40),        
(3, 5, 0),         
(3, 6, 30),        
(3, 7, 0),         
(3, 8, 0),         
(3, 9, 0),         
(3, 10, 0),        

(4, 1, 60),        
(4, 2, 0),         
(4, 3, 40),        
(4, 4, 40),        
(4, 5, 0),         
(4, 6, 30),        
(4, 7, 0),         
(4, 8, 0),         
(4, 9, 0),         
(4, 10, 0),        

(5, 1, 60),        
(5, 2, 0),         
(5, 3, 40),        
(5, 4, 40),        
(5, 5, 0),         
(5, 6, 30),        
(5, 7, 0),         
(5, 8, 0),         
(5, 9, 0),         
(5, 10, 0),        

(6, 1, 0),         
(6, 2, 60),        
(6, 3, 40),        
(6, 4, 40),        
(6, 5, 0),         
(6, 6, 60),        
(6, 7, 0),         
(6, 8, 0),         
(6, 9, 0),         
(6, 10, 0),        

(7, 1, 0),         
(7, 2, 60),        
(7, 3, 40),        
(7, 4, 40),        
(7, 5, 0),         
(7, 6, 60),        
(7, 7, 0),         
(7, 8, 0),         
(7, 9, 0),         
(7, 10, 0),        

(8, 1, 0),         
(8, 2, 60),        
(8, 3, 40),        
(8, 4, 40),        
(8, 5, 0),         
(8, 6, 60),        
(8, 7, 0),         
(8, 8, 0),         
(8, 9, 0),         
(8, 10, 0),        

(9, 1, 0),         
(9, 2, 60),        
(9, 3, 40),        
(9, 4, 40),        
(9, 5, 0),         
(9, 6, 60),        
(9, 7, 0),         
(9, 8, 0),         
(9, 9, 0),         
(9, 10, 0),        

(10, 1, 25),       
(10, 2, 0),        
(10, 3, 40),       
(10, 4, 40),       
(10, 5, 50),       
(10, 6, 40),       
(10, 7, 0),        
(10, 8, 10),       
(10, 9, 0),        
(10, 10, 10),      

(11, 1, 25),       
(11, 2, 0),        
(11, 3, 40),       
(11, 4, 40),       
(11, 5, 50),       
(11, 6, 40),       
(11, 7, 0),        
(11, 8, 10),       
(11, 9, 0),        
(11, 10, 10),      

(12, 1, 25),       
(12, 2, 0),        
(12, 3, 40),       
(12, 4, 40),       
(12, 5, 50),       
(12, 6, 40),       
(12, 7, 0),        
(12, 8, 10),       
(12, 9, 0),        
(12, 10, 10),      

(13, 1, 25),       
(13, 2, 0),        
(13, 3, 40),       
(13, 4, 40),       
(13, 5, 50),       
(13, 6, 40),       
(13, 7, 0),        
(13, 8, 10),       
(13, 9, 0),        
(13, 10, 10),      

(14, 1, 70),       
(14, 2, 0),        
(14, 3, 80),       
(14, 4, 80),       
(14, 5, 0),        
(14, 6, 0),        
(14, 7, 0),        
(14, 8, 0),        
(14, 9, 0),        
(14, 10, 5),       

(15, 1, 20),       
(15, 2, 0),        
(15, 3, 80),       
(15, 4, 80),       
(15, 5, 0),        
(15, 6, 0),        
(15, 7, 30),       
(15, 8, 0),        
(15, 9, 50),       
(15, 10, 5),       

(16, 1, 25),       
(16, 2, 25),       
(16, 3, 25),       
(16, 4, 25),       
(16, 5, 25),       
(16, 6, 25),       
(16, 7, 25),       
(16, 8, 25),       
(16, 9, 25),       
(16, 10,25),  

(17, 1, 0),       
(17, 2, 60),       
(17, 3, 35),       
(17, 4, 30),       
(17, 5, 0),       
(17, 6, 50),       
(17, 7, 0),       
(17, 8, 0),       
(17, 9, 0),       
(17, 10,5), 

(18, 1, 15),       
(18, 2, 0),       
(18, 3, 40),       
(18, 4, 40),       
(18, 5, 45),       
(18, 6, 20),       
(18, 7, 0),       
(18, 8, 10),       
(18, 9, 0),       
(18, 10, 10);


REPLACE INTO monstersbuildsprofil VALUES
(1, "animal_generic_melee"),
(2, "warrior"),
(3, "mage"),
(4, "archer"),
(5, "animal_poisonous_melee"),
(6, "warrior_elemental_fire"),
(7, "warrior_elemental_water"),
(8, "warrior_elemental_earth"),
(9, "warrior_elemental_wind"),
(10, "warrior_tank"),
(11, "animal_generic_distance"),
(12, "healer"),
(13, "animal_poisonous_distant"),
(14, "mage_elemental_fire"),
(15, "mage_elemental_water"),
(16, "mage_elemental_earth"),
(17, "mage_elemental_wind");


REPLACE INTO monstersbuilds VALUES
(1, 1, 0),
(1, 29, 0),
(1, 31, 0),

(2, 1, 0),
(2, 31, 0),
(2, 4, 0),
(2, 5, 0),
(2, 6, 0),
(2, 7, 0),

(3, 3, 0),
(3, 12, 0),
(3, 13, 0),
(3, 14, 0),
(3, 15, 0),

(4, 1, 0),
(4, 8, 0),
(4, 9, 0),
(4, 10, 0),
(4, 11, 0),

(5, 1, 0),
(5, 30, 0),
(5, 31, 0),

(6, 1, 0),
(6, 31, 0),
(6, 4, 0),

(7, 1, 0),
(7, 31, 0),
(7, 5, 0),
 
(8, 1, 0),
(8, 31, 0),
(8, 6, 0),

(9, 1, 0),
(9, 31, 0),
(9, 7, 0),

(10, 1, 0),
(10, 31, 0),
(10, 27, 0),
(10, 18, 0),

(11, 2, 0),
(11, 29, 0),
(11, 31, 0),

(12, 3, 0),
(12, 20, 0),
(12, 22, 0),
(12, 23, 0),
(12, 24, 0),

(13, 2, 0),
(13, 30, 0),
(13, 16, 0),

(14, 1, 0),
(14, 27, 0),
(14, 12, 0),

(15, 1, 0),
(15, 27, 0),
(15, 13, 0),
 
(16, 1, 0),
(16, 27, 0),
(16, 14, 0),

(17, 1, 0),
(17, 27, 0),
(17, 15, 0);

REPLACE INTO statsmonstres VALUES
(1, 1, 1),
(2, 1, 1),
(3, 1, 5),
(4, 1, 5),
(5, 1, 1),
(6, 1, 8),
(7, 16, 8),
(8, 16, 6),
(9, 16, 7),
(10, 16, 9),
(11, 16, 9),
(12, 16, 3),
(13, 16, 5),
(14, 15, 1),
(15, 14, 1),
(16, 18, 11),
(17, 16, 1),
(18, 18, 11),
(19, 16, 10),
(20, 16, 5),
(21, 15, 5),
(22, 14, 1),
(22, 14, 1),
(23, 14, 1),
(24, 15, 10),
(25, 15, 1),
(26, 15, 1),
(27, 2, 2),
(28, 10, 4),
(29, 2, 6),
(30, 2, 6),
(31, 4, 2),
(32, 12, 4),
(33, 14, 2),
(34, 8, 3),
(35, 15, 10),
(36, 15, 1),
(37, 15, 1),
(38, 4, 8),
(39, 4, 8),
(40, 14, 1),
(41, 15, 1),
(42, 14, 1),
(43, 18, 13),
(44, 18, 13),
(45, 15, 1),
(46, 16, 1),
(47, 15, 1),
(48, 16, 1),
(49, 4, 8),
(50, 4, 8),
(51, 4, 8),
(52, 15, 10),
(53, 16, 2),
(54, 16, 2),
(55, 15, 10),
(56, 2, 6),
(57, 6, 14),
(58, 6, 14),
(59, 6, 14),
(60, 9, 17),
(61, 5, 9),
(62, 16, 6),
(63, 15, 6),
(64, 15, 6),
(65, 15, 2),
(66, 18, 4),
(67, 17, 3),
(68, 15, 7),
(69, 14, 10),
(70, 14, 6),
(71, 15, 2),
(72, 18, 4),
(73, 17, 3),
(74, 16, 2),
(75, 15, 2),
(76, 18, 4),
(77, 17, 3),
(78, 15, 5),
(79, 14, 10),
(80, 3, 7),
(81, 7, 15);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
