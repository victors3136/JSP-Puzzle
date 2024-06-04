use puzzle;
create table wp_user (
                         id int auto_increment primary key,
                         name varchar(32) unique not null
);

create table wp_puzzle (
                           id int auto_increment primary key,
                           name varchar(32) unique not null,
                           piece_count int check(piece_count > 0)
);

create table wp_game_state (
                               id int auto_increment primary key,
                               puzzle int not null ,
                               foreign key (puzzle) references wp_puzzle(id),
                               player int not null,
                               foreign key (player) references wp_user(id),
                               move_count int not null default 0,
                               finished bit not null default 0b0,
                               played_at timestamp not null default current_timestamp
);
create index idx_game_state_puzzle on wp_game_state(puzzle);
create index idx_game_state_player on wp_game_state(player);