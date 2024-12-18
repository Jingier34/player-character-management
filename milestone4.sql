-- Drop schema if it exists and recreate it
DROP SCHEMA IF EXISTS CS5200Project;
CREATE SCHEMA CS5200Project;
USE CS5200Project;

-- Create Players table
CREATE TABLE Players (
    playerID INT AUTO_INCREMENT,
    userName VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    CONSTRAINT PK_Player PRIMARY KEY (playerID)
);

-- Create CharacterInfo table
CREATE TABLE CharacterInfo (
    characterID INT AUTO_INCREMENT,
    playerID INT,
    firstName VARCHAR(50) UNIQUE NOT NULL,
    lastName VARCHAR(50) UNIQUE NOT NULL,
    maxHP INT NOT NULL,
    CONSTRAINT PK_Character PRIMARY KEY (characterID),
    CONSTRAINT FK_Character_Player FOREIGN KEY (playerID) 
        REFERENCES Players(playerID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Create CharacterJobs table
CREATE TABLE Jobs (
    jobID INT AUTO_INCREMENT,
    jobName VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Jobs PRIMARY KEY (jobID)
);

-- Create CharacterJobs table
CREATE TABLE CharacterJobs (
    characterID INT,
    jobID INT,
    level INT NOT NULL,
    experiencePoints INT NOT NULL,
    isCurrentJob BOOLEAN NOT NULL DEFAULT 0,
    CONSTRAINT PK_CharacterJobs PRIMARY KEY (characterID, jobID),
    CONSTRAINT FK_CharacterJobs_Character FOREIGN KEY (characterID) 
        REFERENCES CharacterInfo(characterID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_CharacterJobs_Job FOREIGN KEY (jobID) 
        REFERENCES Jobs(jobID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- create currency tables
CREATE TABLE Currencies (
	currencyID INT AUTO_INCREMENT,
	currencyName VARCHAR(50) NOT NULL, 
    max_amount INT NOT NULL,
    weeklycap INT NOT NULL,
    CONSTRAINT pk_Currencies_currencyID PRIMARY KEY (currencyID)
);

CREATE TABLE CharacterCurrencies (
    characterID INT,
    currencyID INT,
    totalAmountOwned INT NOT NULL,
    amountThisWeek INT NOT NULL,
    CONSTRAINT pk_CharacterCurrencies_characterID_currencyID PRIMARY KEY (characterID,currencyID),
    CONSTRAINT fk_CharacterCurrencies_characterID 
		FOREIGN KEY (characterID) REFERENCES CharacterInfo(characterID)
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	CONSTRAINT fk_CharacterCurrencies_currencyID 
		FOREIGN KEY (currencyID) REFERENCES Currencies(currencyID)
	ON DELETE CASCADE 
    ON UPDATE CASCADE
);

-- Create EquipmentSlots table (required by CharacterEquipments)
CREATE TABLE EquipmentSlots (
    slotID INT AUTO_INCREMENT,
    slotName VARCHAR(50) NOT NULL,
    CONSTRAINT PK_EquipmentSlot PRIMARY KEY (slotID)
);

CREATE TABLE Items (
    itemID INT AUTO_INCREMENT,
    itemName VARCHAR(200) NOT NULL,
    maxStackSize INT NOT NULL,
    marketAllowed BOOLEAN NOT NULL,
    vendorPrice INT NOT NULL,
    CONSTRAINT pk_Items_itemID PRIMARY KEY (itemID)
);

CREATE TABLE EquippableItems(
	itemID INT,
    itemLevel INT NOT NULL, 
    slotID INT,
    requiredLevel INT NOT NULL,
    CONSTRAINT pk_EquippableItems_itemID PRIMARY KEY(itemID), 
    CONSTRAINT fk_EquippableItems_slotID FOREIGN KEY (slotID) REFERENCES EquipmentSlots(slotID)
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	CONSTRAINT fk_EquippableItems_itemID FOREIGN KEY (itemID) REFERENCES Items(itemID)
		ON DELETE CASCADE 
		ON UPDATE CASCADE
);

CREATE TABLE Gears (
    itemID INT,
    defenseRating INT NOT NULL,
    magicDefenseRating INT NOT NULL,
    CONSTRAINT pk_Gears_itemID PRIMARY KEY (itemID),
    CONSTRAINT fk_Gears_itemID FOREIGN KEY (itemID) 
        REFERENCES EquippableItems(itemID) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

CREATE TABLE Weapons (
    itemID INT,
    physicalDamage INT NOT NULL,
	autoAttack DECIMAL(10, 2) NOT NULL,
    attackDelay DECIMAL(10, 2) NOT NULL,
    CONSTRAINT pk_Weapons_itemID PRIMARY KEY (itemID),
    CONSTRAINT fk_Weapons_itemID FOREIGN KEY (itemID) 
        REFERENCES EquippableItems(itemID) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

CREATE TABLE Consumables (
    itemID INT,
    itemLevel INT NOT NULL,
    description VARCHAR(500) NOT NULL,
    CONSTRAINT pk_Consumables_itemID PRIMARY KEY (itemID),
    CONSTRAINT fk_Consumables_itemID FOREIGN KEY (itemID) 
        REFERENCES Items(itemID) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

CREATE TABLE GearAndWeaponJobs(
	itemID INT,
    jobID INT,
    CONSTRAINT pk_GearAndWeaponJobs_itemID_jobID PRIMARY KEY (itemID, jobID),
    CONSTRAINT fk_GearAndWeaponJobs_itemID FOREIGN KEY (itemID)
		REFERENCES EquippableItems(itemID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
	CONSTRAINT fk_GearAndWeaponJobs_jobID FOREIGN KEY (jobID)
		REFERENCES Jobs(jobID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE InventoryPositions(
	characterID INT,
    stackPosition INT,
    itemID INT NOT NULL,
    stackSize INT NOT NULL,
    CONSTRAINT pk_InventoryPositions_characterID_stackPosition PRIMARY KEY(characterID, stackPosition),
    CONSTRAINT fk_InventoryPositions_itemID FOREIGN KEY (itemID) REFERENCES Items(itemID) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_InventoryPositions_characterID FOREIGN KEY (characterID) REFERENCES CharacterInfo(characterID) ON UPDATE CASCADE ON DELETE CASCADE
    );
    
-- Create CharacterEquipments table
CREATE TABLE CharacterEquipments (
    characterID INT,
    slotID INT,
    itemID INT,
	CONSTRAINT pk_character_slot PRIMARY KEY (characterID, slotID),
    CONSTRAINT fk_CharacterEquipments_slotID FOREIGN KEY (slotID) REFERENCES EquipmentSlots(slotID)
		ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_CharacterEquipments_itemID FOREIGN KEY (itemID)
        REFERENCES EquippableItems(itemID)
		ON DELETE CASCADE
        ON UPDATE CASCADE,
	CONSTRAINT fk_CharacterEquipments_characterId FOREIGN KEY(characterID) REFERENCES CharacterInfo(characterID)
    	ON DELETE CASCADE
        ON UPDATE CASCADE
);


CREATE TABLE Attributes (
    attributeID INT AUTO_INCREMENT PRIMARY KEY,
    attributeName VARCHAR(200) NOT NULL
);

CREATE TABLE CharacterAttributes(
	attributeID INT,
    characterID INT,
    attributeValue INT NOT NULL,
    CONSTRAINT pk_CharacterAttributes_attributeID_characterID PRIMARY KEY(attributeID, characterID),
    CONSTRAINT fk_CharacterAttributes_attributeID FOREIGN KEY (attributeID) REFERENCES Attributes(attributeID) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_CharacterAttributes_characterID FOREIGN KEY (characterID) REFERENCES CharacterInfo(characterID) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE GearAndWeaponAttributes (
    itemID INT,
    attributeID INT,
    attributeBonus INT NOT NULL,
    CONSTRAINT pk_GearAndWeaponAttributes_itemID_attributeID PRIMARY KEY (itemID, attributeID),
    CONSTRAINT fk_GearAndWeaponAttributes_itemID FOREIGN KEY (itemID) 
        REFERENCES EquippableItems(itemID) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT fk_GearAndWeaponAttributes_attributeID FOREIGN KEY (attributeID) 
        REFERENCES Attributes(attributeID) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

CREATE TABLE ConsumableAttributes (
    itemID INT,
    attributeID INT,
    attributeBonusCap INT NOT NULL,
    attributeBonusPercent DECIMAL(3, 2) NOT NULL,
    CONSTRAINT pk_ConsumableAttributes_itemID_attributeID PRIMARY KEY (itemID, attributeID),
    CONSTRAINT fk_ConsumableAttributes_itemID FOREIGN KEY (itemID) 
        REFERENCES Items(itemID) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT fk_ConsumableAttributes_attributeID FOREIGN KEY (attributeID) 
        REFERENCES Attributes(attributeID) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

USE CS5200Project;

-- Insert Players
INSERT INTO Players (userName, email) VALUES
('DragonSlayer', 'dragonslayer@email.com'),
('MageSupreme', 'magesupreme@email.com'),
('SwordMaster', 'swordmaster@email.com'),
('HealerPro', 'healerpro@email.com'),
('RogueShadow', 'rogueshadow@email.com'),
('WarriorKing', 'warriorking@email.com'),
('ArcherElite', 'archerelite@email.com'),
('PaladinHoly', 'paladinholy@email.com'),
('NinjaMaster', 'ninjamaster@email.com'),
('BerserkerAxe', 'berserkeraxe@email.com');

-- Insert Jobs
INSERT INTO Jobs (jobName) VALUES
('Warrior'),
('Mage'),
('Healer'),
('Rogue'),
('Archer'),
('Paladin'),
('Berserker'),
('Ninja'),
('Summoner'),
('Dark Knight');

-- Insert CharacterInfo
INSERT INTO CharacterInfo (playerID, firstName, lastName, maxHP) VALUES
(1, 'Arthur', 'Pendragon', 1000),
(2, 'Merlin', 'Wizard', 800),
(3, 'Lancelot', 'Knight', 1200),
(4, 'Gwen', 'Healer', 700),
(5, 'Robin', 'Hood', 900),
(6, 'Conan', 'Warrior', 1500),
(7, 'Legolas', 'Greenleaf', 850),
(8, 'Galahad', 'Pure', 1100),
(9, 'Hanzo', 'Shadow', 750),
(10, 'Thor', 'Thunder', 1300);

-- Insert CharacterJobs
INSERT INTO CharacterJobs (characterID, jobID, level, experiencePoints, isCurrentJob) VALUES
(1, 1, 40, 80000, 1),
(2, 2, 41, 82000, 1),
(3, 3, 42, 84000, 1),
(4, 4, 43, 86000, 1),
(5, 5, 44, 88000, 1),
(6, 6, 45, 90000, 1),
(7, 7, 46, 92000, 1),
(8, 8, 47, 94000, 1),
(9, 9, 48, 96000, 1),
(10, 10, 49, 98000, 1);

-- Insert Attributes
INSERT INTO Attributes (attributeName) VALUES
('Strength'),
('Intelligence'),
('Dexterity'),
('Vitality'),
('Mind'),
('Spirit'),
('Tenacity'),
('Critical Hit'),
('Determination'),
('Direct Hit Rate');

-- Insert CharacterAttributes
INSERT INTO CharacterAttributes (characterID, attributeID, attributeValue) VALUES
(1, 1, 260),
(2, 2, 270),
(3, 3, 280),
(4, 4, 290),
(5, 5, 300),
(6, 6, 310),
(7, 7, 320),
(8, 8, 330),
(9, 9, 340),
(10, 10, 350);

-- Insert EquipmentSlots
INSERT INTO EquipmentSlots (slotName) VALUES
('Main Hand'),
('Off Hand'),
('Head'),
('Body'),
('Hands'),
('Legs'),
('Feet'),
('Neck'),
('Ears'),
('Wrists');

-- Insert Items
INSERT INTO Items (itemName, maxStackSize, marketAllowed, vendorPrice) VALUES
('Excalibur', 1, 1, 35000),
('Staff of Power', 1, 1, 36500),
('Holy Shield', 1, 1, 38000),
('Healing Rod', 1, 1, 39500),
('Bow of Shadows', 1, 1, 41000),
('Battle Axe', 1, 1, 42500),
('Elven Bow', 1, 1, 44000),
('Sacred Sword', 1, 1, 45500),
('Ninja Blades', 1, 1, 47000),
('Thunder Hammer', 1, 1, 48500);

-- Insert EquippableItems
INSERT INTO EquippableItems (itemID, itemLevel, slotID, requiredLevel) VALUES
(1, 50, 1, 50),
(2, 50, 1, 50),
(3, 50, 1, 50),
(4, 50, 1, 50),
(5, 50, 1, 50),
(6, 50, 1, 50),
(7, 50, 1, 50),
(8, 50, 1, 50),
(9, 50, 2, 50),
(10, 50, 2, 50);

-- Insert Weapons
INSERT INTO Weapons (itemID, physicalDamage, autoAttack, attackDelay) VALUES
(1, 100, 85.5, 2.6),
(2, 105, 87.5, 2.7),
(3, 110, 89.5, 2.8),
(4, 115, 91.5, 2.9),
(5, 120, 93.5, 3.0),
(6, 125, 95.5, 3.1),
(7, 130, 97.5, 3.2),
(8, 135, 99.5, 3.3);

-- Insert Gears
INSERT INTO Gears (itemID, defenseRating, magicDefenseRating) VALUES
(9, 180, 150),
(10, 190, 160);

-- Insert Currencies
INSERT INTO Currencies (currencyName, max_amount, weeklycap) VALUES
('Gil', 999999, 0),
('Tomestones', 999999, 450),
('Seals', 999999, 450),
('Marks', 999999, 500),
('Gems', 999999, 1000),
('Crystals', 999999, 2000),
('Shards', 999999, 1500),
('Scrips', 999999, 3000),
('Tokens', 999999, 2500),
('Points', 999999, 1000);

-- Insert CharacterCurrencies
INSERT INTO CharacterCurrencies (characterID, currencyID, totalAmountOwned, amountThisWeek) VALUES
(1, 1, 10000, 200),
(2, 2, 11000, 250),
(3, 3, 12000, 300),
(4, 4, 13000, 350),
(5, 5, 14000, 400),
(6, 6, 15000, 450),
(7, 7, 16000, 500),
(8, 8, 17000, 550),
(9, 9, 18000, 600),
(10, 10, 19000, 650);

-- Insert Consumables
INSERT INTO Consumables (itemID, itemLevel, description) VALUES
(1, 40, 'Consumable effect for Excalibur'),
(2, 41, 'Consumable effect for Staff of Power'),
(3, 42, 'Consumable effect for Holy Shield'),
(4, 43, 'Consumable effect for Healing Rod'),
(5, 44, 'Consumable effect for Bow of Shadows'),
(6, 45, 'Consumable effect for Battle Axe'),
(7, 46, 'Consumable effect for Elven Bow'),
(8, 47, 'Consumable effect for Sacred Sword'),
(9, 48, 'Consumable effect for Ninja Blades'),
(10, 49, 'Consumable effect for Thunder Hammer');

-- Insert ConsumableAttributes
INSERT INTO ConsumableAttributes (itemID, attributeID, attributeBonusCap, attributeBonusPercent) VALUES
(1, 1, 80, 0.25),
(2, 2, 85, 0.30),
(3, 3, 90, 0.35),
(4, 4, 95, 0.40),
(5, 5, 100, 0.45),
(6, 6, 105, 0.50),
(7, 7, 110, 0.55),
(8, 8, 115, 0.60),
(9, 9, 120, 0.65),
(10, 10, 125, 0.70);

-- Insert GearAndWeaponAttributes
INSERT INTO GearAndWeaponAttributes (itemID, attributeID, attributeBonus) VALUES
(1, 1, 50),
(2, 2, 55),
(3, 3, 60),
(4, 4, 65),
(5, 5, 70),
(6, 6, 75),
(7, 7, 80),
(8, 8, 85),
(9, 9, 90),
(10, 10, 95);

-- Insert GearAndWeaponJobs
INSERT INTO GearAndWeaponJobs (itemID, jobID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

-- Insert InventoryPositions
INSERT INTO InventoryPositions (characterID, stackPosition, itemID, stackSize) VALUES
(1, 0, 1, 1),
(2, 1, 2, 1),
(3, 2, 3, 1),
(4, 3, 4, 1),
(5, 4, 5, 1),
(6, 5, 6, 1),
(7, 6, 7, 1),
(8, 7, 8, 1),
(9, 8, 9, 1),
(10, 9, 10, 1);

-- Insert CharacterEquipments for main hand
INSERT INTO CharacterEquipments (characterID, slotID, itemID) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 1, 3),
(4, 1, 4),
(5, 1, 5),
(6, 1, 6),
(7, 1, 7),
(8, 1, 8),
(9, 1, 9),
(10, 1, 10);

-- Insert additional CharacterEquipments for other slots
INSERT INTO CharacterEquipments (characterID, slotID, itemID) VALUES
(3, 3, 3),
(4, 4, 4),
(5, 5, 5),
(6, 6, 6),
(7, 7, 7),
(8, 8, 8),
(9, 9, 9),
(10, 10, 10);

