
-- Select all from areas
SELECT *
FROM areas
INNER JOIN localizationareas ON localizationareas.idArea = areas.idArea
WHERE areas.idArea = 3

-- Select dungeons
SELECT *
FROM areas
INNER JOIN localizationareas ON localizationareas.idArea = areas.idArea
WHERE lang = "en" AND areas.idAreaType = 3

-- Select monsters level in area
SELECT * FROM areasmonsterslevels WHERE idArea = 21

-- Select all items drop from areas
SELECT * FROM areasitems WHERE idArea = 33

-- With more info
SELECT * FROM areasitems
INNER JOIN itemsbase ON itemsbase.idBaseItem = areasitems.idBaseItem
INNER JOIN localizationitems ON localizationitems.idBaseItem = areasitems.idBaseItem
WHERE idArea = 33 AND lang="en"

-- Select paths of an area
SELECT * FROM areaspaths WHERE areaspaths.idArea1 = 33 OR areaspaths.idArea2 = 33

-- Group of monsters
SELECT * FROM areasmonsters 
INNER JOIN monstresgroupesassoc ON monstresgroupesassoc.idMonstresGroupe = areasmonsters.idMonstresGroupe
INNER JOIN monstres ON monstres.idMonstre = monstresgroupesassoc.idMonstre
INNER JOIN monstrestypes ON monstrestypes.idType = monstres.idType
INNER JOIN localizationmonsters ON localizationmonsters.idMonstre = monstres.idMonstre
WHERE lang="en" AND areasmonsters.idArea = 1

SELECT * FROM monstresgroupesassoc 
INNER JOIN monstres ON monstres.idMonstre = monstresgroupesassoc.idMonstre
INNER JOIN monstrestypes ON monstrestypes.idType = monstres.idType
INNER JOIN localizationmonsters ON localizationmonsters.idMonstre = monstres.idMonstre
WHERE lang="en";

-- Monsters
SELECT * FROM monstres
INNER JOIN monstrestypes ON monstrestypes.idType = monstres.idType
INNER JOIN localizationmonsters ON localizationmonsters.idMonstre = monstres.idMonstre
WHERE lang="en";

-- Achievements
SELECT * FROM achievement INNER JOIN localizationachievements ON localizationachievements.idAchievement = achievement.idAchievement WHERE lang = "en";

-- Select items of type
SELECT * FROM itemsbase INNER JOIN localizationitems ON localizationitems.idBaseItem = itemsbase.idBaseItem WHERE localizationitems.lang = "en";

-- Select area by climate
SELECT * FROM areas INNER JOIN areasclimates ON areasclimates.idArea = areas.idArea WHERE areasclimates.idClimate = 2;

-- Select id area for climate and type city
SELECT areas.idArea FROM areas INNER JOIN areasclimates ON areasclimates.idArea = areas.idArea WHERE areasclimates.idClimate = 2 AND areas.idAreaType = 2;

-- Select idShop of areas based on climate
SELECT * FROM areas INNER JOIN areasclimates ON areasclimates.idArea = areas.idArea INNER JOIN areasshops ON areasshops.idArea = areas.idArea WHERE areasclimates.idClimate = 2 AND areas.idAreaType = 2;

-- Select items sell by type
SELECT * FROM sellableitems INNER JOIN itemsbase ON itemsbase.idBaseItem = sellableitems.idBaseItem WHERE itemsbase.idType = 8

-- All list of items to area shop
SELECT idShop FROM areas INNER JOIN areasclimates ON areasclimates.idArea = areas.idArea INNER JOIN areasshops ON areasshops.idArea = areas.idArea WHERE areasclimates.idClimate = 2 AND areas.idAreaType = 2;

-- Add to all areas listed an item to drop
-- Utilisez n'importe quel type de select
REPLACE INTO areasitems
VALUES SELECT areas.idArea, 1 as idBaseItem, 0 as percentage, 1 as min, 1 as max FROM areas INNER JOIN areasclimates ON areasclimates.idArea = areas.idArea WHERE areasclimates.idClimate = 2 AND areas.idAreaType = 1;

-- Select items in area
SELECT * FROM areasitems INNER JOIN itemsbase ON itemsbase.idBaseItem = areasitems.idBaseItem


-- Market places
SELECT * FROM marketplacesorders INNER JOIN items ON items.idItem = marketplacesorders.idItem INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem

-- Witrh name and where
SELECT * FROM marketplacesorders
INNER JOIN items ON items.idItem = marketplacesorders.idItem
INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem
INNER JOIN localizationitems ON localizationitems.idBaseItem = itemsbase.idBaseItem
INNER JOIN itemspower ON itemspower.idItem = items.idItem
WHERE items.level = 75 AND localizationitems.lang = "fr";


-- Check user inv
SELECt * from charactersinventory INNER JOIN items ON items.idItem = charactersinventory.idItem INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem INNER JOIN localizationitems ON localizationitems.idBaseItem = itemsbase.idBaseItem WHERE idCharacter = 10472 AND lang = "fr"

-- Get Mythicals and join with leaderboard (example to use if want to add more filter or sort)
SELECT characters.idCharacter, Honor, actualLevel, mythicals
FROM charactershonor 
INNER JOIN characters ON characters.idCharacter = charactershonor.idCharacter 
INNER JOIN users ON users.idCharacter = charactershonor.idCharacter
INNER JOIN levels ON levels.idCharacter = characters.idCharacter 
INNER JOIN 
	(SELECT idCharacter, COUNT(*) as mythicals FROM charactersequipements
	INNER JOIN items ON items.idItem = charactersequipements.idItem 
	INNER JOIN itemsbase ON itemsbase.idBaseItem = items.idBaseItem 
	WHERE itemsbase.idRarity = 6 AND idCharacter GROUP BY idCharacter) test ON test.idCharacter = characters.idCharacter
ORDER BY `charactershonor`.`Honor`  DESC









