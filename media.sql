create database if not exists media;
USE media;

CREATE TABLE genre (
id          BINARY(16) PRIMARY KEY,
name        VARCHAR(150) NOT NULL UNIQUE,
is_removed  BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE track (
id          BINARY(16) PRIMARY KEY,
name        VARCHAR(150) NOT NULL,
duration    INT NOT NULL,
cover       TEXT,
added_at    TIMESTAMP NOT NULL DEFAULT NOW(),
is_removed  BOOLEAN NOT NULL DEFAULT FALSE,
genre_id    BINARY(16),
updated_at  TIMESTAMP NOT NULL DEFAULT NOW() ON UPDATE NOW(),
CONSTRAINT fk_track_genre FOREIGN KEY (genre_id) REFERENCES genre(id)
);

CREATE TABLE artist (
id          BINARY(16) PRIMARY KEY,
name        VARCHAR(150) NOT NULL UNIQUE,
cover       TEXT,
description LONGTEXT,
updated_at  TIMESTAMP NOT NULL DEFAULT NOW() ON UPDATE NOW()
);

CREATE TABLE track_artist (
id           BINARY(16) PRIMARY KEY,
track_id     BINARY(16) NOT NULL,
artist_id    BINARY(16) NOT NULL,
role         ENUM('SINGER','COMPOSER') NOT NULL,
CONSTRAINT fk_tc_track  FOREIGN KEY (track_id)  REFERENCES track(id),
CONSTRAINT fk_tc_artist FOREIGN KEY (artist_id) REFERENCES artist(id)
);

CREATE TABLE playlist (
id          BINARY(16) PRIMARY KEY,
created_at	TIMESTAMP NOT NULL DEFAULT NOW(),
name        VARCHAR(150) NOT NULL,
is_album    BOOLEAN NOT NULL DEFAULT FALSE,
cover       TEXT,
is_removed  BOOLEAN NOT NULL DEFAULT FALSE,
updated_at  TIMESTAMP NOT NULL DEFAULT NOW() ON UPDATE NOW()
);

CREATE TABLE track_playlist (
id           BINARY(16) PRIMARY KEY,
track_id     BINARY(16) NOT NULL,
playlist_id  BINARY(16) NOT NULL,
adedd_at   TIMESTAMP NOT NULL DEFAULT NOW(),
is_removed   BOOLEAN NOT NULL DEFAULT FALSE,
CONSTRAINT fk_tp_track FOREIGN KEY (track_id) REFERENCES track(id),
CONSTRAINT fk_tp_playlist FOREIGN KEY (playlist_id) REFERENCES playlist(id)
);

CREATE TABLE outbox_event (
id             BINARY(16) PRIMARY KEY,
aggregate_type VARCHAR(64)  NOT NULL,
aggregate_id   BINARY(16)   NOT NULL,
event_type     VARCHAR(64)  NOT NULL,
event_version  INT          NOT NULL DEFAULT 1,
payload        JSON         NOT NULL,
headers        JSON         NULL,
correlation_id BINARY(16)   NULL,
causation_id   BINARY(16)   NULL,
saga_type      VARCHAR(64)  NULL,
occurred_at    TIMESTAMP    NOT NULL DEFAULT NOW(),
published      TINYINT(1)   NOT NULL DEFAULT 0,
published_at   TIMESTAMP    NULL
);

CREATE TABLE processed_message (
message_id  BINARY(16) PRIMARY KEY,
processed_at TIMESTAMP NOT NULL DEFAULT NOW()
);