-- Areas
-- type 1 wild, 2 city, 3 dungeon
INSERT INTO areas
VALUES
    (22, "https://image.ibb.co/n2HydV/northernexpedition.png", 2, 1, 5),
    -- northern expedition

    (23, "https://img00.deviantart.net/2238/i/2015/099/9/7/lava_cracks_by_frejagelii-d8p1n1y.jpg", 1, 1, 5),
    -- lava crack

    (24, "http://orig04.deviantart.net/b9a8/f/2010/153/6/f/lavascape_by_llrobinll.png", 1, 1, 5),
    -- explosive volcanos

    (25, "https://cdna.artstation.com/p/assets/images/images/004/407/402/large/nicolas-ico-vallee-sp100.jpg?1483483562", 1, 1, 5),
    -- lava burnt

    (26, "https://pre00.deviantart.net/26ae/th/pre/i/2016/179/4/8/ruined_village_by_andanguyen-da2e44f.png", 1, 1, 5),
    -- old dwarf city

    (27, "https://images6.alphacoders.com/415/415665.jpg", 3, 1, 5);
-- daemonic citadel



INSERT INTO localizationareas
VALUES
    (22, "en", "Northern Expedition Outpost", "The northern expedition was organized shortly after the beginning of colonization, however, it began its journey to the north only very recently. Nevertheless, the progress made is impressive. An outpost is built and it has all the amenities. Now, the real problem is the demons."),
    (22, "fr", "Avant-poste de l'Expédition Nord", "L'expédition nord s'est organisé peu de temps après le début de la colonisation, cependant elle a commencé son voyage vers le nord que très récemment. Malgré tout, les progrès accomplis sont impressionnants. Un avant poste est construit et il dispose de toutes les commodités. Maintenant, le vrai problème ce sont les démons."),

    (23, "en", "The Lava Cracks", "These lava cracks are the result of the intense volcanic activity in the region. Elementary beings are born there, go through this region will not be a pleasure."),
    (23, "fr", "Les Fissures de Lave", "Ces fissures de lave sont la résultante de l'activité volcanique intense de la région. Des êtres élémentaires y naissent, traverser cette région ne sera pas une partie de plaisir."),

    (24, "en", "Explosive Volcanos", "These volcanoes are a concentrate of heat, ash and smoke. In addition to being filled with elementary beings, there are demons. You came here, you must regret it."),
    (24, "fr", "Les Volcans Explosifs", "Ces volcans sont un concentré de chaleur, de cendres et de fumée. En plus d'être remplis d'êtres élémentaires, il y a des démons. Vous devez déjà regretter d'être venu."),

    (25, "en", "The Lava Burnt Forest", "Probably an old forest, now it is burned by the lava that gushes out of the ground. But this forest has something alive, you should be on your guard."),
    (25, "fr", "La Forêt Brûlée par la Lave", "Sûrement une ancienne forêt, maintenant elle est brûlée par la lave qui jaillit du sol. Mais cette forêt a quelque chose de vivant, vous devriez vous tenir sur vos gardes."),

    (26, "en", "Old Dwarf City", "Remains of an ancient dwarf city. Everything seems quiet, not a sound. As you get closer, you will notice that the city is no longer so deserted..."),
    (26, "fr", "Ancienne Cité Naine", "Des vestiges d'une ancienne cité naine. Tout semble calme, pas un bruit. En vous rapprochant de plus près vous remarquer que la ville n'est plus si déserte que ça..."),

    (27, "en", "The Daemonic Citadel", "The demonic citadel, the heart of the region. Filled with filth, demons and suffering. If you are here, it is surely to free the region from the yoke of the demon who is staying there."),
    (27, "fr", "La Citadelle Démoniaque", "La citadelle démoniaque, coeur de la région. Remplis d'immondices, de démons et de souffrance. Si vous êtes ici c'est sûrement pour libérer la région du joug du démon qui y séjourne.");

