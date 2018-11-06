-- Guilds

UPDATE guilds SET guilds.level = 1, argent = 0;
UPDATE characters SET characters.money = 0, idArea = 1;
UPDATE charactershonor SET Honor = 0;
UPDATE charactersstatistics SET charactersstatistics.value = 0;
TRUNCATE TABLE commandslogs;
INSERT INTO charactersachievements SELECT characters.idCharacter, 1 FROM characters;
