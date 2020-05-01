
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