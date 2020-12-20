-- MySQL Workbench Synchronization
-- Generated: 2020-07-04 14:55
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Roncarlos

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE TABLE IF NOT EXISTS `traits` (
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
    REFERENCES `states` (`idState`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Traits_TraitsTypes1`
    FOREIGN KEY (`idTraitType`)
    REFERENCES `traitstypes` (`idTraitType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Traits_ElementsTypes1`
    FOREIGN KEY (`valueElementType`)
    REFERENCES `elementstypes` (`idElementType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Traits_SkillsTypes1`
    FOREIGN KEY (`valueSkillType`)
    REFERENCES `skillstypes` (`idSkillType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Traits_Stats1`
    FOREIGN KEY (`valueStat`)
    REFERENCES `stats` (`idStat`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Traits_Skills1`
    FOREIGN KEY (`valueSkill`)
    REFERENCES `skills` (`idSkill`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Traits_SecondaryStats1`
    FOREIGN KEY (`valueSecondaryStat`)
    REFERENCES `secondarystats` (`idSecondaryStat`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `traitstypes` (
  `idTraitType` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `typeShorthand` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idTraitType`),
  UNIQUE INDEX `typeShorthand_UNIQUE` (`typeShorthand` ASC) VISIBLE,
  UNIQUE INDEX `idTraitType_UNIQUE` (`idTraitType` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `states` (
  `idState` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `idStateRestriction` INT UNSIGNED NULL DEFAULT NULL,
  `shorthand` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idState`),
  UNIQUE INDEX `idState_UNIQUE` (`idState` ASC) VISIBLE,
  INDEX `fk_States_StatesRestrictions1_idx` (`idStateRestriction` ASC) VISIBLE,
  CONSTRAINT `fk_States_StatesRestrictions1`
    FOREIGN KEY (`idStateRestriction`)
    REFERENCES `statesrestrictions` (`idStateRestriction`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `statesrestrictions` (
  `idStateRestriction` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `shorhand` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idStateRestriction`),
  UNIQUE INDEX `idStateRestriction_UNIQUE` (`idStateRestriction` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `statesremovalconditions` (
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
    REFERENCES `states` (`idState`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `statestraits` (
  `idState` INT UNSIGNED NOT NULL,
  `idTrait` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idState`, `idTrait`),
  INDEX `fk_StatesTraits_Traits1_idx` (`idTrait` ASC) VISIBLE,
  CONSTRAINT `fk_StatesTraits_States1`
    FOREIGN KEY (`idState`)
    REFERENCES `states` (`idState`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_StatesTraits_Traits1`
    FOREIGN KEY (`idTrait`)
    REFERENCES `traits` (`idTrait`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `elementstypes` (
  `idElementType` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `shorthand` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idElementType`),
  UNIQUE INDEX `idElementType_UNIQUE` (`idElementType` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `skillstypes` (
  `idSkillType` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `shorthand` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idSkillType`),
  UNIQUE INDEX `idSkillType_UNIQUE` (`idSkillType` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `skills` (
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
    REFERENCES `skillstypes` (`idSkillType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Skills_TargetRange1`
    FOREIGN KEY (`idTargetRange`)
    REFERENCES `targetrange` (`idTargetRange`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `targetrange` (
  `idTargetRange` INT NOT NULL,
  `shothand` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idTargetRange`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `castinfo` (
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
    REFERENCES `skills` (`idSkill`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CastInfo_AttacksTypes1`
    FOREIGN KEY (`idAttackType`)
    REFERENCES `attackstypes` (`idAttackType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `attackstypes` (
  `idAttackType` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `shorthand` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idAttackType`),
  UNIQUE INDEX `idAttackType_UNIQUE` (`idAttackType` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `requiredsubtypeequipped` (
  `idSousType` INT UNSIGNED NOT NULL,
  `idSkill` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idSousType`, `idSkill`),
  INDEX `fk_RequiredSubtypeEquipped_Skills1_idx` (`idSkill` ASC) VISIBLE,
  CONSTRAINT `fk_RequiredSubtypeEquipped_ItemsSousTypes1`
    FOREIGN KEY (`idSousType`)
    REFERENCES `itemssoustypes` (`idSousType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_RequiredSubtypeEquipped_Skills1`
    FOREIGN KEY (`idSkill`)
    REFERENCES `skills` (`idSkill`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `damagestypes` (
  `idDamageType` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `shorthand` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idDamageType`),
  UNIQUE INDEX `idDamageType_UNIQUE` (`idDamageType` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `damageinfo` (
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
    REFERENCES `skills` (`idSkill`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DamageInfo_DamagesTypes1`
    FOREIGN KEY (`idDamageType`)
    REFERENCES `damagestypes` (`idDamageType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DamageInfo_ElementsTypes1`
    FOREIGN KEY (`idElementType`)
    REFERENCES `elementstypes` (`idElementType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `effectstypes` (
  `idEffectType` INT NOT NULL,
  `shortname` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idEffectType`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `effectsskills` (
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
    REFERENCES `skills` (`idSkill`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_EffectsSkills_EffectsTypes1`
    FOREIGN KEY (`idEffectType`)
    REFERENCES `effectstypes` (`idEffectType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_EffectsSkills_States1`
    FOREIGN KEY (`stateValue`)
    REFERENCES `states` (`idState`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_EffectsSkills_Stats1`
    FOREIGN KEY (`statValue`)
    REFERENCES `stats` (`idStat`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `secondarystats` (
  `idSecondaryStat` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(60) NOT NULL,
  `desc` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`idSecondaryStat`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE,
  UNIQUE INDEX `idSecondaryStat_UNIQUE` (`idSecondaryStat` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `itemssecondarystats` (
  `idItem` INT UNSIGNED NOT NULL,
  `idSecondaryStat` INT UNSIGNED NOT NULL,
  `value` INT NOT NULL,
  PRIMARY KEY (`idItem`, `idSecondaryStat`),
  INDEX `fk_ItemsSecondaryStats_SecondaryStats1_idx` (`idSecondaryStat` ASC) VISIBLE,
  CONSTRAINT `fk_ItemsSecondaryStats_Items1`
    FOREIGN KEY (`idItem`)
    REFERENCES `items` (`idItem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ItemsSecondaryStats_SecondaryStats1`
    FOREIGN KEY (`idSecondaryStat`)
    REFERENCES `secondarystats` (`idSecondaryStat`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `secondarystatsrepartition` (
  `idStatsProfil` INT UNSIGNED NOT NULL,
  `idSecondaryStat` INT UNSIGNED NOT NULL,
  `baseValue` INT NOT NULL,
  `multPerLevel` FLOAT NOT NULL DEFAULT 0.01,
  PRIMARY KEY (`idStatsProfil`, `idSecondaryStat`),
  INDEX `fk_SecondaryStatsRepartition_SecondaryStats1_idx` (`idSecondaryStat` ASC) VISIBLE,
  CONSTRAINT `fk_SecondaryStatsRepartition_StatsProfil1`
    FOREIGN KEY (`idStatsProfil`)
    REFERENCES `statsprofil` (`idStatsProfil`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SecondaryStatsRepartition_SecondaryStats1`
    FOREIGN KEY (`idSecondaryStat`)
    REFERENCES `secondarystats` (`idSecondaryStat`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

ALTER TABLE `ItemsStats` 
CHANGE COLUMN `value` `value` INT NOT NULL ;

CREATE TABLE IF NOT EXISTS `itemssecondarystatselementalresists` (
  `idItem` INT UNSIGNED NOT NULL,
  `idElementType` INT UNSIGNED NOT NULL,
  `value` FLOAT(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`idItem`, `idElementType`),
  INDEX `fk_ItemsSecondaryStatsElementalResists_ElementsTypes1_idx` (`idElementType` ASC) VISIBLE,
  CONSTRAINT `fk_ItemsSecondaryStatsElementalResists_Items1`
    FOREIGN KEY (`idItem`)
    REFERENCES `items` (`idItem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ItemsSecondaryStatsElementalResists_ElementsTypes1`
    FOREIGN KEY (`idElementType`)
    REFERENCES `elementstypes` (`idElementType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `secondarystatselementalresistsrepartition` (
  `idStatsProfil` INT UNSIGNED NOT NULL,
  `idElementType` INT UNSIGNED NOT NULL,
  `baseValue` INT NOT NULL DEFAULT 0,
  `multPerLevel` FLOAT(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`idStatsProfil`, `idElementType`),
  INDEX `fk_SecondaryStatsElementalResistsRepartition_StatsProfil1_idx` (`idStatsProfil` ASC) VISIBLE,
  CONSTRAINT `fk_SecondaryStatsElementalResistsRepartition_ElementsTypes1`
    FOREIGN KEY (`idElementType`)
    REFERENCES `elementstypes` (`idElementType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SecondaryStatsElementalResistsRepartition_StatsProfil1`
    FOREIGN KEY (`idStatsProfil`)
    REFERENCES `statsprofil` (`idStatsProfil`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `localizationskills` (
  `idSkill` INT UNSIGNED NOT NULL,
  `lang` VARCHAR(5) NOT NULL,
  `nameSkill` VARCHAR(255) NOT NULL,
  `descSkill` VARCHAR(255) NULL DEFAULT NULL,
  `messageSkill` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idSkill`, `lang`),
  INDEX `fk_LocalizationSkills_Languages1_idx` (`lang` ASC) VISIBLE,
  CONSTRAINT `fk_LocalizationSkills_Skills1`
    FOREIGN KEY (`idSkill`)
    REFERENCES `skills` (`idSkill`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_LocalizationSkills_Languages1`
    FOREIGN KEY (`lang`)
    REFERENCES `languages` (`lang`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `localizationstates` (
  `idState` INT UNSIGNED NOT NULL,
  `lang` VARCHAR(5) NOT NULL,
  `nameState` VARCHAR(255) NOT NULL,
  `descState` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`idState`, `lang`),
  INDEX `fk_LocalizationStates_Languages1_idx` (`lang` ASC) VISIBLE,
  CONSTRAINT `fk_LocalizationStates_States1`
    FOREIGN KEY (`idState`)
    REFERENCES `states` (`idState`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_LocalizationStates_Languages1`
    FOREIGN KEY (`lang`)
    REFERENCES `languages` (`lang`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `pstreepossiblesnodesvisuals` (
  `idNode` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `icon` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`idNode`),
  UNIQUE INDEX `idNode_UNIQUE` (`idNode` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `localizationnodespstree` (
  `idNode` INT UNSIGNED NOT NULL,
  `lang` VARCHAR(5) NOT NULL,
  `name` VARCHAR(64) NOT NULL,
  PRIMARY KEY (`idNode`, `lang`),
  INDEX `fk_LocalizationNodesPSTree_Languages1_idx` (`lang` ASC) VISIBLE,
  CONSTRAINT `fk_LocalizationNodesPSTree_PSTreePossiblesNodesVisuals1`
    FOREIGN KEY (`idNode`)
    REFERENCES `pstreepossiblesnodesvisuals` (`idNode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_LocalizationNodesPSTree_Languages1`
    FOREIGN KEY (`lang`)
    REFERENCES `languages` (`lang`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `pstreenodes` (
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
    REFERENCES `pstreepossiblesnodesvisuals` (`idNode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `pstreenodesstatsdata` (
  `idNode` INT UNSIGNED NOT NULL,
  `idStat` INT UNSIGNED NOT NULL,
  `value` INT(11) NOT NULL,
  PRIMARY KEY (`idNode`, `idStat`),
  INDEX `fk_PSTreeNodesStatsData_Stats1_idx` (`idStat` ASC) VISIBLE,
  CONSTRAINT `fk_PSTreeNodesStatsData_PSTreeNodes1`
    FOREIGN KEY (`idNode`)
    REFERENCES `pstreenodes` (`idNode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PSTreeNodesStatsData_Stats1`
    FOREIGN KEY (`idStat`)
    REFERENCES `stats` (`idStat`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `pstreenodessecondarystatsdata` (
  `idNode` INT UNSIGNED NOT NULL,
  `idSecondaryStat` INT UNSIGNED NOT NULL,
  `value` INT(11) NOT NULL,
  PRIMARY KEY (`idNode`, `idSecondaryStat`),
  INDEX `fk_PSTreeNodesSecondaryStatsData_SecondaryStats1_idx` (`idSecondaryStat` ASC) VISIBLE,
  CONSTRAINT `fk_PSTreeNodesSecondaryStatsData_PSTreeNodes1`
    FOREIGN KEY (`idNode`)
    REFERENCES `pstreenodes` (`idNode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PSTreeNodesSecondaryStatsData_SecondaryStats1`
    FOREIGN KEY (`idSecondaryStat`)
    REFERENCES `secondarystats` (`idSecondaryStat`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `pstreenodessecondarystatselementalresistsdata` (
  `idNode` INT UNSIGNED NOT NULL,
  `idElementType` INT UNSIGNED NOT NULL,
  `value` INT NOT NULL,
  PRIMARY KEY (`idNode`, `idElementType`),
  INDEX `fk_PSTreeNodesSecondaryStatsElementalResistsData_ElementsTy_idx` (`idElementType` ASC) VISIBLE,
  CONSTRAINT `fk_PSTreeNodesSecondaryStatsElementalResistsData_PSTreeNodes1`
    FOREIGN KEY (`idNode`)
    REFERENCES `pstreenodes` (`idNode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PSTreeNodesSecondaryStatsElementalResistsData_ElementsTypes1`
    FOREIGN KEY (`idElementType`)
    REFERENCES `elementstypes` (`idElementType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `pstreenodesskillsunlockdata` (
  `idNode` INT UNSIGNED NOT NULL,
  `idSkill` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idNode`, `idSkill`),
  INDEX `fk_PSTreeNodesSkillsUnlockData_Skills1_idx` (`idSkill` ASC) VISIBLE,
  CONSTRAINT `fk_PSTreeNodesSkillsUnlockData_PSTreeNodes1`
    FOREIGN KEY (`idNode`)
    REFERENCES `pstreenodes` (`idNode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PSTreeNodesSkillsUnlockData_Skills1`
    FOREIGN KEY (`idSkill`)
    REFERENCES `skills` (`idSkill`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `pstreenodesstatesdata` (
  `idNode` INT UNSIGNED NOT NULL,
  `idState` INT UNSIGNED NOT NULL,  
  `isProtectedFrom` TINYINT NOT NULL DEFAULT 0,
  `isAdded` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`idNode`, `idState`),
  INDEX `fk_PSTreeNodesStatesData_States1_idx` (`idState` ASC) VISIBLE,
  CONSTRAINT `fk_PSTreeNodesStatesData_PSTreeNodes1`
    FOREIGN KEY (`idNode`)
    REFERENCES `pstreenodes` (`idNode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PSTreeNodesStatesData_States1`
    FOREIGN KEY (`idState`)
    REFERENCES `states` (`idState`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `pstreenodeslinks` (
  `idNodeParent` INT UNSIGNED NOT NULL,
  `PSTreeNodesChild` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idNodeParent`, `PSTreeNodesChild`),
  INDEX `fk_PSTreeNodesLinks_PSTreeNodes2_idx` (`PSTreeNodesChild` ASC) VISIBLE,
  CONSTRAINT `fk_PSTreeNodesLinks_PSTreeNodes1`
    FOREIGN KEY (`idNodeParent`)
    REFERENCES `pstreenodes` (`idNode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PSTreeNodesLinks_PSTreeNodes2`
    FOREIGN KEY (`PSTreeNodesChild`)
    REFERENCES `pstreenodes` (`idNode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `characterstalents` (
  `idCharacter` INT UNSIGNED NOT NULL,
  `idNode` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idCharacter`, `idNode`),
  INDEX `fk_CharactersTalents_PSTreeNodes1_idx` (`idNode` ASC) VISIBLE,
  CONSTRAINT `fk_CharactersTalents_Characters1`
    FOREIGN KEY (`idCharacter`)
    REFERENCES `characters` (`idCharacter`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CharactersTalents_PSTreeNodes1`
    FOREIGN KEY (`idNode`)
    REFERENCES `pstreenodes` (`idNode`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `charactersbuilds` (
  `idCharacter` INT UNSIGNED NOT NULL,
  `idSkill` INT UNSIGNED NOT NULL,
  `priority` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (`idCharacter`, `idSkill`),
  INDEX `fk_CharactersBuilds_Skills1_idx` (`idSkill` ASC) VISIBLE,
  CONSTRAINT `fk_CharactersBuilds_Characters1`
    FOREIGN KEY (`idCharacter`)
    REFERENCES `characters` (`idCharacter`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CharactersBuilds_Skills1`
    FOREIGN KEY (`idSkill`)
    REFERENCES `skills` (`idSkill`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `MonstersBuildsProfil`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `monstersbuildsprofil` (
  `idMonstersBuildsProfil` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  PRIMARY KEY (`idMonstersBuildsProfil`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `MonstersBuilds`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `monstersbuilds` (
  `idMonstersBuildsProfil` INT UNSIGNED NOT NULL,
  `idSkill` INT UNSIGNED NOT NULL,
  `priority` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`idMonstersBuildsProfil`, `idSkill`),
  INDEX `fk_MonstersBuilds_Skills1_idx` (`idSkill` ASC) VISIBLE,
  INDEX `fk_MonstersBuilds_MonstersBuildsProfil1_idx` (`idMonstersBuildsProfil` ASC) VISIBLE,
  CONSTRAINT `fk_MonstersBuilds_Skills1`
    FOREIGN KEY (`idSkill`)
    REFERENCES `skills` (`idSkill`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_MonstersBuilds_MonstersBuildsProfil1`
    FOREIGN KEY (`idMonstersBuildsProfil`)
    REFERENCES `monstersbuildsprofil` (`idMonstersBuildsProfil`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

ALTER TABLE `statsmonstres` 
ADD COLUMN `idMonstersBuildsProfil` INT(10) UNSIGNED NOT NULL AFTER `idStatsProfil`,
ADD INDEX `fk_StatsMonstres_MonstersBuildsProfil1_idx` (`idMonstersBuildsProfil` ASC) VISIBLE;
;

ALTER TABLE `statsmonstres` 
ADD CONSTRAINT `fk_StatsMonstres_MonstersBuildsProfil1`
  FOREIGN KEY (`idMonstersBuildsProfil`)
  REFERENCES `monstersbuildsprofil` (`idMonstersBuildsProfil`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

REPLACE INTO statesrestrictions
VALUES
(1, "cant_target_enemy"),(2, "cant_target_ally"),(3, "cant_target_self"),(4, "cant_target_do_anything");


REPLACE INTO traitstypes
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

REPLACE INTO skillstypes
VALUES
(1,	"magic"),
(2,	"special");

REPLACE INTO attackstypes
VALUES
(1,	"sure"),
(2,	"physical"),
(3,	"magical");

REPLACE INTO elementstypes
VALUES
(1, "physical"),
(2, "fire"),
(3, "water"),
(4, "earth"),
(5, "air"),
(6, "dark"),
(7,	"light");

REPLACE INTO targetrange 
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

REPLACE INTO effectstypes
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

REPLACE INTO languages 
VALUES
("vi");


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

(14, 1, 55),       
(14, 2, 0),        
(14, 3, 60),       
(14, 4, 60),       
(14, 5, 0),        
(14, 6, 0),        
(14, 7, 0),        
(14, 8, 0),        
(14, 9, 0),        
(14, 10, 5),       

(15, 1, 20),       
(15, 2, 0),        
(15, 3, 60),       
(15, 4, 60),       
(15, 5, 0),        
(15, 6, 0),        
(15, 7, 30),       
(15, 8, 0),        
(15, 9, 50),       
(15, 10, 5),       

(16, 1, 40),       
(16, 2, 40),       
(16, 3, 40),       
(16, 4, 40),       
(16, 5, 40),       
(16, 6, 40),       
(16, 7, 40),       
(16, 8, 40),       
(16, 9, 40),       
(16, 10,40),  

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

REPLACE INTO itemsbase VALUES 
(75, 1, 1, "unknown", 20),
(76, 1, 2, "unknown", 20),
(77, 1, 3, "unknown", 20),
(78, 1, 4, "unknown", 20),
(79, 1, 5, "unknown", 20),
(80, 1, 6, "unknown", 20),

(81, 1, 1, "unknown", 21),
(82, 1, 2, "unknown", 21),
(83, 1, 3, "unknown", 21),
(84, 1, 4, "unknown", 21),
(85, 1, 5, "unknown", 21),
(86, 1, 6, "unknown", 21),

(87, 1, 1, "unknown", 22),
(88, 1, 2, "unknown", 22),
(89, 1, 3, "unknown", 22),
(90, 1, 4, "unknown", 22),
(91, 1, 5, "unknown", 22),
(92, 1, 6, "unknown", 22),

(93, 1, 1, "unknown", 23),
(94, 1, 2, "unknown", 23),
(95, 1, 3, "unknown", 23),
(96, 1, 4, "unknown", 23),
(97, 1, 5, "unknown", 23),
(98, 1, 6, "unknown", 23),

(99,  2, 1, "unknown", 18),
(100, 2, 2, "unknown", 18),
(101, 2, 3, "unknown", 18),
(102, 2, 4, "unknown", 18),
(103, 2, 5, "unknown", 18),
(104, 2, 6, "unknown", 18),
      
(105, 2, 1, "unknown", 19),
(106, 2, 2, "unknown", 19),
(107, 2, 3, "unknown", 19),
(108, 2, 4, "unknown", 19),
(109, 2, 5, "unknown", 19),
(110, 2, 6, "unknown", 19),

(111, 3, 1, "unknown", 18),
(112, 3, 2, "unknown", 18),
(113, 3, 3, "unknown", 18),
(114, 3, 4, "unknown", 18),
(115, 3, 5, "unknown", 18),
(116, 3, 6, "unknown", 18),
      
(117, 3, 1, "unknown", 19),
(118, 3, 2, "unknown", 19),
(119, 3, 3, "unknown", 19),
(120, 3, 4, "unknown", 19),
(121, 3, 5, "unknown", 19),
(122, 3, 6, "unknown", 19),

(123, 4, 1, "unknown", 18),
(124, 4, 2, "unknown", 18),
(125, 4, 3, "unknown", 18),
(126, 4, 4, "unknown", 18),
(127, 4, 5, "unknown", 18),
(128, 4, 6, "unknown", 18),
      
(129, 4, 1, "unknown", 19),
(130, 4, 2, "unknown", 19),
(131, 4, 3, "unknown", 19),
(132, 4, 4, "unknown", 19),
(133, 4, 5, "unknown", 19),
(134, 4, 6, "unknown", 19);

REPLACE INTO localizationitems VALUES
(75, "en", "Rudimentary Bow",                        "A banal bow."),
(76, "en", "Wooden Bow",                             "A wooden bow, at the same time what did you expect?"),
(77, "en", "Reinforced Wooden Bow",                  "A warrior's bow."),
(78, "en", "Ornamented Wooden Bow",                  "Here we go again, gems."),
(79, "en", "Bow of Excellent Craftsmanship",         "An exceptional quality, I wonder if you deserve it..."),
(80, "en", "Chaos Bow",                              "This bow is made of magic from chaos shards from another dimension."),

(81, "en", "Rudimentary Dagger",                     "Short, banal, I hope you don't think of anything else."),
(82, "en", "Silver Dagger",                          "A werewolf toothpick."),
(83, "en", "Iron Dagger",                            "An iron dagger, nothing more banal"),
(84, "en", "Golden Dagger",                          "A beautiful golden dagger, too bad it is so short."),
(85, "en", "Mithril Dagger",                         "Small but powerful."),
(86, "en", "Chaos Dagger",                           "This dagger is made of magic from chaos shards from another dimension."),

(87, "en", "Rudimentary Wand",                       "A banal wand."),
(88, "en", "Wooden Wand",                            "A wooden wand, you surely throw its splinters."),
(89, "en", "Reinforced Wooden Wand",                 "A majorette's wand, er, sorry, wizard's wand."),
(90, "en", "Ornamented Wooden Wand",                 "It takes at least a few gems for the magic to work."),
(91, "en", "Wand of Excellent Craftsmanship",        "An exceptional quality, for a piece of wood, it looks great!"),
(92, "en", "Chaos Wand",                             "This wand is made of magic from chaos shards from another dimension."),

(93, "en", "Rudimentary Staff",                      "A banal staff"),
(94, "en", "Silver Staff",                           "Silver, really? Do you think you're Bigdalf?"),
(95, "en", "Iron Staff",                             "Iron? And what next? Gold? You think that drives the magic?"),
(96, "en", "Golden Staff",                           "Oh no, gold, well, maybe, it really does drive the magic."),
(97, "en", "Mithril Staff",                          "Mithril, really? What's your excuse this time?"),
(98, "en", "Chaos Staff",                            "This staff is made of magic from chaos shards from another dimension."),

(99 , "en", "Rudimentary Chest Clothing",            "A beggar is better dressed."),
(100, "en", "Silvery Chest Clothing",                "Given the contact of silver on your skin, I'm sure you're not a werewolf."),
(101, "en", "Irony Chest Clothing",                  "Isn't the name funny?"),
(102, "en", "Golden Chest Clothing",                 "Are you proud with all that gold?"),
(103, "en", "Chest Clothing Orned With Mithril",     "It's beautiful, and it looks like something a certain Brodon used to wear."),
(104, "en", "Chaos Chest Clothing",                  "This chest clothing is made of magic from chaos shards from another dimension."),

(105, "en", "Used Leather Chest Armor",              "Already used, with traces of... combat."),
(106, "en", "Leather Chest Armor",                   "Leather, straps, and boom, it's something ordinary."),
(107, "en", "Thief's Leather Chest Armor",           "With this, you're sure to get arrested."),
(108, "en", "Ornamented Leather Chest Armor",        "Leather, metal, it's beautiful."),
(109, "en", "Beautiful Leather Chest Armor",         "Leather and mithril? Truly ingenious."),
(110, "en", "Chaos Leather Chest Armor",             "This leather chest armor is made of magic from chaos shards from another dimension."),

(111, "en", "Used Cloth Leggings",                   "Already used, with traces of... magic"),
(112, "en", "Cloth Leggings",                        "Cloth, magic, and boom, it does something banal."),
(113, "en", "Mage's Cloth Leggings",                 "I had never seen under a magician's skirt, it's not a pretty sight."),
(114, "en", "Ornamented Cloth Leggings",             "Beautiful family jewels. Ah sorry, it's your leggings."),
(115, "en", "Beautiful CLoth Leggings",              "They are magnificent... I'm talking about your leggings."),
(116, "en", "Chaos Cloth Leggings",                  "This cloth leggings is made of magic from chaos shards from another dimension."),

(117, "en", "Used Leather Leggings",                 "Already used, with traces of... combat."),
(118, "en", "Leather Leggings",                      "Leather, straps, and boom, it's something ordinary."),
(119, "en", "Thief's Leather Leggings",              "With this, you're sure to get arrested."),
(120, "en", "Ornamented Leather Leggings",           "Leather, metal, it's beautiful."),
(121, "en", "Beautiful Leather Leggings",            "Leather and mithril? Truly ingenious."),
(122, "en", "Chaos Leather Leggings",                "This leather leggings is made of magic from chaos shards from another dimension."),

(123, "en", "Used Cloth Hat",                        "Already used, not very popular. If you wear it, you're a has-been."),
(124, "en", "Cloth Hat",                             "Really Banal and Ugly, not even sure if it protects you from the rain."),
(125, "en", "Mage's Cloth Hat",                      "You become the magician's cliché with this hat."),
(126, "en", "Ornamented Cloth Hat",                  "We have to stop this fashion of hats with gems."),
(127, "en", "Magical Cloth Hat",                     "It's magic, it's your sorting hat."),
(128, "en", "Chaos Cloth Hat",                       "This cloth hat is made of magic from chaos shards from another dimension."),
    
(129, "en", "Used Leather Hat",                      "It protects from the rain, that's all."),
(130, "en", "Leather Hat",                           "I don't know about that style."),
(131, "en", "Archer's hat",                          "Does this... thing protect you from arrows?"),
(132, "en", "Ornamented Leather Hat",                "These few gems don't help you look your best."),
(133, "en", "Vibrating Leather Hat",                 "It is not a legend! This hat is vibrating! Is it scared?"),
(134, "en", "Chaos Leather Hat",                     "This leather hat is made of magic from chaos shards from another dimension."),

(75, "fr",  "Arc Rudimentaire",                      "Un arc vraiment banal."),
(76, "fr",  "Arc en Bois",                           "Un arc en bois, en même temps vous vous attendiez à quoi ?"),
(77, "fr",  "Arc en Bois Renforcé",                  "Un arc de guerrier."),
(78, "fr",  "Arc en Bois Orné",                      "Et voilà, ça fait le fier avec ses gemmes."),
(79, "fr",  "Arc d'Excellente Manufacture",          "Une qualité exceptionnelle, je me demande si vous le méritez..."),
(80, "fr",  "Arc du Chaos",                          "Cet arc est fait de magie provenant d'éclats du chaos appartenant à une autre dimension."),

(81, "fr", "Dague Rudimentaire",                     "Courte, banale, j'espère que vous ne pensez pas à quelque chose d'autre."),
(82, "fr", "Dague en Argent",                        "Un cure-dent anti loup-garou."),
(83, "fr", "Dague en Fer",                           "Une dague en fer, rien de plus banal"),
(84, "fr", "Dague en Or",                            "Une belle dague en or, dommage qu'elle soit si courte."),
(85, "fr", "Dague en Mithril",                       "Petite mais puissante."),
(86, "fr", "Dague du Chaos",                         "Cette dague est faite de magie provenant d'éclats du chaos appartenant à une autre dimension."),

(87, "fr", "Baguette Rudimentaire",                  "Une baguette vraiment banale."),
(88, "fr", "Baguette en Bois",                       "Une baguette en bois, vous lancez sûrement ses échardes..."),
(89, "fr", "Baguette en Bois Renforcé",              "Une baguette de majorette, euh, pardon, de sorcier."),
(90, "fr", "Baguette en Bois Orné",                  "Il faut au moins quelques gemmes pour que la magie opère."),
(91, "fr", "Baguette d'Excellente Manufacture",      "Une qualité exceptionnelle, pour un morceau de bois, ça en jette !"),
(92, "fr", "Baguette du Chaos",                      "Cette baguette est faite de magie provenant d'éclats du chaos appartenant à une autre dimension."),

(93, "fr", "Baton Rudimentaire",                     "Un baton vraiment banal."),
(94, "fr", "Baton en Argent",                        "De l'argent, vraiment ? Vous vous prenez pour Grosdalf ?"),
(95, "fr", "Baton en Fer",                           "Du fer ? Et ce sera quoi la suite ? De l'or ? Vous pensez que ça conduit la magie ?"),
(96, "fr", "Baton en Or",                            "Oh non, de l'or, bon, si ça se trouve, ça conduit vraiment la magie."),
(97, "fr", "Baton en Mithril",                       "Du Mithril, vraiment ? C'est quoi votre excuse cette fois ?"),
(98, "fr", "Baton du Chaos",                         "Ce baton est fait de magie provenant d'éclats du chaos appartenant à une autre dimension."),

(99 , "fr", "Chemisier Rudimentaire",                "Un mendiant est mieu vêtu."),
(100, "fr", "Chemisier Argenté",                     "Vu le contact de l'argent sur la peau, je suis sûr que tu n'es pas un loup-garou."),
(101, "fr", "Chemisier Ironique",                    "Est-ce que nom n'est pas amusant ?"),
(102, "fr", "Chemisier Doré",                        "Vous faites le fier avec tout cet or ?"),
(103, "fr", "Chemisier Orné de Mithril",             "C'est beau, et ça ressemble à ce qu'un certain Brodon portait."),
(104, "fr", "Chemisier du Chaos",                    "Cette tenue est faite de magie provenant d'éclats du chaos appartenant à une autre dimension."),

(105, "fr", "Armure de Torse en Cuir d'Occasion",    "Déjà utilisée, avec des traces de... combat."),
(106, "fr", "Armure de Torse en Cuir",               "Du cuir, des sangles, et boum ça fait quelque chose de banal."),
(107, "fr", "Armure de Torse en Cuir du Voleur",     "Avec ça, c'est sûr vous vous faites arrêter."),
(108, "fr", "Armure de Torse en Cuir Orné",          "Du cuir, des métaux, c'est beau."),
(109, "fr", "Magnifique Armure de Torse en Cuir",    "Du cuir, et du mithril ? Vraiment ingénieux."),
(110, "fr", "Armure de Torse en Cuir du Chaos",      "Cette armure en cuir est faite de magie provenant d'éclats du chaos appartenant à une autre dimension."),

(111, "fr", "Jambières en Tissu Usé",                "Déjà utilisée, avec des traces de... magie."),
(112, "fr", "Jambières en Tissu",                    "Du tissu, de la magie, et boum ça fait quelque chose de banal."),
(113, "fr", "Jambières en Tissu du Mage",            "J'avais jamais vu sous la jupe d'un mage, c'est pas beau à voir."),
(114, "fr", "Jambières en Tissu Orné",               "De beau bijous de famille. Ah pardon, c'est vos jambières."),
(115, "fr", "Magnifiques Jambières en Tissu",        "Elle sont magnfiques... Je parle de vos jambières."),
(116, "fr", "Jambière en Tissu du Chaos",            "Ces jambières en tissu sont faites de magie provenant d'éclats du chaos appartenant à une autre dimension."),

(117, "fr", "Jambières en Cuir Usé",                 "Déjà utilisée, avec des traces de... combat."),
(118, "fr", "Jambières en Cuir",                     "Du cuir, des sangles, et boum ça fait quelque chose de banal."),
(119, "fr", "Jambières en Cuir du Voleur",           "Avec ça, c'est sûr vous vous faites arrêter."),
(120, "fr", "Jambières en Cuir Orné",                "Du cuir, des métaux, c'est beau."),
(121, "fr", "Magnifiques Jambières en Cuir",         "Du cuir, et du mithril ? Vraiment ingénieux."),
(122, "fr", "Jambière en Cuir du Chaos",             "Ces jambières en cuir sont faites de magie provenant d'éclats du chaos appartenant à une autre dimension."),

(123, "fr", "Chapeau en Tissu Usé",                  "Déjà utilisé, pas très fashion. Si vous le portez, vous êtes has been."),
(124, "fr", "Chapeau en Tissu",                      "Vraiment Banal et Moche, même pas sûr que cela vous protège de la pluie."),
(125, "fr", "Chapeau en Tissu de Mage",              "Vous devenez le cliché du mage avec ce chapeau."),
(126, "fr", "Chapeau en Tissu Orné",                 "Faut arrêter cette mode des chapeaux avec des gemmes."),
(127, "fr", "Chapeau en Tissu Magique",              "Il est magique, c'est votre choixpeau."),
(128, "fr", "Chapeau en Tissu du Chaos",             "Ce chapeau en tissu est fait de magie provenant d'éclats du chaos appartenant à une autre dimension."),
    
(129, "fr", "Chapeau en Cuir Usé",                   "Il protège de la pluie, c'est tout."),
(130, "fr", "Chapeau en Cuir",                       "Je ne sais pas quoi dire de ce style."),
(131, "fr", "Chapeau d'Archer",                      "Est-ce que cette... chose vous protège des flèches ?"),
(132, "fr", "Chapeau en Cuir Orné",                  "Ces quelques gemmes ne vous aide pas à paraître sous un meilleur jour."),
(133, "fr", "Chapeau en Cuir Vibrant",               "Ce n'est pas une légende ! Ce chapeau vibre ! Est-ce qu'il aurait peur ?"),
(134, "fr", "Chapeau en Cuir du Chaos",              "Ce chapeau en cuir est fait de magie provenant d'éclats du chaos appartenant à une autre dimension.");


DELETE FROM areasitems WHERE areasitems.percentage = 0;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
