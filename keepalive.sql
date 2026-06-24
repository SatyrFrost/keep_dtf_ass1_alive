-- Part 1: Database Initialization and DDL (数据库初始化与 DDL)

-- 1
-- User can do this using the GUI

USE LegendOfSQL;


-- 2 
CREATE TABLE Class (
    ClassID INT AUTO_INCREMENT PRIMARY KEY,
    ClassName VARCHAR(20) NOT NULL,
    BaseHP INT DEFAULT 100
);

-- 3
CREATE TABLE Player (
    PlayerID INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(50) NOT NULL UNIQUE,
    ClassID INT,
    Level INT DEFAULT 1,
    Gold DECIMAL(10, 2),
    CONSTRAINT chk_gold CHECK (Gold > 0)
);

-- 4
CREATE TABLE Equipment (
    ItemID INT AUTO_INCREMENT PRIMARY KEY,
    ItemName VARCHAR(50),
    AttackPower INT,
    Weight DECIMAL(5, 2)
);

-- 5
CREATE TABLE PlayerInventory (
    InventoryID INT AUTO_INCREMENT PRIMARY KEY,
    PlayerID INT,
    ItemID INT,
    AcquiredDate DATETIME
);


-- 6
ALTER TABLE Player 
ADD RegistrationDate DATE;

-- 7
ALTER TABLE Equipment 
MODIFY ItemName VARCHAR(100) NOT NULL;



-- Part 2: Data Integrity and Data Population (数据操作与完整性) 

-- 8
ALTER TABLE Player 
ADD CONSTRAINT fk_player_class 
FOREIGN KEY (ClassID) REFERENCES Class(ClassID);

-- 9
ALTER TABLE PlayerInventory 
ADD CONSTRAINT fk_inventory_player 
FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID) ON DELETE CASCADE;

-- 10
ALTER TABLE PlayerInventory 
ADD CONSTRAINT fk_inventory_item 
FOREIGN KEY (ItemID) REFERENCES Equipment(ItemID) ON DELETE CASCADE;


-- Data Population 

-- 11
INSERT INTO Class (ClassName, BaseHP) VALUES 
('Warrior', 150), 
('Wizard', 80), 
('Archer', 110);

-- 12
INSERT INTO Player (Username, ClassID, Level, Gold, RegistrationDate) VALUES 
('DragonSlayer', 1, 55, 1200.50, '2026-01-10'),
('MagicUser99', 2, 12, 450.00, '2026-02-15'),
('ShadowArrowX', 3, 62, 3000.75, '2026-01-05'),
('IronWall', 1, 8, 150.00, '2026-03-20'),
('FireBlast', 2, 45, 800.00, '2026-02-28'),
('WindRunner', 3, 22, 550.20, '2026-04-12'),
('DragonBreath', 1, 15, 200.00, '2026-05-01'),
('FrostQueen', 2, 52, 2500.00, '2025-12-12'),
('BoltStriker', 3, 30, 1100.00, '2026-03-05'),
('RookieX', 1, 3, 50.00, '2026-05-10');

-- 13
INSERT INTO Equipment (ItemName, AttackPower, Weight) VALUES 
('Dragon Sword', 85, 12.5),
('Wooden Staff', 15, 2.0),
('Heavy Iron Shield', 10, 65.0),
('Phoenix Bow', 75, 5.5),
('Great Axe', 95, 55.0),
('Mana Wand', 40, 1.5),
('Hunter Crossbow', 50, 8.0),
('Titan Hammer', 110, 90.0),
('Leather Quiver', 5, 1.2),
('Steel Dagger', 30, 3.0);

-- 14
INSERT INTO PlayerInventory (PlayerID, ItemID, AcquiredDate) VALUES 
(1, 1, '2026-01-12'),
(1, 3, '2026-01-15'),
(2, 2, '2026-02-16'),
(3, 4, '2026-01-06'),
(3, 8, '2026-02-01'),
(4, 3, '2026-03-21'),
(5, 6, '2026-03-01'),
(8, 6, '2026-01-20'),
(8, 5, '2026-02-10'),
(9, 7, '2026-03-10');



-- Part 3: Advanced Querying and Data Updating (高级查询与数据更新) 

