--liquibase formatted sql

--changeset esteban:ddl-table-003-cities
--comment: CO municipio (DANE, 5 digits) / EC canton (INEC, 4 digits). The code starts with the subdivision code
CREATE TABLE places.cities (
    id             UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_cities_id DEFAULT (NEWID()),
    subdivision_id UNIQUEIDENTIFIER NOT NULL,
    code           NVARCHAR(5)      NOT NULL,
    name           NVARCHAR(100)    NOT NULL,
    CONSTRAINT PK_cities                  PRIMARY KEY (id),
    CONSTRAINT UQ_cities_subdivision_code UNIQUE (subdivision_id, code)
);
--rollback DROP TABLE places.cities;