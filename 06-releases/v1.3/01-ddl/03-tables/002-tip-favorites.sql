--liquibase formatted sql

--changeset diego:v1.3-ddl-table-002-tip-favorites
--comment: HU-065 tips a user marked as favorite. One row per (user, tip); un-marking deletes the row
CREATE TABLE places.tip_favorites (
    user_id    UNIQUEIDENTIFIER NOT NULL,
    tip_id     UNIQUEIDENTIFIER NOT NULL,
    created_at DATETIME2        NOT NULL CONSTRAINT DF_tipfav_created_at DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT PK_tip_favorites PRIMARY KEY (user_id, tip_id)
);
--rollback DROP TABLE places.tip_favorites;
