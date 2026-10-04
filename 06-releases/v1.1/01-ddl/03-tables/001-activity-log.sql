--liquibase formatted sql

--changeset esteban:v1.1-ddl-table-001-activity-log
--comment: HU-011 "the deletion is logged". Append-only audit of places (who, which place, what, when). metadata = small JSON
CREATE TABLE places.activity_log (
    id         BIGINT           IDENTITY(1,1) NOT NULL,
    place_id   UNIQUEIDENTIFIER NOT NULL,
    owner_id   UNIQUEIDENTIFIER NOT NULL,
    action     NVARCHAR(30)     NOT NULL,
    metadata   NVARCHAR(MAX)    NULL,
    created_at DATETIME2        NOT NULL CONSTRAINT DF_place_activity_created_at DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT PK_place_activity          PRIMARY KEY (id),
    CONSTRAINT CK_place_activity_action   CHECK (action IN (N'PLACE_DELETED')),
    CONSTRAINT CK_place_activity_metadata CHECK (metadata IS NULL OR ISJSON(metadata) = 1)
);
--rollback DROP TABLE places.activity_log;
