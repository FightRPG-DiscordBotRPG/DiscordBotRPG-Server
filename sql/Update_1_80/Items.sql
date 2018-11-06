TRUNCATE TABLE marketplacesorders;
TRUNCATE TABLE charactersequipements;
TRUNCATE TABLE charactersinventory;
TRUNCATE TABLE itemsstats;
TRUNCATE TABLE craftitemsneeded;
DELETE FROM craftitem;
ALTER TABLE craftitem AUTO_INCREMENT = 1;
TRUNCATE TABLE areasresources;
TRUNCATE TABLE areasitems;
DELETE FROM items;
ALTER TABLE items AUTO_INCREMENT = 1;
TRUNCATE TABLE localizationitems;
DELETE FROM itemsbase;
ALTER TABLE itemsbase AUTO_INCREMENT = 1;

INSERT INTO itemssoustypes
VALUES
    (10, "founder_box"),
    (11, "horse");


-- types :
-- 1 weapon, 2 chest, 3 legs, 4 head, 5 resource, 6 potion, 7 lootbox, 8 mount
-- sous-types :
-- 1 ore, 2 plant, 3 wood, 4 sword, 5 whip, 6 armor, 7 potion, 8 loot_box_equipment, 9 reset_time_potion, 10 founder_box, 11 horse
-- rarities :
-- 1 common, 2 rare, 3 superior, 4 epic, 5 legendary



INSERT INTO itemsbase
VALUES

    -- Armes
    (1, 1, 1, "unknwon", 4),
    (2, 1, 2, "unknwon", 4),
    (3, 1, 3, "unknwon", 4),
    (4, 1, 4, "unknwon", 4),
    (5, 1, 5, "unknwon", 4),

    -- Armures
    (6, 2, 1, "unknwon", 6),
    (7, 2, 2, "unknwon", 6),
    (8, 2, 3, "unknwon", 6),
    (9, 2, 4, "unknwon", 6),
    (10, 2, 5, "unknwon", 6),

    (11, 3, 1, "unknwon", 6),
    (12, 3, 2, "unknwon", 6),
    (13, 3, 3, "unknwon", 6),
    (14, 3, 4, "unknwon", 6),
    (15, 3, 5, "unknwon", 6),

    (16, 4, 1, "unknwon", 6),
    (17, 4, 2, "unknwon", 6),
    (18, 4, 3, "unknwon", 6),
    (19, 4, 4, "unknwon", 6),
    (20, 4, 5, "unknwon", 6),

    -- Ressources
    -- Ore
    (21, 5, 1, "unknwon", 1),
    (22, 5, 2, "unknwon", 1),
    (23, 5, 3, "unknwon", 1),
    (24, 5, 4, "unknwon", 1),
    (25, 5, 5, "unknwon", 1),
    -- Plant
    (26, 5, 1, "unknwon", 2),
    (27, 5, 2, "unknwon", 2),
    (28, 5, 3, "unknwon", 2),
    (29, 5, 4, "unknwon", 2),
    (30, 5, 5, "unknwon", 2),
    --Wood
    (31, 5, 1, "unknwon", 3),
    (32, 5, 2, "unknwon", 3),
    (33, 5, 3, "unknwon", 3),
    (34, 5, 4, "unknwon", 3),
    (35, 5, 5, "unknwon", 3),

    -- Montures
    (36, 8, 1, "unknwon", 11),
    (37, 8, 2, "unknwon", 11),
    (38, 8, 3, "unknwon", 11),
    (39, 8, 4, "unknwon", 11),
    (40, 8, 5, "unknwon", 11),

    -- Consumable
    (41, 6, 1, "unknown", 9),

    -- LootBox
    (42, 7, 5, "unknown", 10);