-- Paths
INSERT INTO areaspaths
VALUES
    -- Interzone
    -- From outpost
    (22, 23, 90, 0),
    (23, 22, 90, 0),
    (22, 25, 30, 0),
    (25, 22, 30, 0),
    (22, 27, 30, 0),
    (27, 22, 30, 0),

    -- Cracks
    (23, 24, 30, 0),
    (24, 23, 30, 0),

    -- foret brulée
    (25, 26, 30, 0),
    (26, 25, 30, 0),


    -- Outsite
    (22, 10, 420, 0),
    (10, 22, 420, 0);

INSERT INTO areasmonsterslevels
VALUES
    (22, 80, 80),
    (23, 60, 65),
    (24, 65, 70),
    (25, 70, 75),
    (26, 75, 80),
    (27, 80, 80);


-- Regions 

INSERT INTO regions
VALUES
    (4);

INSERT INTO localizationregions
VALUES
    (4, "en", "Daemonic Region", "https://image.ibb.co/eAEKJV/daemonic-region-en.png"),
    (4, "fr", "Région Démoniaque", "https://image.ibb.co/bOsmXq/daemonic-region-fr.png");

INSERT INTO areasregions
VALUES
    (22, 4),
    (23, 4),
    (24, 4),
    (25, 4),
    (26, 4),
    (27, 4);


-- Monstres 56 grp 54

INSERT INTO monstres
VALUES
    (56, 0, 1),
    (57, 0, 1),
    (58, 0, 1),
    (59, 0, 2),

    (60, 0, 1),
    (61, 0, 1),
    (62, 0, 1),
    (63, 0, 2),


    (64, 0, 2),


    -- cité naine

    (65, 0, 1),
    (66, 0, 1),
    (67, 0, 1),
    (68, 0, 2),

    -- citadel daemonic
    (69, 0, 2),
    (70, 0, 3);

INSERT INTO localizationmonsters
VALUES
    (56, "en", "Molten Golem"),
    (56, "fr", "Golem de Magma en Fusion"),
    (57, "en", "Lava Elemental"),
    (57, "fr", "Elémentaire de Lave"),
    (58, "en", "Fire Elemental"),
    (58, "fr", "Elémentaire de Feu"),
    (59, "en", "Giant Magma Golem"),
    (59, "fr", "Golem de Magma Gigantesque"),

    (60, "en", "Smoke Elemental"),
    (60, "fr", "Elémentaire de Fumée"),
    (61, "en", "Ash Golem"),
    (61, "fr", "Golem de Cendre"),
    (62, "en", "Lava Imp"),
    (62, "fr", "Diablotin de Lave"),
    (63, "en", "Imp Mother"),
    (63, "fr", "Mère des Diablotins"),

    (64, "en", "Ent Wounded by Lava"),
    (64, "fr", "Ent Blessé par la Lave"),

    (65, "en", "Dwarf Warrior Ghost"),
    (65, "fr", "Fantôme de Guerrier Nain"),
    (66, "en", "Dwarf Archer Ghost"),
    (66, "fr", "Fantôme d'Archer Nain"),
    (67, "en", "Dwarf Mage Ghost"),
    (67, "fr", "Fantôme de Mage Nain"),
    (68, "en", "Angry Ghost of a Former Dwarf King"),
    (68, "fr", "Fantôme en Colère d'un Ancien Roi Nain"),

    (69, "en", "Demonic Guard"),
    (69, "fr", "Garde Démoniaque"),
    (70, "en", "Demon of Ancient Times"),
    (70, "fr", "Démon des Temps Anciens");

-- 2 smorc, 3 tank_stun, 4 crit, 5 tank_armor_stun, 6 tank_will, 7 damage, 8 damage_crit, 9 tanky

INSERT INTO statsmonstres
VALUES
    (56, 9),
    (57, 7),
    (58, 4),
    (59, 5),

    (60, 8),
    (61, 2),
    (62, 7),
    (63, 9),


    (64, 3),


    -- cité naine

    (65, 2),
    (66, 8),
    (67, 7),
    (68, 3),

    -- dungeon
    (69, 5),
    (70, 7);


