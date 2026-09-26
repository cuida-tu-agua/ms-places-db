--liquibase formatted sql

--changeset esteban:ddl-table-001-countries
--comment: Countries catalog (HU-053). The country sets the default currency and unit of a new place
CREATE TABLE places.countries (
    id               UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_countries_id DEFAULT (NEWID()),
    code             NVARCHAR(2)      NOT NULL,
    name             NVARCHAR(100)    NOT NULL,
    default_currency NVARCHAR(3)      NOT NULL,
    default_unit     NVARCHAR(15)     NOT NULL,
    CONSTRAINT PK_countries      PRIMARY KEY (id),
    CONSTRAINT UQ_countries_code UNIQUE (code),
    CONSTRAINT CK_countries_unit CHECK (default_unit IN (N'LITERS', N'CUBIC_METERS', N'GALLONS'))
);
--rollback DROP TABLE places.countries;