INSERT INTO localizationitems
VALUES
    (1, "en", "Rudimentary Sword", "A rudimentary sword, made mainly of wood."),
    (1, "fr", "Épée Rudimentaire", "Une épée rudimentaire, faite principalement de bois."),
    (2, "en", "Silver Sword", "A silver sword, you're afraid of werewolves?"),
    (2, "fr", "Épée en Argent", "Une épée en argent, vous avez peur des loups-garous ?"),
    (3, "en", "Iron Sword", "An iron sword, nothing more banal."),
    (3, "fr", "Épée en Fer", "Une épée en fer, rien de plus banal."),
    (4, "en", "Gold Sword", "A beautiful golden sword, you can see yourself in the reflection."),
    (4, "fr", "Épée en Or", "Une belle épée en or, vous vous voyez dans le reflet."),
    (5, "en", "Mithril Sword", "A Mithril sword adorned with some embellishments."),
    (5, "fr", "Épée en Mithril", "Une épée en Mithril ornée de quelques fioritures."),

    (6, "en", "Rudimentary Chest Armor", "Do you really think that this can save you?"),
    (6, "fr", "Plastron Rudimentaire", "Vous pensez vraiment que cela peut vous sauver ?"),
    (7, "en", "Silver Chest Armor", "Silver armor, at least the werewolves won't touch you."),
    (7, "fr", "Plastron en Argent", "Une armure en argent, au moins, les loups-garous ne vous toucherons pas."),
    (8, "en", "Iron Chest Armor", "Iron armor, a little heavy."),
    (8, "fr", "Plastron en Fer", "Une armure en fer, un peu lourde."),
    (9, "en", "Gold Chest Armor", "You can't be any less discreet."),
    (9, "fr", "Plastron en Or", "Vous ne pouvez pas faire moins discret."),
    (10, "en", "Mithril Chest Armor", "Mithril armor that will protect you from most attacks."),
    (10, "fr", "Plastron en Mithril", "Une armure en Mithril qui vous protègera de la plupart des attaques."),

    (11, "en", "Rudimentary Armored Leggings", "Even I wouldn't dare wear that."),
    (11, "fr", "Jambières Rudimentaire", "Même moi je n'oserai pas porter ça."),
    (12, "en", "Silver Armored Leggings", "Another part of the best werewolf hunter set ever."),
    (12, "fr", "Jambières en Argent", "Encore une partie du meilleur set de chasseur de loups-garous."),
    (13, "en", "Iron Armored Leggings", "At least what is certain is that this part is well protected."),
    (13, "fr", "Jambières en Fer", "Au moins ce qui est sûr, c'est que cette partie est bien protégée."),
    (14, "en", "Gold Armored Leggings", "Gold here? After all, why not."),
    (14, "fr", "Jambières en Or", "De l'or ici ? Après tout pourquoi pas."),
    (15, "en", "Mithril Armored Leggings", "If you hold on to your legs this armor is certainly the best."),
    (15, "fr", "Jambières en Mithril", "Si vous tenez à vos jmabes cette armure est certainement la meilleure."),

    (16, "en", "Rudimentary Helmet", "Ridiculous, that's all I can say."),
    (16, "fr", "Casque Rudimentaire", "Ridicule, c'est tout ce que je peux dire."),
    (17, "en", "Silver Helmet", "In general, it's true that werewolves like this part."),
    (17, "fr", "Casque en Argent", "En général, c'est vrai que les loups-garous aiment bien cette partie."),
    (18, "en", "Iron Helmet", "If you want to look like a soldier, you can't do better."),
    (18, "fr", "Casque en Fer", "Si vous voulez ressembler à un soldat, vous ne pouvez pas faire mieux."),
    (19, "en", "Gold Helmet", "Gold on your head, what is certain is that you will easily attract thieving birds."),
    (19, "fr", "Casque en Or", "De l'or sur la tête, ce qui est sûr c'est que vous allez facilement attirer des oiseaux voleurs."),
    (20, "en", "Mithril Helmet", "Thanks to this protection, it is impossible for you to be knocked out. I mean, you can always believe that."),
    (20, "fr", "Casque en Mithril", "Grâce à cette protection, impossible pour vous d'être assommé. Enfin, vous pouvez toujours le croire."),

    (21, "en", "Stone", "No more than a simple stone."),
    (21, "fr", "Pierre", "Pas plus qu'une simple pierre."),
    (22, "en", "Silver", "Silver, no more than that."),
    (22, "fr", "Argent", "De l'argent, et je ne parle pas d'argent."),
    (23, "en", "Iron", "Iron, one of the most common ores."),
    (23, "fr", "Fer", "Du fer, un des minerais les plus communs."),
    (24, "en", "Gold", "It's... gold! You're going to be rich!"),
    (24, "fr", "Or", "Mais, c'est... de l'or ! Vous allez devenir riche !"),
    (25, "en", "Mithril", "This ore is really hard to get, but you will probably be able to do a lot of things with it."),
    (25, "fr", "Mithril", "Ce minerai est vraiment dur à obtenir, mais vous allez sûrement pouvoir faire beaucoup de choses avec."),

    (26, "en", "Roots", "Roots... Oh, really?"),
    (26, "fr", "Racines", "Des racines... Vraiment ?"),
    (27, "en", "Ancient Foam", "A foam that starts to change colour, what is certain is that it is not edible."),
    (27, "fr", "Mousse Ancienne", "Une mousse qui commence à changer de couleur, ce qui est sûr c'est que ce n'est pas comestible."),
    (28, "en", "Grow-Everywhere", "This plant is really everywhere, it grows everywhere. Oh, I think I just found his name."),
    (28, "fr", "Pousse-Partout", "Cette plante est vraiment partout, elle pousse partout. Oh je crois que j'ai trouvé son nom."),
    (29, "en", "Lava Flower", "A very strange flower, the inside seems to be filled with lava."),
    (29, "fr", "Fleur de Lave", "Une fleur très bizarre, l'intérieur semble être rempli de lave."),
    (30, "en", "Scathing Creeper", "These vines are really dangerous, you should avoid rubbing them."),
    (30, "fr", "Lianes Cinglantes", "Ces lianes sont vraiment dangereuses, il faut éviter de s'y frotter."),

    (31, "en", "Ash Wood", "Ash Wood, yes."),
    (31, "fr", "Bois de Frêne", "Du bois, de frêne, oui oui."),
    (32, "en", "Chestnut Wood", "If you like chestnuts, you shouldn't have cut down the tree..."),
    (32, "fr", "Bois de Châtaignier", "Si tu aimes les châtaignes, il ne fallait pas couper l'arbre..."),
    (33, "en", "Cactus", "A cactus, soaked with water."),
    (33, "fr", "Cactus", "Un cactus, imbibé d'eau."),
    (34, "en", "Ebony Wood", "Hey Bonnie! Yeah, you're not very good at jokes."),
    (34, "fr", "Bois d'ébène", "Hey Ben ! Oui, les blagues c'est pas votre fort."),
    (35, "en", "Lava Wood", "A very strange piece of wood, soaked with lava."),
    (35, "fr", "Bois de Lave", "Un morceau de bois très étrange, imbibé de lave."),

    (36, "en", "Donkey", "Almost a horse."),
    (36, "fr", "Âne", "Presque un cheval."),
    (37, "en", "Old Horse", "A horse with experience, unfortunately it doesn't allow him to go faster."),
    (37, "fr", "Cheval Âgé", "Un cheval avec de l'expérience, malheureusement ça ne lui permet pas d'aller plus vite."),
    (38, "en", "Tywardreath Horse ", "A proud Tywardreath horse. Probably one of the best of his generation."),
    (38, "fr", "Cheval de Tywardreath", "Un fier cheval de Tywardreath. Sûrement un des meilleurs de sa génération."),
    (39, "en", "Desert Horse", "Yes, it's a horse that's used to the desert, isn't it crazy?"),
    (39, "fr", "Cheval du Désert", "Oui, c'est bien un cheval qui est habitué au désert, c'est fou non ?"),
    (40, "en", "Fire Palfrey", "A fire horse, honestly, isn't it a dream come true?"),
    (40, "fr", "Palefroi de Feu", "Un cheval enflammé, sincèrement est-ce que ce n'est pas un rêve qui devient réalité ?"),

    (41, "en", "Anti-tiredness potion", "With this potion, in one sip you won't be tired anymore!"),
    (41, "fr", "Potion anti-fatigue", "Avec cette potion, en une gorgée vous ne serez plus fatigué !"),

    (42, "en", "Founder's Gift", "A very rare gift to get you off to a good start! What are you waiting for? Open it! Open it!"),
    (42, "fr", "Cadeau de Fondateur", "Un cadeau très rare vous permettant de bien démarrer l'aventure ! Qu'est-ce que vous attendez ? Ouvrez-le !");