INSERT INTO monstresgroupes
VALUES
    (54, 56, 1),
    (55, 57, 1),
    (56, 58, 1),
    (57, 59, 1),

    (58, 60, 1),
    (59, 61, 1),
    (60, 62, 1),
    (61, 63, 1),

    -- ent
    (62, 64, 1),

    -- fantomes
    (63, 65, 1),
    (64, 66, 1),
    (65, 67, 1),
    (66, 68, 1),

    (67, 62, 2),
    (67, 69, 2),
    (67, 70, 1);


INSERT INTO areasmonsters
VALUES
    (23, 54, 56),
    (23, 55, 57),
    (23, 56, 58),
    (23, 57, 59),

    (24, 58, 60),
    (24, 59, 61),
    (24, 60, 62),
    (24, 61, 63),

    (25, 55, 57),
    (25, 56, 58),
    (25, 59, 61),
    (25, 62, 64),

    (26, 63, 65),
    (26, 64, 66),
    (26, 65, 67),
    (26, 66, 68),

    -- dj
    (27, 67, 62),
    (27, 67, 69),
    (27, 67, 70);


INSERT INTO areasitems
VALUES
    -- cracks
    (23, 2, 0, 1, 1),
    (23, 3, 0, 1, 1),
    (23, 4, 0, 1, 1),
    (23, 7, 0, 1, 1),
    (23, 8, 0, 1, 1),
    (23, 9, 0, 1, 1),
    (23, 12, 0, 1, 1),
    (23, 13, 0, 1, 1),
    (23, 14, 0, 1, 1),
    (23, 15, 0, 1, 1),
    (23, 17, 0, 1, 1),
    (23, 18, 0, 1, 1),
    (23, 19, 0, 1, 1),
    -- volcanos
    (24, 2, 0, 1, 1),
    (24, 3, 0, 1, 1),
    (24, 4, 0, 1, 1),
    (24, 5, 0, 1, 1),
    (24, 7, 0, 1, 1),
    (24, 8, 0, 1, 1),
    (24, 9, 0, 1, 1),
    (24, 12, 0, 1, 1),
    (24, 13, 0, 1, 1),
    (24, 14, 0, 1, 1),
    (24, 17, 0, 1, 1),
    (24, 18, 0, 1, 1),
    (24, 19, 0, 1, 1),
    -- burnt forest
    (25, 2, 0, 1, 1),
    (25, 3, 0, 1, 1),
    (25, 4, 0, 1, 1),
    (25, 7, 0, 1, 1),
    (25, 8, 0, 1, 1),
    (25, 9, 0, 1, 1),
    (25, 12, 0, 1, 1),
    (25, 13, 0, 1, 1),
    (25, 14, 0, 1, 1),
    (25, 17, 0, 1, 1),
    (25, 18, 0, 1, 1),
    (25, 19, 0, 1, 1),
    (25, 20, 0, 1, 1),
    -- old dwarf city
    (26, 3, 0, 1, 1),
    (26, 4, 0, 1, 1),
    (26, 8, 0, 1, 1),
    (26, 9, 0, 1, 1),
    (26, 10, 0, 1, 1),
    (26, 13, 0, 1, 1),
    (26, 14, 0, 1, 1),
    (26, 18, 0, 1, 1),
    (26, 19, 0, 1, 1),
    -- tomb
    (27, 5, 0, 1, 1),
    (27, 10, 0, 1, 1),
    (27, 15, 0, 1, 1),
    (27, 20, 0, 1, 1);


INSERT INTO areasresources
VALUES

    (23, 21),
    (23, 22),
    (23, 23),
    (23, 24),
    (23, 25),
    (23, 28),
    (23, 29),

    (24, 21),
    (24, 22),
    (24, 23),
    (24, 24),
    (24, 25),
    (24, 28),
    (24, 29),

    (25, 28),
    (25, 31),
    (25, 34),
    (25, 35),

    (26, 21),
    (26, 26),
    (26, 27),
    (26, 28),
    (26, 30);



INSERT INTO craftbuilding
VALUES
    (7, 22, 1, 3, 5, 61, 80);