-- 15
SELECT Username AS '玩家名', Level AS '等级', Gold AS '金币'
FROM Player
ORDER BY Username;

-- 16
SELECT Username, Gold * 2 AS 'Double Gold'
FROM Player;

-- 17
SELECT * FROM Player
WHERE Level BETWEEN 10 AND 60
ORDER BY Level DESC;

-- 18
SELECT * FROM Player
WHERE Username LIKE '%w%';

-- 19
SELECT * FROM Player
ORDER BY Gold DESC
LIMIT 3;

-- 20
SELECT AVG(Weight) AS 'Average Weight', SUM(AttackPower) AS 'Total Attack Power' 
FROM Equipment;

-- 21
SELECT Class.ClassID, ClassName, COUNT(PlayerID) AS 'Number of Players'
FROM Class JOIN Player
ON Class.ClassID = Player.ClassID
GROUP BY ClassID, ClassName;

-- 22
SELECT ItemID, COUNT(PlayerID) AS 'Times Collected'
FROM PlayerInventory
GROUP BY ItemID
HAVING COUNT(PlayerID) > 1;

-- 23
SELECT Username, ClassName, ItemName 
FROM Class JOIN Player
ON Class.ClassID = Player.ClassID
JOIN PlayerInventory 
ON Player.PlayerID = PlayerInventory.PlayerID
JOIN Equipment 
ON PlayerInventory.ItemID = Equipment.ItemID;

-- 24
SELECT ItemName, PlayerID
FROM Equipment 
LEFT OUTER JOIN PlayerInventory
ON Equipment.ItemID = PlayerInventory.ItemID

-- 25
SELECT Username, Level 
FROM Player 
WHERE Level > (
  SELECT AVG(Level)
  FROM Player
);

-- 26
SELECT Username, Level
FROM Player
WHERE EXISTS (
  SELECT * FROM PlayerInventory
  WHERE Player.PlayerID = PlayerInventory.PlayerID
);

-- 27
CREATE TABLE Rich_Players AS
SELECT * FROM Player
WHERE Gold > 2000;

SELECT * FROM Rich_Players;

-- 28
UPDATE Player
SET Level = Level + 5
ORDER BY Level ASC
LIMIT 2;

SELECT * FROM Player;

-- 29
DELETE Playerinventory 
FROM Playerinventory JOIN Equipment 
ON PlayerInventory.ItemID = Equipment.ItemID
WHERE ItemName LIKE '%Sword%';

SELECT * FROM Playerinventory;


-- Part 4: Optimization and Virtualization (优化与虚拟化) 

-- 30
CREATE VIEW High_Level_Players AS
SELECT Username, Level, ClassName
FROM Player JOIN Class 
ON Player.ClassID = Class.ClassID
WHERE Level > 50;

SELECT * FROM High_Level_Players;

-- 31
CREATE INDEX IDX_Inv_Player_Item 
ON PlayerInventory (PlayerID, ItemID);


-- Part 5: User Management and Security (用户管理与安全性) 

-- 32
CREATE USER 'data_analyst'@'192.168.10.15' IDENTIFIED BY 'SecureAnalyst99!';

ALTER USER 'data_analyst'@'192.168.10.15' IDENTIFIED BY 'NewAnalysis2026!';

-- 33
CREATE USER 'support_staff'@'%' IDENTIFIED BY 'HelpPlayer555';

GRANT SELECT(PlayerID, Username), UPDATE(Level) 
ON LegendOfSQL.Player 
TO 'support_staff'@'%';

REVOKE UPDATE(Level) 
ON LegendOfSQL.Player
FROM 'support_staff'@'%';


-- Part 6: Data Migration and Backup Recovery (数据迁移与备份恢复)

-- 34
USE LegendOfSQL;
SELECT PlayerID, Username, Gold 
FROM Player 
WHERE Gold > 2200
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/wealthy_players.csv'
FIELDS TERMINATED BY ','          
LINES TERMINATED BY '\n';

-- 35
-- This is run in a command prompt, not as SQL.
mysqldump -u root -p --databases legendofsql > "C:/Users/Satyr/Desktop/legendofsql.sql"


