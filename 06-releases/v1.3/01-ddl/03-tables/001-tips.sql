--liquibase formatted sql

--changeset diego:v1.3-ddl-table-001-tips
--comment: HU-063/064/065 water saving tips written by administrators. category = the kind of place they are for. is_active = false hides the tip from users without deleting it (HU-064). created_by is NULL for the starter tips loaded by the migration
CREATE TABLE places.tips (
    id         UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_tips_id         DEFAULT (NEWID()),
    title      NVARCHAR(150)    NOT NULL,
    body       NVARCHAR(1000)   NOT NULL,
    category   NVARCHAR(12)     NOT NULL,
    is_active  BIT              NOT NULL CONSTRAINT DF_tips_is_active  DEFAULT (1),
    created_by UNIQUEIDENTIFIER NULL,
    created_at DATETIME2        NOT NULL CONSTRAINT DF_tips_created_at DEFAULT (SYSUTCDATETIME()),
    updated_by UNIQUEIDENTIFIER NULL,
    updated_at DATETIME2        NOT NULL CONSTRAINT DF_tips_updated_at DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT PK_tips          PRIMARY KEY (id),
    CONSTRAINT CK_tips_category CHECK (category IN (N'RESIDENTIAL', N'COMMERCIAL')),
    CONSTRAINT CK_tips_title    CHECK (LEN(LTRIM(RTRIM(title))) > 0),
    CONSTRAINT CK_tips_body     CHECK (LEN(LTRIM(RTRIM(body))) > 0)
);
--rollback DROP TABLE places.tips;
