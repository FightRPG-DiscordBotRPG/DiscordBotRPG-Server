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
  `afterFight` TINYINT(4) NOT NULL DEFAULT 0,
  `afterRounds` TINYINT(4) NOT NULL DEFAULT 0,
  `roundMin` INT NOT NULL DEFAULT 0,
  `roundMax` INT NOT NULL DEFAULT 0,
  `afterDamage` TINYINT(4) NOT NULL DEFAULT 0,
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
  `variance` TINYINT(4) NOT NULL DEFAULT 0,
  `criticalHit` TINYINT(4) NOT NULL DEFAULT 0,
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


INSERT INTO statesrestrictions
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

INSERT INTO damagestypes
VALUES
(1, "hpDamage"),
(2, "manaDamage"),
(3, "lifeSteal"),
(4, "manaSteal"),
(5, "healHp"),
(6, "healMp");

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
(9, "physicalCriticalEvadeRate", ""),
(10, "magicalCriticalEvadeRate", "");



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
