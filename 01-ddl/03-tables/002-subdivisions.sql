--liquibase formatted sql

--changeset esteban:ddl-table-002-subdivisions
--comment: First-level subdivision: CO departamento (DANE), EC provincia (INEC). code is unique per country only
CREATE TABLE places.subdivisions (
    id         UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_subdivisions_id DEFAULT (NEWID()),
    country_id UNIQUEIDENTIFIER NOT NULL,
    code       NVARCHAR(2)      NOT NULL,
    name       NVARCHAR(100)    NOT NULL,
    CONSTRAINT PK_subdivisions              PRIMARY KEY (id),
    CONSTRAINT UQ_subdivisions_country_code UNIQUE (country_id, code)
);
--rollback DROP TABLE places.subdivisions;