INSERT INTO public.player (player_id, username, health, sanity, birthday) VALUES
(1, 'GhostHunter99', 100, 90, '1990-05-15'),
(2, 'KnightOfLight', 80, 70, '1985-11-10'),
(3, 'ShadowSlayer', 75, 60, '1997-03-20'),
(4, 'FireMage21', 90, 65, '1992-09-05'),
(5, 'IceQueen88', 85, 85, '2001-01-30'),
(6, 'SpectralRogue', 95, 75, '1998-08-12');

INSERT INTO public.item (item_id, name, description) VALUES
(1, 'Sword of Flames', 'A sword imbued with the power of fire'),
(2, 'Shield of Eternity', 'A shield that protects against all harm'),
(3, 'Boots of Speed', 'Grants the wearer unparalleled agility'),
(4, 'Amulet of Wisdom', 'An artifact that enhances intelligence'),
(5, 'Potion of Energy', 'Restores stamina and boosts strength temporarily');

INSERT INTO public.item_owner (id, owner_id, item_id, created_at) VALUES
(1, 1, 1, now()),
(2, 2, 2, now());

INSERT INTO public.room (room_id, name, description, lights_on) VALUES
(1, 'Grand Hall', 'A massive hall with high ceilings and chandeliers', true),
(2, 'Dungeon', 'A dark and damp underground area', false),
(3, 'Library', 'A quiet place filled with ancient books', false),
(4, 'Conservatory', 'A glass room filled with exotic plants', true),
(5, 'Servants’ Quarters', 'A small and modest living area for servants', false);

INSERT INTO public.ghost (ghost_id, name, favorite_food, sanity_attack_power) VALUES
(1, 'Spooky Sally', 'Haunted Honeycakes', 5),
(2, 'Phantom Paul', 'Ectoplasmic Pudding', 7),
(3, 'Wailing Wanda', 'Ghostly Grapes', 6);

INSERT INTO public.monster (monster_id, name, health, attack_power, defense_power) VALUES
(1, 'Shadow Beast', 120, 15, 5),
(2, 'Fire Golem', 200, 20, 10),
(3, 'Ice Serpent', 150, 25, 8);

INSERT INTO public.ability (ability_id, name, description, danger_level) VALUES
(1, 'Fire Breath', 'A powerful attack that burns everything in its path', 5),
(2, 'Ice Shard', 'Launches sharp, freezing projectiles', 4),
(3, 'Shadow Cloak', 'Grants temporary invisibility', 3);

INSERT INTO public.monster_ability (id, monster_id, ability_id, created_at) VALUES
(1, 1, 3, now()),
(2, 2, 1, now()),
(3, 3, 2, now());

INSERT INTO public.room_belongings (id, room_id, player_id, item_id, monster_id, ghost_id, created_at) VALUES
(1, 1, 1, 1, NULL, NULL, now()),
(2, 2, NULL, NULL, 1, NULL, now()),
(3, 3, 2, NULL, NULL, 1, now()),
(4, 4, NULL, NULL, NULL, NULL, now()),
(5, 5, 6, NULL, NULL, NULL, now()),
(6, 2, NULL, NULL, 2, NULL, now());
