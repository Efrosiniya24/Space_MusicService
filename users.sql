USE users;

CREATE TABLE user(
id          	BINARY(16) PRIMARY KEY,
name			VARCHAR(50)  NOT NULL,
email           VARCHAR(255) NOT NULL UNIQUE,
phone           VARCHAR(50),
password        VARCHAR(255) NOT NULL,
is_deleted      BOOLEAN NOT NULL DEFAULT FALSE,
create_at   	TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
update_at   	TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
gender          VARCHAR(50),
date_birth      DATE
);

CREATE TABLE role (
id    BINARY(16) PRIMARY KEY,
role  VARCHAR(50) UNIQUE
);

CREATE TABLE user_role (
user_id BINARY(16) NOT NULL,
role_id BINARY(16) NOT NULL,
PRIMARY KEY (user_id, role_id),
CONSTRAINT fk_user_role_user FOREIGN KEY (user_id) REFERENCES user(id),
CONSTRAINT fk_user_role_role FOREIGN KEY (role_id) REFERENCES role(id)
);

CREATE TABLE organization (
id              BINARY(16) PRIMARY KEY,
name            VARCHAR(150) NOT NULL UNIQUE,
cover           TEXT,
description     LONGTEXT,
added_at        TIMESTAMP NOT NULL DEFAULT NOW(),
is_removed      BOOLEAN NOT NULL DEFAULT FALSE,
url_website     TEXT,
status          VARCHAR(50) NOT NULL,
phone           VARCHAR(50),
email           VARCHAR(150),
owner_id        BINARY(16) NOT NULL,
updated_at      TIMESTAMP NOT NULL DEFAULT NOW() ON UPDATE NOW(),
CONSTRAINT fk_org_owner FOREIGN KEY (owner_id) REFERENCES user(id)
);

CREATE TABLE organization_address (
id               BINARY(16) PRIMARY KEY,
org_id  		 BINARY(16) NOT NULL,
country          VARCHAR(150) NOT NULL,
city             VARCHAR(150) NOT NULL,
address_city     VARCHAR(250) NOT NULL,
is_removed       BOOLEAN NOT NULL DEFAULT FALSE,
updated_at       TIMESTAMP NOT NULL DEFAULT NOW() ON UPDATE NOW(),
CONSTRAINT fk_org_addr_org FOREIGN KEY (org_id) REFERENCES organization(id)
);

CREATE TABLE organization_curator (
id          BINARY(16) PRIMARY KEY,
curator_id  BINARY(16) NOT NULL,
org_id   	BINARY(16) NOT NULL,
added_at    TIMESTAMP NOT NULL DEFAULT NOW(),
is_main		BOOLEAN NOT NULL DEFAULT TRUE,
CONSTRAINT fk_org_curator_user FOREIGN KEY (curator_id) REFERENCES user(id),
CONSTRAINT fk_org_curator_org  FOREIGN KEY (org_id) REFERENCES organization(id)
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