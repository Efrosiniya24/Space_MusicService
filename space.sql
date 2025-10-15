create database if not exists space;
USE space;

create table user(
id bigint primary key auto_increment,
name varchar(50) not null,
email varchar(255) not null,
phone varchar(50),
password varchar(255) not null,
is_deleted boolean default false,
date_creation timestamp not null default current_timestamp,
date_updating timestamp null on update current_timestamp,
gender varchar(50),
date_birth date
);

create table role(
id bigint primary key auto_increment,
role varchar(50)
);

create table user_role(
id_user bigint not null,
id_role bigint not null,
primary key (id_user, id_role),
foreign key (id_user) references user(id),
foreign key (id_role) references role (id)
);

create table genre(
id bigint primary key auto_increment,
name varchar(150) not null unique,
is_removed boolean
);

create table track(
id bigint primary key auto_increment,
name varchar(150) not null,
duration int not null,
cover text,
date_added timestamp not null,
is_removed boolean not null default false, 
id_genre bigint,
foreign key (id_genre) references genre (id)
);

create table artist(
id bigint primary key auto_increment,
name varchar(150) not null unique,
cover text,
description longtext
);

create table artist_track(
id_artist bigint,
id_track bigint not null,
id_composer bigint,
foreign key (id_artist) references artist (id),
foreign key (id_track) references track (id),
foreign key (id_composer) references artist (id)
);

create table playlist(
id bigint primary key auto_increment,
date_creation timestamp not null,
name varchar(150) not null,
is_album boolean not null default 0,
cover text,
is_removed boolean not null default false
);

create table track_playlist(
id bigint primary key auto_increment,
id_track bigint not null,
id_playlist bigint not null,
date_added timestamp not null,
is_removed boolean not null default false,
foreign key (id_track) references track (id),
foreign key (id_playlist) references playlist (id)
);

create table user_playlist(
id bigint primary key auto_increment,
date_added timestamp not null,
is_removed boolean not null default false,
id_user bigint not null,
id_playlist bigint not null,
id_artist bigint,
foreign key (id_user) references user (id),
foreign key (id_playlist) references playlist (id),
foreign key (id_artist) references artist (id)
);

create table organization (
id bigint primary key auto_increment,
name varchar(150) not null unique,
cover text,
description longtext,
date_added timestamp not null,
is_removed boolean not null default false,
url_website text,
status varchar(50) not null,
phone varchar(50),
email varchar(150),
id_owner bigint not null,
foreign key (id_owner) references user (id)
);

create table organization_address(
id bigint primary key auto_increment,
id_organization bigint not null,
country varchar(150) not null,
city varchar(150) not null,
address_city varchar(250) not null,
is_removed boolean not null default false,
foreign key (id_organization) references organization (id)
);

create table organization_curator(
id bigint primary key auto_increment,
id_curator bigint not null,
id_organization bigint not null,
date_added timestamp not null,
foreign key (id_curator) references user (id),
foreign key (id_organization) references organization (id)
);

create table preference(
id bigint primary key auto_increment,
date_creation timestamp not null,
is_removed boolean not null default false,
volume_level varchar (50),
id_organization_address bigint not null,
id_user bigint not null,
foreign key (id_organization_address) references organization_address (id),
foreign key (id_user) references user (id)
);

create table preference_daytime(
id bigint primary key auto_increment,
id_preference bigint not null,
daytime varchar (50) not null,
foreign key (id_preference) references preference (id)
);

create table preference_genre(
id bigint primary key auto_increment,
id_preference bigint,
id_genre bigint,
foreign key (id_preference) references preference (id),
foreign key (id_genre) references genre (id)
);

create table preference_track(
id bigint primary key auto_increment,
id_preference bigint,
id_track bigint,
foreign key (id_preference) references preference (id),
foreign key (id_track) references track (id)
);

create table preference_playlist(
id bigint primary key auto_increment,
id_preference bigint,
id_playlist bigint,
foreign key (id_preference) references preference (id),
foreign key (id_playlist) references playlist (id)
);

create table auto_playlist_snapshot(
id bigint primary key auto_increment,
id_organization_address bigint not null,
created_at timestamp not null,
foreign key (id_organization_address) references organization_address (id)
);

create table auto_playlist_items(
id bigint primary key auto_increment,
id_playlist bigint not null,
id_track bigint not null,
position int not null,
foreign key (id_playlist) references auto_playlist_snapshot (id),
foreign key (id_track) references track (id)
);

create table master_playlist(
id bigint primary key auto_increment,
id_track bigint not null,
position int,
is_locked boolean not null,
id_organization_address bigint not null,
foreign key (id_organization_address) references organization_address (id),
foreign key (id_track) references track (id)
);