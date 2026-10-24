--liquibase formatted sql

--changeset juan:v1.4-ddl-table-001-place-members
--comment: HU-043/044/046 collaborators of a place. The owner is places.places.owner_id and never has a row here. permissions = comma-separated keys (VIEW_CONSUMPTION is always present). A revoked collaborator keeps the row (revoked_at) so the history survives and a new invitation can reactivate it: places_rw cannot DELETE
CREATE TABLE places.place_members (
    id          UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_pmem_id         DEFAULT (NEWID()),
    place_id    UNIQUEIDENTIFIER NOT NULL,
    user_id     UNIQUEIDENTIFIER NOT NULL,
    role        NVARCHAR(15)     NOT NULL CONSTRAINT DF_pmem_role       DEFAULT (N'COLLABORATOR'),
    permissions NVARCHAR(200)    NOT NULL,
    created_at  DATETIME2        NOT NULL CONSTRAINT DF_pmem_created_at DEFAULT (SYSUTCDATETIME()),
    updated_at  DATETIME2        NOT NULL CONSTRAINT DF_pmem_updated_at DEFAULT (SYSUTCDATETIME()),
    revoked_at  DATETIME2        NULL,
    CONSTRAINT PK_place_members       PRIMARY KEY (id),
    CONSTRAINT UQ_pmem_place_user     UNIQUE (place_id, user_id),
    CONSTRAINT CK_pmem_role           CHECK (role IN (N'COLLABORATOR')),
    CONSTRAINT CK_pmem_permissions    CHECK (LEN(permissions) > 0)
);
--rollback DROP TABLE places.place_members;
