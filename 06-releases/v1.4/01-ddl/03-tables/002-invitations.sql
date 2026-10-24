--liquibase formatted sql

--changeset juan:v1.4-ddl-table-002-invitations
--comment: HU-042/043 invitation of a person (by e-mail) to collaborate in a place. PENDING -> ACCEPTED | REJECTED | EXPIRED (a PENDING one past expires_at counts as expired and is closed when the owner invites that e-mail again). The e-mail is stored lower-case; the person accepts with an account whose verified e-mail is the same
CREATE TABLE places.invitations (
    id           UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_inv_id         DEFAULT (NEWID()),
    place_id     UNIQUEIDENTIFIER NOT NULL,
    invited_by   UNIQUEIDENTIFIER NOT NULL,
    email        NVARCHAR(320)    NOT NULL,
    permissions  NVARCHAR(200)    NOT NULL,
    status       NVARCHAR(10)     NOT NULL CONSTRAINT DF_inv_status     DEFAULT (N'PENDING'),
    expires_at   DATETIME2        NOT NULL,
    created_at   DATETIME2        NOT NULL CONSTRAINT DF_inv_created_at DEFAULT (SYSUTCDATETIME()),
    updated_at   DATETIME2        NOT NULL CONSTRAINT DF_inv_updated_at DEFAULT (SYSUTCDATETIME()),
    responded_at DATETIME2        NULL,
    CONSTRAINT PK_invitations     PRIMARY KEY (id),
    CONSTRAINT CK_inv_status      CHECK (status IN (N'PENDING', N'ACCEPTED', N'EXPIRED', N'REJECTED')),
    CONSTRAINT CK_inv_permissions CHECK (LEN(permissions) > 0),
    CONSTRAINT CK_inv_dates       CHECK (expires_at > created_at)
);
--rollback DROP TABLE places.invitations;
