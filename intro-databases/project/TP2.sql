-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Organization`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Organization` (
  `idOrg` INT NOT NULL AUTO_INCREMENT,
  `Name_org` VARCHAR(45) NOT NULL,
  `Contact_org` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idOrg`),
  UNIQUE INDEX `idOrganizacao_UNIQUE` (`idOrg` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Individual`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Individual` (
  `idInd` INT NOT NULL AUTO_INCREMENT,
  `Name_ind` VARCHAR(45) NOT NULL,
  `Birthday_ind` DATE NOT NULL,
  `idOrg` INT NOT NULL,
  `Country` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idInd`, `idOrg`),
  UNIQUE INDEX `idPessoas_UNIQUE` (`idInd` ASC),
  INDEX `idOrg_idx` (`idOrg` ASC),
  CONSTRAINT `idOrg`
    FOREIGN KEY (`idOrg`)
    REFERENCES `mydb`.`Organization` (`idOrg`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Freelancer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Freelancer` (
  `idFreelancer` INT NOT NULL AUTO_INCREMENT,
  `Name_free` VARCHAR(45) NOT NULL,
  `Email_free` VARCHAR(45) NOT NULL,
  `Country` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idFreelancer`),
  UNIQUE INDEX `Email_UNIQUE` (`Email_free` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Company`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Company` (
  `idCompany` INT NOT NULL AUTO_INCREMENT,
  `Name_comp` VARCHAR(45) NOT NULL,
  `Type_comp` VARCHAR(45) NOT NULL,
  `Contact_comp` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idCompany`),
  UNIQUE INDEX `NomeE_UNIQUE` (`Name_comp` ASC),
  UNIQUE INDEX `Contato_emp_UNIQUE` (`Contact_comp` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Press`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Press` (
  `idPress` INT NOT NULL AUTO_INCREMENT,
  `Name_press` VARCHAR(45) NOT NULL,
  `Type_press` VARCHAR(45) NOT NULL,
  `Email_press` VARCHAR(45) NOT NULL,
  `Website` VARCHAR(60) NULL,
  PRIMARY KEY (`idPress`),
  UNIQUE INDEX `Name_press_UNIQUE` (`Name_press` ASC),
  UNIQUE INDEX `Contact_press_UNIQUE` (`Email_press` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Freelancer_works-with_Organization`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Freelancer_works-with_Organization` (
  `Freelancer_idFreelancer` INT NOT NULL,
  `Organization_idOrg` INT NOT NULL,
  `Skills` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Freelancer_idFreelancer`, `Organization_idOrg`),
  INDEX `fk_Freelancer_has_Organization_Freelancer1_idx` (`Freelancer_idFreelancer` ASC),
  CONSTRAINT `fk_Freelancer_has_Organization_Freelancer1`
    FOREIGN KEY (`Freelancer_idFreelancer`)
    REFERENCES `mydb`.`Freelancer` (`idFreelancer`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Freelancer_has_Organization_Organization1`
    FOREIGN KEY (`Freelancer_idFreelancer` , `Organization_idOrg`)
    REFERENCES `mydb`.`Organization` (`idOrg` , `idOrg`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Company_sponsors_Organization`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Company_sponsors_Organization` (
  `Organization_idOrg` INT NOT NULL,
  `Company_idCompany` INT NOT NULL,
  `idSponsor` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`Organization_idOrg`, `Company_idCompany`),
  INDEX `fk_Organization_has_Company_Company1_idx` (`Company_idCompany` ASC),
  INDEX `fk_Organization_has_Company_Organization1_idx` (`Organization_idOrg` ASC),
  UNIQUE INDEX `idSponsor_UNIQUE` (`idSponsor` ASC),
  CONSTRAINT `fk_Organization_has_Company_Organization1`
    FOREIGN KEY (`Organization_idOrg`)
    REFERENCES `mydb`.`Organization` (`idOrg`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Organization_has_Company_Company1`
    FOREIGN KEY (`Company_idCompany`)
    REFERENCES `mydb`.`Company` (`idCompany`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Company_provides_Organization`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Company_provides_Organization` (
  `Organization_idOrg` INT NOT NULL,
  `Company_idCompany` INT NOT NULL,
  `What` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Organization_idOrg`, `Company_idCompany`),
  INDEX `fk_Organization_has_Company_Company2_idx` (`Company_idCompany` ASC),
  INDEX `fk_Organization_has_Company_Organization2_idx` (`Organization_idOrg` ASC),
  CONSTRAINT `fk_Organization_has_Company_Organization2`
    FOREIGN KEY (`Organization_idOrg`)
    REFERENCES `mydb`.`Organization` (`idOrg`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Organization_has_Company_Company2`
    FOREIGN KEY (`Company_idCompany`)
    REFERENCES `mydb`.`Company` (`idCompany`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Press_works-with_Organization`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Press_works-with_Organization` (
  `Organization_idOrg` INT NOT NULL,
  `Press_idPress` INT NOT NULL,
  `Media_link` VARCHAR(45) NULL,
  PRIMARY KEY (`Organization_idOrg`, `Press_idPress`),
  INDEX `fk_Organization_has_Press_Press1_idx` (`Press_idPress` ASC),
  INDEX `fk_Organization_has_Press_Organization1_idx` (`Organization_idOrg` ASC),
  UNIQUE INDEX `Link_UNIQUE` (`Media_link` ASC),
  CONSTRAINT `fk_Organization_has_Press_Organization1`
    FOREIGN KEY (`Organization_idOrg`)
    REFERENCES `mydb`.`Organization` (`idOrg`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Organization_has_Press_Press1`
    FOREIGN KEY (`Press_idPress`)
    REFERENCES `mydb`.`Press` (`idPress`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Location`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Location` (
  `Country` VARCHAR(45) NOT NULL,
  `State` VARCHAR(45) NOT NULL,
  `Street` VARCHAR(45) NOT NULL,
  `City` VARCHAR(45) NOT NULL,
  `Zip` INT(10) NOT NULL,
  `idOrg` INT NOT NULL,
  INDEX `idOrg_idx` (`idOrg` ASC),
  PRIMARY KEY (`idOrg`),
  CONSTRAINT `idOrg`
    FOREIGN KEY (`idOrg`)
    REFERENCES `mydb`.`Organization` (`idOrg`)
    ON DELETE CASCADE
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Loc_Comp`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Loc_Comp` (
  `idCompany` INT NOT NULL,
  `Country` VARCHAR(45) NOT NULL,
  `State` VARCHAR(45) NOT NULL,
  `Street` VARCHAR(45) NOT NULL,
  `Zip` VARCHAR(45) NOT NULL,
  `City` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idCompany`),
  CONSTRAINT `idCompany`
    FOREIGN KEY (`idCompany`)
    REFERENCES `mydb`.`Company` (`idCompany`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
