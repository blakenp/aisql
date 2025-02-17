create table public.player (
  player_id bigint generated by default as identity not null,
  created_at timestamp with time zone not null default now(),
  username character varying not null default 'user'::character varying,
  health real not null default '10'::real,
  sanity real not null default '10'::real,
  birthday date null,
  constraint player_pkey primary key (player_id),
  constraint player_username_key unique (username)
) TABLESPACE pg_default;

create table public.item (
  item_id bigint generated by default as identity not null,
  created_at timestamp with time zone not null default now(),
  name character varying not null default 'itemx'::character varying,
  description character varying null,
  constraint item_pkey primary key (item_id),
  constraint item_item_id_fkey foreign KEY (item_id) references player (player_id)
) TABLESPACE pg_default;

create table public.item_owner (
  owner_id bigint not null,
  created_at timestamp with time zone not null default now(),
  item_id bigint null,
  id bigint generated by default as identity not null,
  constraint item_owner_pkey primary key (id),
  constraint item_owner_item_id_fkey foreign KEY (item_id) references item (item_id),
  constraint item_owner_owner_id_fkey foreign KEY (owner_id) references player (player_id)
) TABLESPACE pg_default;

create table public.room (
  room_id bigint generated by default as identity not null,
  created_at timestamp with time zone not null default now(),
  name character varying not null,
  description character varying not null,
  lights_on boolean not null default true,
  constraint room_pkey primary key (room_id)
) TABLESPACE pg_default;

create table public.ghost (
  ghost_id bigint generated by default as identity not null,
  created_at timestamp with time zone not null default now(),
  name character varying null,
  favorite_food character varying null,
  sanity_attack_power real not null default '1'::real,
  constraint ghost_pkey primary key (ghost_id)
) TABLESPACE pg_default;

create table public.monster (
  monster_id bigint generated by default as identity not null,
  created_at timestamp with time zone not null default now(),
  name character varying not null default 'zombie'::character varying,
  health real null,
  attack_power real not null default '5'::real,
  defense_power real null,
  constraint monster_pkey primary key (monster_id)
) TABLESPACE pg_default;

create table public.ability (
  ability_id bigint generated by default as identity not null,
  created_at timestamp with time zone not null default now(),
  name character varying not null,
  description character varying not null,
  danger_level integer not null,
  constraint ability_pkey primary key (ability_id)
) TABLESPACE pg_default;

create table public.monster_ability (
  monster_id bigint not null,
  created_at timestamp with time zone not null default now(),
  ability_id bigint null,
  id bigint generated by default as identity not null,
  constraint monster_ability_pkey primary key (id),
  constraint monster_ability_ability_id_fkey foreign KEY (ability_id) references ability (ability_id),
  constraint monster_ability_monster_id_fkey foreign KEY (monster_id) references monster (monster_id)
) TABLESPACE pg_default;

create table public.room_belongings (
  room_id bigint not null,
  created_at timestamp with time zone not null default now(),
  player_id bigint null,
  item_id bigint null,
  monster_id bigint null,
  ghost_id bigint null,
  id bigint generated by default as identity not null,
  constraint room_belongings_pkey primary key (id),
  constraint room_belongings_ghost_id_fkey foreign KEY (ghost_id) references ghost (ghost_id),
  constraint room_belongings_item_id_fkey foreign KEY (item_id) references item (item_id),
  constraint room_belongings_monster_id_fkey foreign KEY (monster_id) references monster (monster_id),
  constraint room_belongings_player_id_fkey foreign KEY (player_id) references player (player_id),
  constraint room_belongings_room_id_fkey foreign KEY (room_id) references room (room_id)
) TABLESPACE pg_default;
