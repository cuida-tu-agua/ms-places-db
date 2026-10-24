--liquibase formatted sql

--changeset juan:v1.4-ddl-table-003-guest-links
--comment: HU-039 shareable read-only link of a place. token = 256 random bits in base64url, it IS the credential of the anonymous guest. A place has at most one active link (deactivated_at IS NULL); generating a new one deactivates the old one. A deactivated link is kept for the history
CREATE TABLE places.guest_links (
    id             UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_glink_id         DEFAULT (NEWID()),
    place_id       UNIQUEIDENTIFIER NOT NULL,
    token          NVARCHAR(64)     NOT NULL,
    created_by     UNIQUEIDENTIFIER NOT NULL,
    created_at     DATETIME2        NOT NULL CONSTRAINT DF_glink_created_at DEFAULT (SYSUTCDATETIME()),
    deactivated_at DATETIME2        NULL,
    CONSTRAINT PK_guest_links PRIMARY KEY (id),
    CONSTRAINT UQ_glink_token UNIQUE (token),
    CONSTRAINT CK_glink_token CHECK (LEN(token) >= 32)
);
--rollback DROP TABLE places.guest_links;
