SET @BASE      = 'discord_bot_rpg';             	-- Le nom de la base de données (à adapter)
SET @COLLATION = 'utf8_unicode_ci';      			-- Pour choisir utf8_unicode_ci, il faut
SET @COLLATION = 'utf8mb4_unicode_ci';   			-- commenter CETTE ligne avec "-- " au début
SET @CHARSET   = SUBSTRING_INDEX(@COLLATION, '_', 1);

-- Pour lancer la requête, il FAUT intégrer les différentes lignes SET ci-dessus
-- La requête en elle-même ne doit PAS être modifiée !

SELECT
  CONCAT('ALTER TABLE ', 'discord_bot_rpg', '.', table_name, ' CONVERT TO CHARACTER SET ', SUBSTRING_INDEX('utf8mb4_unicode_ci', '_', 1), ' COLLATE ', 'utf8mb4_unicode_ci', ';')
  AS 'Remplacement 1 : contenu'
 ,CONCAT('ALTER TABLE ', 'discord_bot_rpg', '.', table_name, ' CHARACTER SET ', SUBSTRING_INDEX('utf8mb4_unicode_ci', '_', 1), ' COLLATE ', 'utf8mb4_unicode_ci', ';')
  AS 'Remplacement 2 : conteneur'
FROM   information_schema.tables
WHERE  table_schema     = 'discord_bot_rpg'          -- Le nom de la base à traiter
  AND  table_collation != 'utf8mb4_unicode_ci'     -- Le nom de l'interclassement souhaité
GROUP BY table_name;

-- Ici

-- Part 1
ALTER TABLE discord_bot_rpg.areas CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.areasitems CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.areasmonsters CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.areasowners CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.areasresources CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.areastypes CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.characters CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.characterscraftlevel CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.charactersequipements CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.charactershonor CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.charactersinventory CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.conquesttournamentinfo CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.conquesttournamentinscriptions CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.conquesttournamentrounds CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.craftbuilding CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.craftitem CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.craftitemsneeded CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.guilds CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.guildsappliances CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.guildsmembers CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.guildsranks CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.items CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.itemsbase CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.itemsrarities CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.itemssoustypes CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.itemsstats CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.itemstypes CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.levels CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.levelsrequire CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.marketplaces CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.marketplacesorders CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.monstres CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.monstresgroupes CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.monstrestypes CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.stats CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.statscharacters CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.statsmonstres CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.users CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.userspreferences CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

ALTER TABLE discord_bot_rpg.areas CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.areasitems CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.areasmonsters CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.areasowners CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.areasresources CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.areastypes CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.characters CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.characterscraftlevel CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.charactersequipements CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.charactershonor CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.charactersinventory CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.conquesttournamentinfo CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.conquesttournamentinscriptions CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.conquesttournamentrounds CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.craftbuilding CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.craftitem CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.craftitemsneeded CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.guilds CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.guildsappliances CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.guildsmembers CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.guildsranks CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.items CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.itemsbase CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.itemsrarities CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.itemssoustypes CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.itemsstats CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.itemstypes CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.levels CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.levelsrequire CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.marketplaces CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.marketplacesorders CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.monstres CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.monstresgroupes CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.monstrestypes CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.stats CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.statscharacters CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.statsmonstres CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.users CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE discord_bot_rpg.userspreferences CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;