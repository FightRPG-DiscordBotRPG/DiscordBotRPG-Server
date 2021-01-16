-- Fight RPG
-- Version: 1.10.0
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
ADD COLUMN `idMonstersBuildsProfil` INT UNSIGNED NOT NULL AFTER `idStatsProfil`,
ADD INDEX `fk_StatsMonstres_MonstersBuildsProfil1_idx` (`idMonstersBuildsProfil` ASC) VISIBLE;
;

ALTER TABLE `statsmonstres` 
ADD CONSTRAINT `fk_StatsMonstres_MonstersBuildsProfil1`
  FOREIGN KEY (`idMonstersBuildsProfil`)
  REFERENCES `monstersbuildsprofil` (`idMonstersBuildsProfil`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `discord_bot_rpg`.`characters` 
ADD COLUMN `talentPoints` INT NOT NULL DEFAULT 0 AFTER `idArea`;

UPDATE characters INNER JOIN levels ON levels.idCharacter = characters.idCharacter SET talentPoints = levels.actualLevel;

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
(11, "threat", ""),
(12, "initiative", "");

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

REPLACE INTO `castinfo` (`idSkill`, `timeToCast`, `successRate`, `repeat`, `energyGain`, `idAttackType`) VALUES
(1, 0, 100, 1, 10, 2),
(2, 0, 100, 1, 20, 2),
(3, 0, 100, 1, 0, 3),
(4, 0, 100, 1, 0, 2),
(5, 0, 100, 1, 0, 2),
(6, 0, 100, 1, 0, 2),
(7, 0, 100, 1, 0, 2),
(8, 0, 100, 1, 0, 2),
(9, 0, 100, 1, 0, 2),
(10, 0, 100, 1, 0, 2),
(11, 0, 100, 1, 0, 2),
(12, 0, 100, 1, 0, 3),
(13, 0, 100, 1, 0, 3),
(14, 0, 100, 1, 0, 3),
(15, 0, 100, 1, 0, 3),
(16, 0, 100, 1, 0, 2),
(17, 0, 100, 1, 0, 2),
(18, 0, 100, 1, 0, 1),
(19, 0, 100, 1, 0, 1),
(20, 0, 100, 1, 0, 1),
(21, 0, 100, 1, 0, 1),
(22, 0, 100, 1, 0, 1),
(23, 0, 100, 1, 0, 1),
(24, 0, 50, 1, 0, 1),
(25, 0, 100, 1, 0, 2),
(26, 0, 100, 1, 0, 1),
(27, 0, 100, 1, 0, 1),
(28, 4, 100, 1, 50, 1),
(29, 0, 100, 1, 0, 2),
(30, 0, 100, 1, 0, 2),
(31, 0, 100, 1, 0, 2);

REPLACE INTO `damageinfo` (`idSkill`, `idDamageType`, `idElementType`, `formula`, `variance`, `criticalHit`) VALUES
(1, 1, 1, 'a.str * 1.5', 20, 1),
(2, 1, 1, 'a.dex * 1.8', 40, 1),
(3, 1, 1, 'a.int * 2', 10, 1),
(4, 1, 2, 'a.str * 2', 20, 1),
(5, 1, 3, 'a.str * 2', 20, 1),
(6, 1, 4, 'a.str * 2', 20, 1),
(7, 1, 5, 'a.str * 2', 20, 1),
(8, 1, 2, 'a.dex * 1.8 + a.wis * 0.8', 30, 1),
(9, 1, 3, 'a.dex * 1.8 + a.wis * 0.8', 30, 1),
(10, 1, 4, 'a.dex * 1.8 + a.wis * 0.8', 30, 1),
(11, 1, 5, 'a.dex * 1.8 + a.wis * 0.8', 30, 1),
(12, 1, 2, 'a.int * 2 + a.wis * 1.2', 10, 0),
(13, 1, 3, 'a.int * 2 + a.wis * 1.2', 10, 0),
(14, 1, 4, 'a.int * 2 + a.wis * 1.2', 10, 0),
(15, 1, 5, 'a.int * 2 + a.wis * 1.2', 10, 0),
(16, 1, 4, 'b.mhp * 0.1 + a.dex * 0.4', 50, 0),
(17, 1, 4, 'b.mhp * 0.05 + a.dex * 0.2', 50, 0),
(18, 3, 1, 'a.mhp * 0.1', 5, 0),
(21, 3, 1, 'a.int * 0.7 + a.wis * 0.2', 20, 1),
(22, 3, 1, 'a.int * 0.5 + a.wis * 0.15', 20, 1),
(23, 3, 1, 'a.int * 0.2 + a.wis * 0.1', 30, 1),
(24, 3, 1, 'b.mhp * 0.1', 0, 0),
(25, 1, 1, 'a.dex * 0.3', 50, 0),
(28, 1, 1, 'a.mhp / 2', 0, 0),
(29, 1, 1, 'a.str * 3', 20, 1),
(30, 1, 1, '(a.str + a.dex) * 1.2', 30, 1),
(31, 1, 1, 'a.str * 0.6 + a.con * 0.6', 20, 1);

REPLACE INTO `effectsskills` (`idEffectSkill`, `idSkill`, `idEffectType`, `percentageValue`, `fixedValue`, `stateValue`, `statValue`, `roundsValue`) VALUES
(1, 1, 4, 0, 0, 1, NULL, 0),
(2, 16, 4, 0.9, 0, 4, NULL, 0),
(3, 17, 4, 0.5, 0, 4, NULL, 0),
(4, 18, 4, 1, 0, 6, NULL, 0),
(5, 19, 4, 1, 0, 3, NULL, 0),
(6, 20, 4, 1, 0, 3, NULL, 0),
(7, 21, 4, 1, 0, 8, NULL, 0),
(8, 22, 4, 1, 0, 8, NULL, 0),
(9, 23, 4, 1, 0, 8, NULL, 0),
(10, 24, 4, 0.25, 0, 3, NULL, 0),
(11, 25, 4, 0.8, 0, 5, NULL, 0),
(12, 26, 4, 1, 0, 7, NULL, 0),
(13, 27, 4, 1, 0, 2, NULL, 0),
(14, 29, 4, 0.25, 0, 10, NULL, 0),
(15, 30, 4, 0.25, 0, 4, NULL, 0),
(16, 31, 4, 1, 0, 1, NULL, 0);

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
(3, 'en', 'Roguery'),
(3, 'es', 'Roguery'),
(3, 'fr', 'Roguery'),
(3, 'pt-BR', 'Roguery'),
(3, 'ru', 'Roguery'),
(3, 'vi', 'Roguery'),
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
(11, 'en', 'Warrior Path'),
(11, 'es', 'Warrior Path'),
(11, 'fr', 'Warrior Path'),
(11, 'pt-BR', 'Warrior Path'),
(11, 'ru', 'Warrior Path'),
(11, 'vi', 'Warrior Path'),
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
(16, 'en', 'Focused Tornado'),
(16, 'es', 'Focused Tornado'),
(16, 'fr', 'Focused Tornado'),
(16, 'pt-BR', 'Focused Tornado'),
(16, 'ru', 'Focused Tornado'),
(16, 'vi', 'Focused Tornado'),
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
(28, 'en', 'Flaming Blow'),
(28, 'es', 'Flaming Blow'),
(28, 'fr', 'Flaming Blow'),
(28, 'pt-BR', 'Flaming Blow'),
(28, 'ru', 'Flaming Blow'),
(28, 'vi', 'Flaming Blow'),
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
(39, 'en', 'Bomberman'),
(39, 'es', 'Bomberman'),
(39, 'fr', 'Bomberman'),
(39, 'pt-BR', 'Bomberman'),
(39, 'ru', 'Bomberman'),
(39, 'vi', 'Bomberman'),
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
(45, 'es', 'Fireball'),
(45, 'fr', 'Fireball'),
(45, 'pt-BR', 'Fireball'),
(45, 'ru', 'Fireball'),
(45, 'vi', 'Fireball'),
(46, 'en', 'Heal'),
(46, 'es', 'Heal 1'),
(46, 'fr', 'Heal 1'),
(46, 'pt-BR', 'Heal 1'),
(46, 'ru', 'Heal 1'),
(46, 'vi', 'Heal 1'),
(47, 'en', 'Hide In Bush'),
(47, 'es', 'Hide In Bush'),
(47, 'fr', 'Hide In Bush'),
(47, 'pt-BR', 'Hide In Bush'),
(47, 'ru', 'Hide In Bush'),
(47, 'vi', 'Hide In Bush'),
(48, 'en', 'Ice Block'),
(48, 'es', 'Ice Block'),
(48, 'fr', 'Ice Block'),
(48, 'pt-BR', 'Ice Block'),
(48, 'ru', 'Ice Block'),
(48, 'vi', 'Ice Block'),
(49, 'en', 'Ice Shards'),
(49, 'es', 'Ice Shards'),
(49, 'fr', 'Ice Shards'),
(49, 'pt-BR', 'Ice Shards'),
(49, 'ru', 'Ice Shards'),
(49, 'vi', 'Ice Shards'),
(50, 'en', 'Light Ray'),
(50, 'es', 'Light Ray'),
(50, 'fr', 'Light Ray'),
(50, 'pt-BR', 'Light Ray'),
(50, 'ru', 'Light Ray'),
(50, 'vi', 'Light Ray'),
(51, 'en', 'Lightning Blue'),
(51, 'es', 'Lightning Blue'),
(51, 'fr', 'Lightning Blue'),
(51, 'pt-BR', 'Lightning Blue'),
(51, 'ru', 'Lightning Blue'),
(51, 'vi', 'Lightning Blue'),
(52, 'en', 'Lightning Purple'),
(52, 'es', 'Lightning Purple'),
(52, 'fr', 'Lightning Purple'),
(52, 'pt-BR', 'Lightning Purple'),
(52, 'ru', 'Lightning Purple'),
(52, 'vi', 'Lightning Purple'),
(53, 'en', 'Meteor Blue'),
(53, 'es', 'Meteor Blue'),
(53, 'fr', 'Meteor Blue'),
(53, 'pt-BR', 'Meteor Blue'),
(53, 'ru', 'Meteor Blue'),
(53, 'vi', 'Meteor Blue'),
(54, 'en', 'Shield 2'),
(54, 'es', 'Shield 2'),
(54, 'fr', 'Shield 2'),
(54, 'pt-BR', 'Shield 2'),
(54, 'ru', 'Shield 2'),
(54, 'vi', 'Shield 2'),
(55, 'en', 'Spider'),
(55, 'es', 'Spider'),
(55, 'fr', 'Spider'),
(55, 'pt-BR', 'Spider'),
(55, 'ru', 'Spider'),
(55, 'vi', 'Spider'),
(56, 'en', 'Starfall Purple'),
(56, 'es', 'Starfall Purple'),
(56, 'fr', 'Starfall Purple'),
(56, 'pt-BR', 'Starfall Purple'),
(56, 'ru', 'Starfall Purple'),
(56, 'vi', 'Starfall Purple'),
(57, 'en', 'Archery'),
(57, 'es', 'Archery'),
(57, 'fr', 'Archery'),
(57, 'pt-BR', 'Archery'),
(57, 'ru', 'Archery'),
(57, 'vi', 'Archery'),
(58, 'en', 'Thorns'),
(58, 'es', 'Thorns'),
(58, 'fr', 'Thorns'),
(58, 'pt-BR', 'Thorns'),
(58, 'ru', 'Thorns'),
(58, 'vi', 'Thorns'),
(59, 'en', 'Tornado'),
(59, 'es', 'Tornado'),
(59, 'fr', 'Tornado'),
(59, 'pt-BR', 'Tornado'),
(59, 'ru', 'Tornado'),
(59, 'vi', 'Tornado'),
(60, 'en', 'Venom'),
(60, 'es', 'Venom'),
(60, 'fr', 'Venom'),
(60, 'pt-BR', 'Venom'),
(60, 'ru', 'Venom'),
(60, 'vi', 'Venom'),
(61, 'en', 'Wolf'),
(61, 'es', 'Wolf'),
(61, 'fr', 'Wolf'),
(61, 'pt-BR', 'Wolf'),
(61, 'ru', 'Wolf'),
(61, 'vi', 'Wolf'),
(62, 'en', 'Resurrect'),
(62, 'es', 'Resurrect'),
(62, 'fr', 'Resurrect'),
(62, 'pt-BR', 'Resurrect'),
(62, 'ru', 'Resurrect'),
(62, 'vi', 'Resurrect'),
(63, 'en', 'Path of the Elements'),
(63, 'es', 'Path of the Elements'),
(63, 'fr', 'Path of the Elements'),
(63, 'pt-BR', 'Path of the Elements'),
(63, 'ru', 'Path of the Elements'),
(63, 'vi', 'Path of the Elements'),
(64, 'en', 'Rock Shards'),
(64, 'es', 'Rock Shards'),
(64, 'fr', 'Rock Shards'),
(64, 'pt-BR', 'Rock Shards'),
(64, 'ru', 'Rock Shards'),
(64, 'vi', 'Rock Shards'),
(65, 'en', 'Smoke Bomb'),
(65, 'es', 'Smoke Bomb'),
(65, 'fr', 'Smoke Bomb'),
(65, 'pt-BR', 'Smoke Bomb'),
(65, 'ru', 'Smoke Bomb'),
(65, 'vi', 'Smoke Bomb'),
(66, 'en', 'Toxic Bomb'),
(66, 'es', 'Toxic Bomb'),
(66, 'fr', 'Toxic Bomb'),
(66, 'pt-BR', 'Toxic Bomb'),
(66, 'ru', 'Toxic Bomb'),
(66, 'vi', 'Toxic Bomb'),
(67, 'en', 'Flaming Arrow'),
(67, 'es', 'Flaming Arrow'),
(67, 'fr', 'Flaming Arrow'),
(67, 'pt-BR', 'Flaming Arrow'),
(67, 'ru', 'Flaming Arrow'),
(67, 'vi', 'Flaming Arrow'),
(68, 'en', 'Stone Arrow'),
(68, 'es', 'Stone Arrow'),
(68, 'fr', 'Stone Arrow'),
(68, 'pt-BR', 'Stone Arrow'),
(68, 'ru', 'Stone Arrow'),
(68, 'vi', 'Stone Arrow'),
(69, 'en', 'Windy Arrow'),
(69, 'es', 'Windy Arrow'),
(69, 'fr', 'Windy Arrow'),
(69, 'pt-BR', 'Windy Arrow'),
(69, 'ru', 'Windy Arrow'),
(69, 'vi', 'Windy Arrow'),
(70, 'en', 'Ice Arrow'),
(70, 'es', 'Ice Arrow'),
(70, 'fr', 'Ice Arrow'),
(70, 'pt-BR', 'Ice Arrow'),
(70, 'ru', 'Ice Arrow'),
(70, 'vi', 'Ice Arrow'),
(71, 'en', 'Cold Blow'),
(71, 'es', 'Cold Blow'),
(71, 'fr', 'Cold Blow'),
(71, 'pt-BR', 'Cold Blow'),
(71, 'ru', 'Cold Blow'),
(71, 'vi', 'Cold Blow'),
(72, 'en', 'Windy Blow'),
(72, 'es', 'Windy Blow'),
(72, 'fr', 'Windy Blow'),
(72, 'pt-BR', 'Windy Blow'),
(72, 'ru', 'Windy Blow'),
(72, 'vi', 'Windy Blow'),
(73, 'en', 'Earthy Blow'),
(73, 'es', 'Earthy Blow'),
(73, 'fr', 'Earthy Blow'),
(73, 'pt-BR', 'Earthy Blow'),
(73, 'ru', 'Earthy Blow'),
(73, 'vi', 'Earthy Blow'),
(74, 'en', 'Regeneration');

REPLACE INTO `localizationskills` (`idSkill`, `lang`, `nameSkill`, `descSkill`, `messageSkill`) VALUES
(1, 'en', 'Melee Attack', '', ' uses %s!'),
(2, 'en', 'Distant Attack', '', ' uses %s!'),
(3, 'en', 'Magic Bolt', '', ' uses %s!'),
(4, 'en', 'Flaming Blow', '', ' uses %s!'),
(5, 'en', 'Cold Blow', '', ' uses %s!'),
(6, 'en', 'Earthy Blow', '', ' uses %s!'),
(7, 'en', 'Windy Blow', '', ' uses %s!'),
(8, 'en', 'Flaming Arrow', '', ' throws %s!'),
(9, 'en', 'Ice Arrow', '', ' throws %s!'),
(10, 'en', 'Stone Arrow', '', ' throws %s!'),
(11, 'en', 'Windy Arrow', '', ' throws %s!'),
(12, 'en', 'Fireball', '', ' uses %s!'),
(13, 'en', 'Ice Shards', '', ' uses %s!'),
(14, 'en', 'Rock Shards', '', ' uses %s!'),
(15, 'en', 'Focused Tornado', '', ' uses %s!'),
(16, 'en', 'Venom', '', ' throws %s!'),
(17, 'en', 'Toxic Bomb', '', ' throws %s!'),
(18, 'en', 'Taunt', '', ' uses %s!'),
(19, 'en', 'Self Regen Boost', '', ' uses %s!'),
(20, 'en', 'Group Regen Boost', '', ' uses %s!'),
(21, 'en', 'Self Heal', '', ' uses %s!'),
(22, 'en', 'Heal', '', ' uses %s!'),
(23, 'en', 'Group Heal', '', ' uses %s!'),
(24, 'en', 'Resurrect', '', ' uses %s!'),
(25, 'en', 'Smoke Bomb', '', ' throws %s!'),
(26, 'en', 'Deceit', '', ' uses %s!'),
(27, 'en', 'Defend', '', ' uses %s!'),
(28, 'en', 'Enrage', '', ' enrage!'),
(29, 'en', 'Animal Bite', '', ' bites!'),
(30, 'en', 'Poisonous Bite', '', ' bites!'),
(31, 'en', 'Charge', '', ' charges!');

REPLACE INTO `localizationstates` (`idState`, `lang`, `nameState`, `descState`) VALUES
(1, 'en', 'Stun', ''),
(2, 'en', 'Defense', ''),
(3, 'en', 'Regeneration', ''),
(4, 'en', 'Poison', ''),
(5, 'en', 'Blind', ''),
(6, 'en', 'Provoke', ''),
(7, 'en', 'Hide', ''),
(8, 'en', 'Heal Resistant', ''),
(9, 'en', 'Enraged', ''),
(10, 'en', 'Bleed', '');

REPLACE INTO `pstreenodes` (`idNode`, `idNodeVisual`, `x`, `y`, `cost`, `isInitial`) VALUES
(1, 1, 0, 1.5, 1, 1),
(2, 4, 0, 3.5, 1, 0),
(3, 11, -1.5, 5.5, 4, 0),
(4, 63, -3, 7.5, 4, 0),
(5, 73, -5, 6, 5, 0),
(6, 72, -5.5, 7, 5, 0),
(7, 71, -5.5, 8, 5, 0),
(8, 28, -5, 9, 5, 0),
(9, 11, 1.5, 5.5, 4, 0),
(10, 13, 4, 5.5, 6, 0),
(11, 15, 4, 3.5, 6, 0),
(12, 63, 2, 3.5, 4, 0),
(13, 34, -1.5, 0, 1, 0),
(14, 35, -4.5, 0, 4, 0),
(15, 63, -7, 0, 4, 0),
(16, 45, -9, 1.5, 5, 0),
(17, 49, -9.5, 0.5, 5, 0),
(18, 16, -9.5, -0.5, 5, 0),
(19, 64, -9, -1.5, 5, 0),
(20, 62, -4.5, -3, 4, 0),
(21, 46, -3, -3, 10, 0),
(22, 74, -3, -4.5, 10, 0),
(23, 46, -1.5, -3, 10, 0),
(24, 46, -1.5, -4.5, 3, 0),
(25, 46, -1.5, -6, 7, 0),
(26, 21, 1.5, 0, 1, 0),
(27, 3, 4, 0, 6, 0),
(28, 60, 3.5, -1.5, 4, 0),
(29, 63, 1.5, -1.5, 4, 0),
(30, 39, 1.5, -3, 4, 0),
(31, 65, 1.5, -6, 4, 0),
(32, 66, 2.5, -5, 4, 0),
(33, 57, 4, -3, 4, 0),
(34, 67, 5, -2, 5, 0),
(35, 70, 5.5, -3, 5, 0),
(36, 69, 5, -4, 5, 0),
(37, 68, 4, -4.5, 5, 0);

REPLACE INTO `pstreenodeslinks` (`idNodeParent`, `PSTreeNodesChild`) VALUES
(1, 2),
(2, 3),
(3, 4),
(4, 5),
(4, 6),
(4, 7),
(4, 8),
(2, 9),
(9, 10),
(10, 11),
(11, 12),
(1, 13),
(13, 14),
(14, 15),
(15, 16),
(15, 17),
(15, 18),
(15, 19),
(13, 20),
(13, 21),
(21, 22),
(13, 23),
(23, 24),
(24, 25),
(1, 26),
(26, 27),
(27, 28),
(26, 29),
(29, 30),
(30, 31),
(30, 32),
(29, 33),
(33, 34),
(33, 35),
(33, 36),
(33, 37);

REPLACE INTO `pstreenodessecondarystatsdata` (`idNode`, `idSecondaryStat`, `value`) VALUES
(1, 1, 0),
(1, 2, 0),
(1, 3, 0),
(1, 4, 0),
(1, 5, 0),
(1, 6, 0),
(1, 7, 0),
(1, 8, 0),
(1, 9, 0),
(1, 10, 0),
(1, 11, 0),
(1, 12, 0),
(2, 1, 0),
(2, 2, 0),
(2, 3, 0),
(2, 4, 0),
(2, 5, 0),
(2, 6, 1),
(2, 7, 0),
(2, 8, 0),
(2, 9, 0),
(2, 10, 0),
(2, 11, 0),
(2, 12, 0),
(3, 1, 0),
(3, 2, 0),
(3, 3, 0),
(3, 4, 0),
(3, 5, 0),
(3, 6, 0),
(3, 7, 0),
(3, 8, 5),
(3, 9, 0),
(3, 10, 0),
(3, 11, 0),
(3, 12, 0),
(4, 1, 0),
(4, 2, 0),
(4, 3, 0),
(4, 4, 0),
(4, 5, 0),
(4, 6, 0),
(4, 7, 0),
(4, 8, 0),
(4, 9, 0),
(4, 10, 0),
(4, 11, 0),
(4, 12, 0),
(5, 1, 0),
(5, 2, 0),
(5, 3, 0),
(5, 4, 0),
(5, 5, 0),
(5, 6, 0),
(5, 7, 0),
(5, 8, 0),
(5, 9, 0),
(5, 10, 0),
(5, 11, 0),
(5, 12, 0),
(6, 1, 0),
(6, 2, 0),
(6, 3, 0),
(6, 4, 0),
(6, 5, 0),
(6, 6, 0),
(6, 7, 0),
(6, 8, 0),
(6, 9, 0),
(6, 10, 0),
(6, 11, 0),
(6, 12, 0),
(7, 1, 0),
(7, 2, 0),
(7, 3, 0),
(7, 4, 0),
(7, 5, 0),
(7, 6, 0),
(7, 7, 0),
(7, 8, 0),
(7, 9, 0),
(7, 10, 0),
(7, 11, 0),
(7, 12, 0),
(8, 1, 0),
(8, 2, 0),
(8, 3, 0),
(8, 4, 0),
(8, 5, 0),
(8, 6, 0),
(8, 7, 0),
(8, 8, 0),
(8, 9, 0),
(8, 10, 0),
(8, 11, 0),
(8, 12, 0),
(9, 1, 0),
(9, 2, 0),
(9, 3, 0),
(9, 4, 0),
(9, 5, 0),
(9, 6, 0),
(9, 7, 0),
(9, 8, 5),
(9, 9, 0),
(9, 10, 0),
(9, 11, 0),
(9, 12, 0),
(10, 1, 0),
(10, 2, 0),
(10, 3, 0),
(10, 4, 0),
(10, 5, 0),
(10, 6, 0),
(10, 7, 0),
(10, 8, 0),
(10, 9, 0),
(10, 10, 0),
(10, 11, 10),
(10, 12, 10),
(11, 1, 0),
(11, 2, 0),
(11, 3, 0),
(11, 4, 0),
(11, 5, 0),
(11, 6, 0),
(11, 7, 0),
(11, 8, 0),
(11, 9, 0),
(11, 10, 0),
(11, 11, 5),
(11, 12, 5),
(12, 1, 0),
(12, 2, 0),
(12, 3, 0),
(12, 4, 0),
(12, 5, 0),
(12, 6, 0),
(12, 7, 0),
(12, 8, 0),
(12, 9, 0),
(12, 10, 0),
(12, 11, 0),
(12, 12, 0),
(13, 1, 0),
(13, 2, 0),
(13, 3, 0),
(13, 4, 0),
(13, 5, 0),
(13, 6, 0),
(13, 7, 0),
(13, 8, 0),
(13, 9, 0),
(13, 10, 0),
(13, 11, 0),
(13, 12, 0),
(14, 1, 0),
(14, 2, 0),
(14, 3, 0),
(14, 4, 0),
(14, 5, 0),
(14, 6, 0),
(14, 7, 5),
(14, 8, 0),
(14, 9, 0),
(14, 10, 0),
(14, 11, 0),
(14, 12, 0),
(15, 1, 0),
(15, 2, 0),
(15, 3, 0),
(15, 4, 0),
(15, 5, 0),
(15, 6, 0),
(15, 7, 0),
(15, 8, 0),
(15, 9, 0),
(15, 10, 0),
(15, 11, 0),
(15, 12, 0),
(16, 1, 0),
(16, 2, 0),
(16, 3, 0),
(16, 4, 0),
(16, 5, 0),
(16, 6, 0),
(16, 7, 0),
(16, 8, 0),
(16, 9, 0),
(16, 10, 0),
(16, 11, 0),
(16, 12, 0),
(17, 1, 0),
(17, 2, 0),
(17, 3, 0),
(17, 4, 0),
(17, 5, 0),
(17, 6, 0),
(17, 7, 0),
(17, 8, 0),
(17, 9, 0),
(17, 10, 0),
(17, 11, 0),
(17, 12, 0),
(18, 1, 0),
(18, 2, 0),
(18, 3, 0),
(18, 4, 0),
(18, 5, 0),
(18, 6, 0),
(18, 7, 0),
(18, 8, 0),
(18, 9, 0),
(18, 10, 0),
(18, 11, 0),
(18, 12, 0),
(19, 1, 0),
(19, 2, 0),
(19, 3, 0),
(19, 4, 0),
(19, 5, 0),
(19, 6, 0),
(19, 7, 0),
(19, 8, 0),
(19, 9, 0),
(19, 10, 0),
(19, 11, 0),
(19, 12, 0),
(20, 1, 0),
(20, 2, 0),
(20, 3, 0),
(20, 4, 0),
(20, 5, 0),
(20, 6, 0),
(20, 7, 0),
(20, 8, 0),
(20, 9, 0),
(20, 10, 0),
(20, 11, 0),
(20, 12, 0),
(21, 1, 0),
(21, 2, 0),
(21, 3, 0),
(21, 4, 0),
(21, 5, 0),
(21, 6, 0),
(21, 7, 0),
(21, 8, 0),
(21, 9, 0),
(21, 10, 0),
(21, 11, 0),
(21, 12, 0),
(22, 1, 0),
(22, 2, 0),
(22, 3, 0),
(22, 4, 0),
(22, 5, 0),
(22, 6, 0),
(22, 7, 5),
(22, 8, 0),
(22, 9, 0),
(22, 10, 0),
(22, 11, 0),
(22, 12, 0),
(23, 1, 0),
(23, 2, 0),
(23, 3, 2),
(23, 4, 0),
(23, 5, 0),
(23, 6, 0),
(23, 7, 0),
(23, 8, 0),
(23, 9, 0),
(23, 10, 0),
(23, 11, 0),
(23, 12, 0),
(24, 1, 0),
(24, 2, 0),
(24, 3, 0),
(24, 4, 0),
(24, 5, 0),
(24, 6, 0),
(24, 7, 0),
(24, 8, 0),
(24, 9, 0),
(24, 10, 0),
(24, 11, 0),
(24, 12, 0),
(25, 1, 0),
(25, 2, 0),
(25, 3, 0),
(25, 4, 0),
(25, 5, 0),
(25, 6, 0),
(25, 7, 0),
(25, 8, 0),
(25, 9, 0),
(25, 10, 0),
(25, 11, 0),
(25, 12, 0),
(26, 1, 0),
(26, 2, 0),
(26, 3, 0),
(26, 4, 0),
(26, 5, 0),
(26, 6, 1),
(26, 7, 0),
(26, 8, 0),
(26, 9, 0),
(26, 10, 0),
(26, 11, 0),
(26, 12, 0),
(27, 1, 5),
(27, 2, 5),
(27, 3, 0),
(27, 4, 0),
(27, 5, 0),
(27, 6, 0),
(27, 7, 0),
(27, 8, 0),
(27, 9, 0),
(27, 10, 0),
(27, 11, 0),
(27, 12, 0),
(28, 1, 0),
(28, 2, 0),
(28, 3, 0),
(28, 4, 0),
(28, 5, 0),
(28, 6, 0),
(28, 7, 0),
(28, 8, 0),
(28, 9, 0),
(28, 10, 0),
(28, 11, 0),
(28, 12, 0),
(29, 1, 0),
(29, 2, 0),
(29, 3, 0),
(29, 4, 0),
(29, 5, 0),
(29, 6, 0),
(29, 7, 0),
(29, 8, 0),
(29, 9, 0),
(29, 10, 0),
(29, 11, 0),
(29, 12, 0),
(30, 1, 5),
(30, 2, 0),
(30, 3, 0),
(30, 4, 0),
(30, 5, 0),
(30, 6, 0),
(30, 7, 0),
(30, 8, 0),
(30, 9, 0),
(30, 10, 0),
(30, 11, 0),
(30, 12, 0),
(31, 1, 5),
(31, 2, 0),
(31, 3, 0),
(31, 4, 0),
(31, 5, 0),
(31, 6, 0),
(31, 7, 0),
(31, 8, 0),
(31, 9, 0),
(31, 10, 0),
(31, 11, 0),
(31, 12, 0),
(32, 1, 5),
(32, 2, 0),
(32, 3, 0),
(32, 4, 0),
(32, 5, 0),
(32, 6, 0),
(32, 7, 0),
(32, 8, 0),
(32, 9, 0),
(32, 10, 0),
(32, 11, 0),
(32, 12, 0),
(33, 1, 0),
(33, 2, 5),
(33, 3, 0),
(33, 4, 0),
(33, 5, 0),
(33, 6, 0),
(33, 7, 0),
(33, 8, 0),
(33, 9, 0),
(33, 10, 0),
(33, 11, 0),
(33, 12, 0),
(34, 1, 0),
(34, 2, 0),
(34, 3, 0),
(34, 4, 0),
(34, 5, 0),
(34, 6, 0),
(34, 7, 0),
(34, 8, 0),
(34, 9, 0),
(34, 10, 0),
(34, 11, 0),
(34, 12, 0),
(35, 1, 0),
(35, 2, 0),
(35, 3, 0),
(35, 4, 0),
(35, 5, 0),
(35, 6, 0),
(35, 7, 0),
(35, 8, 0),
(35, 9, 0),
(35, 10, 0),
(35, 11, 0),
(35, 12, 0),
(36, 1, 0),
(36, 2, 0),
(36, 3, 0),
(36, 4, 0),
(36, 5, 0),
(36, 6, 0),
(36, 7, 0),
(36, 8, 0),
(36, 9, 0),
(36, 10, 0),
(36, 11, 0),
(36, 12, 0),
(37, 1, 0),
(37, 2, 0),
(37, 3, 0),
(37, 4, 0),
(37, 5, 0),
(37, 6, 0),
(37, 7, 0),
(37, 8, 0),
(37, 9, 0),
(37, 10, 0),
(37, 11, 0),
(37, 12, 0);

REPLACE INTO `pstreenodessecondarystatselementalresistsdata` (`idNode`, `idElementType`, `value`) VALUES
(1, 1, 0),
(1, 2, 0),
(1, 3, 0),
(1, 4, 0),
(1, 5, 0),
(1, 6, 0),
(1, 7, 0),
(2, 1, 0),
(2, 2, 0),
(2, 3, 0),
(2, 4, 0),
(2, 5, 0),
(2, 6, 0),
(2, 7, 0),
(3, 1, 0),
(3, 2, 0),
(3, 3, 0),
(3, 4, 0),
(3, 5, 0),
(3, 6, 0),
(3, 7, 0),
(4, 1, 1),
(4, 2, 1),
(4, 3, 1),
(4, 4, 1),
(4, 5, 1),
(4, 6, 0),
(4, 7, 0),
(5, 1, 0),
(5, 2, 0),
(5, 3, 0),
(5, 4, 2),
(5, 5, 0),
(5, 6, 0),
(5, 7, 0),
(6, 1, 0),
(6, 2, 0),
(6, 3, 0),
(6, 4, 0),
(6, 5, 2),
(6, 6, 0),
(6, 7, 0),
(7, 1, 0),
(7, 2, 0),
(7, 3, 2),
(7, 4, 0),
(7, 5, 0),
(7, 6, 0),
(7, 7, 0),
(8, 1, 0),
(8, 2, 2),
(8, 3, 0),
(8, 4, 0),
(8, 5, 0),
(8, 6, 0),
(8, 7, 0),
(9, 1, 0),
(9, 2, 0),
(9, 3, 0),
(9, 4, 0),
(9, 5, 0),
(9, 6, 0),
(9, 7, 0),
(10, 1, 5),
(10, 2, 0),
(10, 3, 0),
(10, 4, 0),
(10, 5, 0),
(10, 6, 0),
(10, 7, 0),
(11, 1, 0),
(11, 2, 0),
(11, 3, 0),
(11, 4, 0),
(11, 5, 0),
(11, 6, 0),
(11, 7, 0),
(12, 1, 1),
(12, 2, 1),
(12, 3, 1),
(12, 4, 1),
(12, 5, 1),
(12, 6, 0),
(12, 7, 0),
(13, 1, 0),
(13, 2, 0),
(13, 3, 0),
(13, 4, 0),
(13, 5, 0),
(13, 6, 0),
(13, 7, 0),
(14, 1, 0),
(14, 2, 0),
(14, 3, 0),
(14, 4, 0),
(14, 5, 0),
(14, 6, 0),
(14, 7, 0),
(15, 1, 1),
(15, 2, 1),
(15, 3, 1),
(15, 4, 1),
(15, 5, 1),
(15, 6, 0),
(15, 7, 0),
(16, 1, 0),
(16, 2, 2),
(16, 3, 0),
(16, 4, 0),
(16, 5, 0),
(16, 6, 0),
(16, 7, 0),
(17, 1, 0),
(17, 2, 0),
(17, 3, 2),
(17, 4, 0),
(17, 5, 0),
(17, 6, 0),
(17, 7, 0),
(18, 1, 0),
(18, 2, 0),
(18, 3, 0),
(18, 4, 0),
(18, 5, 2),
(18, 6, 0),
(18, 7, 0),
(19, 1, 0),
(19, 2, 0),
(19, 3, 0),
(19, 4, 2),
(19, 5, 0),
(19, 6, 0),
(19, 7, 0),
(20, 1, 0),
(20, 2, 0),
(20, 3, 0),
(20, 4, 0),
(20, 5, 0),
(20, 6, 0),
(20, 7, 0),
(21, 1, 0),
(21, 2, 0),
(21, 3, 0),
(21, 4, 0),
(21, 5, 0),
(21, 6, 0),
(21, 7, 0),
(22, 1, 0),
(22, 2, 0),
(22, 3, 0),
(22, 4, 0),
(22, 5, 0),
(22, 6, 0),
(22, 7, 0),
(23, 1, 0),
(23, 2, 0),
(23, 3, 0),
(23, 4, 0),
(23, 5, 0),
(23, 6, 0),
(23, 7, 0),
(24, 1, 0),
(24, 2, 0),
(24, 3, 0),
(24, 4, 0),
(24, 5, 0),
(24, 6, 0),
(24, 7, 0),
(25, 1, 0),
(25, 2, 0),
(25, 3, 0),
(25, 4, 0),
(25, 5, 0),
(25, 6, 0),
(25, 7, 0),
(26, 1, 0),
(26, 2, 0),
(26, 3, 0),
(26, 4, 0),
(26, 5, 0),
(26, 6, 0),
(26, 7, 0),
(27, 1, 0),
(27, 2, 0),
(27, 3, 0),
(27, 4, 0),
(27, 5, 0),
(27, 6, 0),
(27, 7, 0),
(28, 1, 0),
(28, 2, 0),
(28, 3, 0),
(28, 4, 5),
(28, 5, 0),
(28, 6, 0),
(28, 7, 0),
(29, 1, 1),
(29, 2, 1),
(29, 3, 1),
(29, 4, 1),
(29, 5, 1),
(29, 6, 0),
(29, 7, 0),
(30, 1, 0),
(30, 2, 0),
(30, 3, 0),
(30, 4, 0),
(30, 5, 0),
(30, 6, 0),
(30, 7, 0),
(31, 1, 0),
(31, 2, 0),
(31, 3, 0),
(31, 4, 0),
(31, 5, 0),
(31, 6, 0),
(31, 7, 0),
(32, 1, 0),
(32, 2, 0),
(32, 3, 0),
(32, 4, 0),
(32, 5, 0),
(32, 6, 0),
(32, 7, 0),
(33, 1, 0),
(33, 2, 0),
(33, 3, 0),
(33, 4, 0),
(33, 5, 0),
(33, 6, 0),
(33, 7, 0),
(34, 1, 0),
(34, 2, 2),
(34, 3, 0),
(34, 4, 0),
(34, 5, 0),
(34, 6, 0),
(34, 7, 0),
(35, 1, 0),
(35, 2, 0),
(35, 3, 2),
(35, 4, 0),
(35, 5, 0),
(35, 6, 0),
(35, 7, 0),
(36, 1, 0),
(36, 2, 0),
(36, 3, 0),
(36, 4, 0),
(36, 5, 2),
(36, 6, 0),
(36, 7, 0),
(37, 1, 0),
(37, 2, 0),
(37, 3, 0),
(37, 4, 2),
(37, 5, 0),
(37, 6, 0),
(37, 7, 0);

REPLACE INTO `pstreenodesskillsunlockdata` (`idNode`, `idSkill`) VALUES
(1, 1),
(26, 2),
(13, 3),
(8, 4),
(7, 5),
(5, 6),
(6, 7),
(34, 8),
(35, 9),
(37, 10),
(36, 11),
(16, 12),
(17, 13),
(19, 14),
(18, 15),
(28, 16),
(32, 17),
(11, 18),
(21, 19),
(22, 20),
(23, 21),
(24, 22),
(25, 23),
(20, 24),
(31, 25),
(27, 26),
(2, 27),
(10, 27);

REPLACE INTO `pstreenodesstatsdata` (`idNode`, `idStat`, `value`) VALUES
(1, 1, 1),
(1, 2, 1),
(1, 3, 2),
(1, 4, 0),
(1, 5, 1),
(1, 6, 0),
(1, 7, 0),
(1, 8, 0),
(1, 9, 0),
(1, 10, 0),
(2, 1, 3),
(2, 2, 0),
(2, 3, 2),
(2, 4, 0),
(2, 5, 0),
(2, 6, 0),
(2, 7, 0),
(2, 8, 0),
(2, 9, 0),
(2, 10, 0),
(3, 1, 10),
(3, 2, 0),
(3, 3, 0),
(3, 4, 0),
(3, 5, 0),
(3, 6, 0),
(3, 7, 0),
(3, 8, 0),
(3, 9, 0),
(3, 10, 0),
(4, 1, 10),
(4, 2, 0),
(4, 3, 0),
(4, 4, 0),
(4, 5, 0),
(4, 6, 0),
(4, 7, 0),
(4, 8, 0),
(4, 9, 0),
(4, 10, 0),
(5, 1, 12),
(5, 2, 0),
(5, 3, 3),
(5, 4, 0),
(5, 5, 0),
(5, 6, 0),
(5, 7, 0),
(5, 8, 0),
(5, 9, 0),
(5, 10, 0),
(6, 1, 12),
(6, 2, 0),
(6, 3, 3),
(6, 4, 0),
(6, 5, 0),
(6, 6, 0),
(6, 7, 0),
(6, 8, 0),
(6, 9, 0),
(6, 10, 0),
(7, 1, 12),
(7, 2, 0),
(7, 3, 3),
(7, 4, 0),
(7, 5, 0),
(7, 6, 0),
(7, 7, 0),
(7, 8, 0),
(7, 9, 0),
(7, 10, 0),
(8, 1, 12),
(8, 2, 0),
(8, 3, 3),
(8, 4, 0),
(8, 5, 0),
(8, 6, 0),
(8, 7, 0),
(8, 8, 0),
(8, 9, 0),
(8, 10, 0),
(9, 1, 5),
(9, 2, 0),
(9, 3, 5),
(9, 4, 0),
(9, 5, 0),
(9, 6, 0),
(9, 7, 0),
(9, 8, 0),
(9, 9, 0),
(9, 10, 0),
(10, 1, 0),
(10, 2, 0),
(10, 3, 10),
(10, 4, 0),
(10, 5, 0),
(10, 6, 0),
(10, 7, 0),
(10, 8, 0),
(10, 9, 0),
(10, 10, 0),
(11, 1, 0),
(11, 2, 0),
(11, 3, 10),
(11, 4, 0),
(11, 5, 0),
(11, 6, 0),
(11, 7, 0),
(11, 8, 0),
(11, 9, 0),
(11, 10, 0),
(12, 1, 0),
(12, 2, 0),
(12, 3, 10),
(12, 4, 0),
(12, 5, 0),
(12, 6, 0),
(12, 7, 0),
(12, 8, 0),
(12, 9, 0),
(12, 10, 0),
(13, 1, 0),
(13, 2, 5),
(13, 3, 0),
(13, 4, 0),
(13, 5, 0),
(13, 6, 1),
(13, 7, 0),
(13, 8, 0),
(13, 9, 0),
(13, 10, 0),
(14, 1, 0),
(14, 2, 10),
(14, 3, 0),
(14, 4, 0),
(14, 5, 0),
(14, 6, 0),
(14, 7, 0),
(14, 8, 0),
(14, 9, 0),
(14, 10, 0),
(15, 1, 0),
(15, 2, 5),
(15, 3, 0),
(15, 4, 0),
(15, 5, 0),
(15, 6, 5),
(15, 7, 0),
(15, 8, 0),
(15, 9, 0),
(15, 10, 0),
(16, 1, 0),
(16, 2, 10),
(16, 3, 0),
(16, 4, 0),
(16, 5, 0),
(16, 6, 5),
(16, 7, 0),
(16, 8, 0),
(16, 9, 0),
(16, 10, 0),
(17, 1, 0),
(17, 2, 10),
(17, 3, 0),
(17, 4, 0),
(17, 5, 0),
(17, 6, 5),
(17, 7, 0),
(17, 8, 0),
(17, 9, 0),
(17, 10, 0),
(18, 1, 0),
(18, 2, 10),
(18, 3, 0),
(18, 4, 0),
(18, 5, 0),
(18, 6, 5),
(18, 7, 0),
(18, 8, 0),
(18, 9, 0),
(18, 10, 0),
(19, 1, 0),
(19, 2, 10),
(19, 3, 0),
(19, 4, 0),
(19, 5, 0),
(19, 6, 5),
(19, 7, 0),
(19, 8, 0),
(19, 9, 0),
(19, 10, 0),
(20, 1, 0),
(20, 2, 0),
(20, 3, 0),
(20, 4, 0),
(20, 5, 0),
(20, 6, 10),
(20, 7, 0),
(20, 8, 0),
(20, 9, 0),
(20, 10, 0),
(21, 1, 0),
(21, 2, 10),
(21, 3, 0),
(21, 4, 0),
(21, 5, 0),
(21, 6, 10),
(21, 7, 0),
(21, 8, 0),
(21, 9, 0),
(21, 10, 0),
(22, 1, 0),
(22, 2, 10),
(22, 3, 0),
(22, 4, 0),
(22, 5, 0),
(22, 6, 10),
(22, 7, 0),
(22, 8, 0),
(22, 9, 0),
(22, 10, 0),
(23, 1, 0),
(23, 2, 25),
(23, 3, 0),
(23, 4, 0),
(23, 5, 0),
(23, 6, 10),
(23, 7, 0),
(23, 8, 0),
(23, 9, 0),
(23, 10, 0),
(24, 1, 0),
(24, 2, 5),
(24, 3, 0),
(24, 4, 0),
(24, 5, 0),
(24, 6, 5),
(24, 7, 0),
(24, 8, 0),
(24, 9, 0),
(24, 10, 0),
(25, 1, 0),
(25, 2, 10),
(25, 3, 0),
(25, 4, 0),
(25, 5, 0),
(25, 6, 10),
(25, 7, 0),
(25, 8, 0),
(25, 9, 0),
(25, 10, 0),
(26, 1, 0),
(26, 2, 0),
(26, 3, 0),
(26, 4, 0),
(26, 5, 5),
(26, 6, 0),
(26, 7, 0),
(26, 8, 0),
(26, 9, 0),
(26, 10, 0),
(27, 1, 0),
(27, 2, 0),
(27, 3, 0),
(27, 4, 0),
(27, 5, 10),
(27, 6, 0),
(27, 7, 0),
(27, 8, 0),
(27, 9, 0),
(27, 10, 0),
(28, 1, 0),
(28, 2, 0),
(28, 3, 0),
(28, 4, 0),
(28, 5, 10),
(28, 6, 0),
(28, 7, 0),
(28, 8, 0),
(28, 9, 0),
(28, 10, 0),
(29, 1, 0),
(29, 2, 0),
(29, 3, 0),
(29, 4, 0),
(29, 5, 5),
(29, 6, 0),
(29, 7, 0),
(29, 8, 5),
(29, 9, 0),
(29, 10, 0),
(30, 1, 0),
(30, 2, 0),
(30, 3, 0),
(30, 4, 0),
(30, 5, 0),
(30, 6, 0),
(30, 7, 0),
(30, 8, 10),
(30, 9, 0),
(30, 10, 10),
(31, 1, 0),
(31, 2, 0),
(31, 3, 0),
(31, 4, 0),
(31, 5, 10),
(31, 6, 0),
(31, 7, 0),
(31, 8, 0),
(31, 9, 0),
(31, 10, 0),
(32, 1, 0),
(32, 2, 0),
(32, 3, 0),
(32, 4, 0),
(32, 5, 10),
(32, 6, 0),
(32, 7, 0),
(32, 8, 0),
(32, 9, 0),
(32, 10, 0),
(33, 1, 0),
(33, 2, 0),
(33, 3, 0),
(33, 4, 0),
(33, 5, 10),
(33, 6, 0),
(33, 7, 0),
(33, 8, 0),
(33, 9, 0),
(33, 10, 0),
(34, 1, 0),
(34, 2, 0),
(34, 3, 0),
(34, 4, 0),
(34, 5, 10),
(34, 6, 0),
(34, 7, 0),
(34, 8, 5),
(34, 9, 0),
(34, 10, 0),
(35, 1, 0),
(35, 2, 0),
(35, 3, 0),
(35, 4, 0),
(35, 5, 10),
(35, 6, 0),
(35, 7, 0),
(35, 8, 5),
(35, 9, 0),
(35, 10, 0),
(36, 1, 0),
(36, 2, 0),
(36, 3, 0),
(36, 4, 0),
(36, 5, 10),
(36, 6, 0),
(36, 7, 0),
(36, 8, 5),
(36, 9, 0),
(36, 10, 0),
(37, 1, 0),
(37, 2, 0),
(37, 3, 0),
(37, 4, 0),
(37, 5, 10),
(37, 6, 0),
(37, 7, 0),
(37, 8, 5),
(37, 9, 0),
(37, 10, 0);

REPLACE INTO `pstreepossiblesnodesvisuals` (`idNode`, `icon`) VALUES
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
(61, 'https://i.ibb.co/LJM2fdw/world.png'),
(62, 'https://i.ibb.co/RPRPBHf/loosepng.png'),
(63, 'https://i.ibb.co/Wk2QsVr/elements.png'),
(64, 'https://i.ibb.co/xstV4KL/rock-shards.png'),
(65, 'https://i.ibb.co/THSmpp9/smoke-bomb.png'),
(66, 'https://i.ibb.co/BBTh9Lp/venom-bomb.png'),
(67, 'https://i.ibb.co/XbnYNn5/flaming-arrow.png'),
(68, 'https://i.ibb.co/JmRCK5K/stone-arrow.png'),
(69, 'https://i.ibb.co/HpZQmjn/windy-arrow.png'),
(70, 'https://i.ibb.co/9p8JpQw/ice-arrow.png'),
(71, 'https://i.ibb.co/F3NbcBX/cold-blow.png'),
(72, 'https://i.ibb.co/8Xk59QM/windy-blow.png'),
(73, 'https://i.ibb.co/JxkZRnP/eaarthy-blow.png'),
(74, 'https://i.ibb.co/cxszLjG/heal.png');

REPLACE INTO `skills` (`idSkill`, `shorthand`, `idSkillType`, `energyCost`, `manaCost`, `idTargetRange`) VALUES
(1, 'melee_attack', NULL, 0, 0, 2),
(2, 'distant_attack', NULL, 0, 0, 2),
(3, 'magic_bolt', 1, 0, 0, 2),
(4, 'flaming_blow', NULL, 30, 0, 2),
(5, 'cold_blow', NULL, 30, 0, 2),
(6, 'earthy_blow', NULL, 30, 0, 2),
(7, 'windy_blow', NULL, 30, 0, 2),
(8, 'flaming_arrow', NULL, 50, 10, 2),
(9, 'ice_arrow', NULL, 50, 10, 2),
(10, 'stone_arrow', NULL, 50, 10, 2),
(11, 'windy_arrow', NULL, 50, 10, 2),
(12, 'fireball', 1, 0, 100, 2),
(13, 'ice_shards', 1, 0, 100, 2),
(14, 'rock_shards', 1, 0, 100, 2),
(15, 'focused_tornado', 1, 0, 100, 2),
(16, 'venom', NULL, 20, 20, 2),
(17, 'toxic_bomb', NULL, 20, 20, 4),
(18, 'taunt', 2, 20, 0, 14),
(19, 'self_regen boost', 1, 0, 35, 14),
(20, 'group_regen boost', 1, 0, 75, 9),
(21, 'self_heal', 1, 0, 50, 14),
(22, 'heal', 1, 0, 75, 6),
(23, 'group_heal', 1, 0, 110, 9),
(24, 'resurrect', 1, 0, 95, 10),
(25, 'smoke_bomb', NULL, 20, 20, 4),
(26, 'deceit', 1, 20, 0, 14),
(27, 'defend', 2, 20, 0, 14),
(28, 'enrage', 2, 0, 0, 14),
(29, 'animal_bite', NULL, 20, 0, 2),
(30, 'poisonous_bite', NULL, 20, 0, 2),
(31, 'charge', NULL, 20, 0, 2);

REPLACE INTO `states` (`idState`, `idStateRestriction`, `shorthand`) VALUES
(1, 4, 'stun'),
(2, NULL, 'defense'),
(3, NULL, 'regeneration'),
(4, NULL, 'poison'),
(5, NULL, 'blind'),
(6, NULL, 'provoke'),
(7, 1, 'hide'),
(8, NULL, 'heal_resistant'),
(9, NULL, 'enraged'),
(10, NULL, 'bleed');

REPLACE INTO `statesremovalconditions` (`idState`, `afterFight`, `afterRounds`, `roundMin`, `roundMax`, `afterDamage`, `damageProbability`) VALUES
(1, 1, 1, 1, 1, 0, 100),
(2, 1, 1, 2, 4, 0, 100),
(3, 1, 1, 2, 3, 0, 100),
(4, 1, 1, 1, 3, 0, 100),
(5, 1, 1, 1, 2, 0, 100),
(6, 1, 1, 3, 4, 0, 100),
(7, 1, 1, 2, 4, 0, 50),
(8, 1, 1, 1, 1, 0, 20),
(9, 1, 1, 2, 3, 0, 50),
(10, 1, 1, 2, 2, 0, 100);

REPLACE INTO `statestraits` (`idState`, `idTrait`) VALUES
(1, 1),
(2, 2),
(2, 3),
(3, 4),
(3, 5),
(3, 6),
(4, 7),
(5, 8),
(5, 9),
(6, 10),
(7, 11),
(8, 12),
(9, 13),
(9, 14),
(9, 15),
(9, 16),
(10, 17),
(10, 18);

REPLACE INTO `traits` (`idTrait`, `idTraitType`, `valueFloat`, `valueState`, `valueElementType`, `valueSkillType`, `valueStat`, `valueSkill`, `valueSecondaryStat`) VALUES
(1, 9, -1, NULL, NULL, NULL, NULL, NULL, 2),
(2, 3, 1.1, NULL, NULL, NULL, NULL, NULL, NULL),
(3, 3, 1.1, NULL, NULL, NULL, NULL, NULL, NULL),
(4, 9, 0.1, NULL, NULL, NULL, NULL, NULL, 4),
(5, 9, 0.1, NULL, NULL, NULL, NULL, NULL, 5),
(6, 9, 0.1, NULL, NULL, NULL, NULL, NULL, 6),
(7, 9, -0.1, NULL, NULL, NULL, NULL, NULL, 4),
(8, 9, -0.5, NULL, NULL, NULL, NULL, NULL, 1),
(9, 9, -0.5, NULL, NULL, NULL, NULL, NULL, 2),
(10, 9, 2, NULL, NULL, NULL, NULL, NULL, 11),
(11, 9, 0, NULL, NULL, NULL, NULL, NULL, 11),
(12, 9, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(13, 3, 1, NULL, NULL, NULL, NULL, NULL, NULL),
(14, 3, 1, NULL, NULL, NULL, NULL, NULL, NULL),
(15, 3, 0.7, NULL, NULL, NULL, NULL, NULL, NULL),
(16, 3, 0.7, NULL, NULL, NULL, NULL, NULL, NULL),
(17, 9, -0.1, NULL, NULL, NULL, NULL, NULL, 4),
(18, 9, -0.2, NULL, NULL, NULL, NULL, NULL, 1);


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
(1, 12, 0, 0),    

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
(2, 12, 0, 0),    

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
(3, 12, 0, 0),    

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
(4, 12, 0, 0),    

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
(5, 12, 0, 0),    

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
(6, 12, 0, 0),    

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
(7, 12, 0, 0),    

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
(8, 12, 0, 0),    

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
(9, 12, 0, 0),    

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
(10, 12, 0, 0),   

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
(11, 12, 0, 0),   

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
(12, 12, 0, 0),   

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
(13, 12, 0, 0),   

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
(14, 12, 7, 0),   

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
(15, 12, 7, 0),   

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
(16, 12, 7, 0),

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
(17, 12, 0, 0),

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
(18, 11, 0, 0),
(18, 12, 0, 0);

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

(4, 2, 0),
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

-- Changing to big int for items ids => more future proof

ALTER TABLE `discord_bot_rpg`.`items` 
DROP FOREIGN KEY `fk_Items_ItemsBase1`,
DROP FOREIGN KEY `fk_Items_LevelsRequire1`;

ALTER TABLE `discord_bot_rpg`.`itemsstats` 
DROP FOREIGN KEY `fk_ItemsStats_Items1`,
DROP FOREIGN KEY `fk_ItemsStats_Stats1`;

ALTER TABLE `discord_bot_rpg`.`charactersinventory` 
DROP FOREIGN KEY `fk_CharactersInventory_Characters1`,
DROP FOREIGN KEY `fk_CharactersInventory_Items1`;

ALTER TABLE `discord_bot_rpg`.`charactersequipements` 
DROP FOREIGN KEY `fk_CharactersEquipements_Characters1`,
DROP FOREIGN KEY `fk_CharactersEquipements_Items1`,
DROP FOREIGN KEY `fk_CharactersEquipements_ItemsTypes1`;

ALTER TABLE `discord_bot_rpg`.`marketplacesorders` 
DROP FOREIGN KEY `fk_MarketplacesOrders_Marketplaces1`,
DROP FOREIGN KEY `fk_MarketplacesOrders_Items1`,
DROP FOREIGN KEY `fk_MarketplacesOrders_Characters1`;

ALTER TABLE `discord_bot_rpg`.`itemspower` 
DROP FOREIGN KEY `fk_ItemsPower_Items1`;

ALTER TABLE `discord_bot_rpg`.`itemssecondarystats` 
DROP FOREIGN KEY `fk_ItemsSecondaryStats_Items1`,
DROP FOREIGN KEY `fk_ItemsSecondaryStats_SecondaryStats1`;

ALTER TABLE `discord_bot_rpg`.`itemssecondarystatselementalresists` 
DROP FOREIGN KEY `fk_ItemsSecondaryStatsElementalResists_ElementsTypes1`,
DROP FOREIGN KEY `fk_ItemsSecondaryStatsElementalResists_Items1`;

ALTER TABLE `discord_bot_rpg`.`items` 
CHANGE COLUMN `idItem` `idItem` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT ;

ALTER TABLE `discord_bot_rpg`.`itemsstats` 
CHANGE COLUMN `idItem` `idItem` BIGINT UNSIGNED NOT NULL ;

ALTER TABLE `discord_bot_rpg`.`charactersinventory` 
CHANGE COLUMN `idItem` `idItem` BIGINT UNSIGNED NOT NULL ;

ALTER TABLE `discord_bot_rpg`.`charactersequipements` 
CHANGE COLUMN `idItem` `idItem` BIGINT UNSIGNED NOT NULL ;

ALTER TABLE `discord_bot_rpg`.`marketplacesorders` 
CHANGE COLUMN `idItem` `idItem` BIGINT UNSIGNED NOT NULL ,
CHANGE COLUMN `price` `price` BIGINT UNSIGNED NOT NULL DEFAULT 1 ,
ADD INDEX `fk_MarketplacesOrders_Items1_idx` (`idItem` ASC) VISIBLE,
ADD INDEX `fk_MarketplacesOrders_Characters1_idx` (`idCharacter` ASC) VISIBLE,
DROP INDEX `fk_MarketplacesOrders_Characters1_idx` ,
DROP INDEX `fk_MarketplacesOrders_Items1_idx` ;

ALTER TABLE `discord_bot_rpg`.`itemspower` 
CHANGE COLUMN `idItem` `idItem` BIGINT UNSIGNED NOT NULL ;

ALTER TABLE `discord_bot_rpg`.`itemssecondarystats` 
CHARACTER SET = utf8mb4 , COLLATE = utf8mb4_unicode_ci ,
CHANGE COLUMN `idItem` `idItem` BIGINT UNSIGNED NOT NULL ;

ALTER TABLE `discord_bot_rpg`.`itemssecondarystatselementalresists` 
CHANGE COLUMN `idItem` `idItem` BIGINT UNSIGNED NOT NULL ;

ALTER TABLE `discord_bot_rpg`.`items` 
ADD CONSTRAINT `fk_Items_ItemsBase1`
  FOREIGN KEY (`idBaseItem`)
  REFERENCES `discord_bot_rpg`.`itemsbase` (`idBaseItem`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_Items_LevelsRequire1`
  FOREIGN KEY (`level`)
  REFERENCES `discord_bot_rpg`.`levelsrequire` (`level`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `discord_bot_rpg`.`itemsstats` 
ADD CONSTRAINT `fk_ItemsStats_Items1`
  FOREIGN KEY (`idItem`)
  REFERENCES `discord_bot_rpg`.`items` (`idItem`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_ItemsStats_Stats1`
  FOREIGN KEY (`idStat`)
  REFERENCES `discord_bot_rpg`.`stats` (`idStat`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `discord_bot_rpg`.`charactersinventory` 
ADD CONSTRAINT `fk_CharactersInventory_Characters1`
  FOREIGN KEY (`idCharacter`)
  REFERENCES `discord_bot_rpg`.`characters` (`idCharacter`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_CharactersInventory_Items1`
  FOREIGN KEY (`idItem`)
  REFERENCES `discord_bot_rpg`.`items` (`idItem`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `discord_bot_rpg`.`charactersequipements` 
ADD CONSTRAINT `fk_CharactersEquipements_Characters1`
  FOREIGN KEY (`idCharacter`)
  REFERENCES `discord_bot_rpg`.`characters` (`idCharacter`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_CharactersEquipements_Items1`
  FOREIGN KEY (`idItem`)
  REFERENCES `discord_bot_rpg`.`items` (`idItem`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_CharactersEquipements_ItemsTypes1`
  FOREIGN KEY (`idType`)
  REFERENCES `discord_bot_rpg`.`itemstypes` (`idType`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `discord_bot_rpg`.`marketplacesorders` 
ADD CONSTRAINT `fk_MarketplacesOrders_Marketplaces1`
  FOREIGN KEY (`idMarketplace`)
  REFERENCES `discord_bot_rpg`.`marketplaces` (`idMarketplace`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_MarketplacesOrders_Items1`
  FOREIGN KEY (`idItem`)
  REFERENCES `discord_bot_rpg`.`items` (`idItem`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_MarketplacesOrders_Characters1`
  FOREIGN KEY (`idCharacter`)
  REFERENCES `discord_bot_rpg`.`characters` (`idCharacter`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `discord_bot_rpg`.`itemspower` 
ADD CONSTRAINT `fk_ItemsPower_Items1`
  FOREIGN KEY (`idItem`)
  REFERENCES `discord_bot_rpg`.`items` (`idItem`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `discord_bot_rpg`.`itemssecondarystats` 
ADD CONSTRAINT `fk_ItemsSecondaryStats_Items1`
  FOREIGN KEY (`idItem`)
  REFERENCES `discord_bot_rpg`.`items` (`idItem`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_ItemsSecondaryStats_SecondaryStats1`
  FOREIGN KEY (`idSecondaryStat`)
  REFERENCES `discord_bot_rpg`.`secondarystats` (`idSecondaryStat`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `discord_bot_rpg`.`itemssecondarystatselementalresists` ADD CONSTRAINT `fk_ItemsSecondaryStatsElementalResists_Items1`
  FOREIGN KEY (`idItem`)
  REFERENCES `discord_bot_rpg`.`items` (`idItem`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_ItemsSecondaryStatsElementalResists_ElementsTypes1`
  FOREIGN KEY (`idElementType`)
  REFERENCES `discord_bot_rpg`.`elementstypes` (`idElementType`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
