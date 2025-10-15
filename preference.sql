CREATE DATABASE IF NOT EXISTS preference;
USE PREFERENCE;

CREATE TABLE preference (
id              BINARY(16) PRIMARY KEY,
created_at      TIMESTAMP NOT NULL DEFAULT NOW(),
is_removed      BOOLEAN NOT NULL DEFAULT FALSE,
volume_level    VARCHAR(50),
org_address_id  BINARY(16) NOT NULL,
user_id         BINARY(16) NOT NULL, 
updated_at      TIMESTAMP NOT NULL DEFAULT NOW() ON UPDATE NOW()
);

CREATE TABLE preference_daytime (
id            BINARY(16) PRIMARY KEY,
preference_id BINARY(16) NOT NULL,
daytime       VARCHAR(50) NOT NULL,
CONSTRAINT fk_preference_preference FOREIGN KEY (preference_id) REFERENCES preference(id)
);

CREATE TABLE preference_genre (
id            BINARY(16) PRIMARY KEY,
preference_id BINARY(16) NOT NULL,
genre_id      BINARY(16) NOT NULL,
CONSTRAINT fk_preference_genre_preference FOREIGN KEY (preference_id) REFERENCES preference(id)
);

CREATE TABLE preference_track (
id            BINARY(16) PRIMARY KEY,
preference_id BINARY(16) NOT NULL,
track_id      BINARY(16) NOT NULL,
CONSTRAINT fk_preference_track_preference FOREIGN KEY (preference_id) REFERENCES preference(id)
);

CREATE TABLE preference_playlist (
id            BINARY(16) PRIMARY KEY,
preference_id BINARY(16) NOT NULL,
playlist_id   BINARY(16) NOT NULL,
CONSTRAINT fk_preference_playlist_preference FOREIGN KEY (preference_id) REFERENCES preference(id)
);

CREATE TABLE auto_playlist_snapshot (
id              BINARY(16) PRIMARY KEY,
org_address_id  BINARY(16) NOT NULL, 
created_at      TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE auto_playlist_items (
id                    BINARY(16) PRIMARY KEY,
playlist_snapshot_id  BINARY(16) NOT NULL,
track_id              BINARY(16) NOT NULL,   
position              INT NOT NULL,
CONSTRAINT fk_auto_playlist_items_playlist FOREIGN KEY (playlist_snapshot_id) REFERENCES auto_playlist_snapshot(id)
);

CREATE TABLE master_playlist (
id                  BINARY(16) PRIMARY KEY,
track_id            BINARY(16) NOT NULL, 
position            INT,
is_locked           BOOLEAN NOT NULL DEFAULT FALSE,
orgaddress_id  		BINARY(16) NOT NULL, 
created_at          TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE user_playlist (
id           	BINARY(16) PRIMARY KEY,
user_id 		BINARY(16) NOT NULL,         
is_own			BOOLEAN DEFAULT FALSE,      
playlist_id     BINARY(16) NOT NULL, 
is_private      BOOLEAN DEFAULT FALSE,
is_removed   	BOOLEAN NOT NULL DEFAULT FALSE,
created_at   	TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE outbox_event (
id             BINARY(16) PRIMARY KEY ,
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
processed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);