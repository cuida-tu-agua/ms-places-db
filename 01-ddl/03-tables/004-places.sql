--liquibase formatted sql

--changeset esteban:ddl-table-004-places
--comment: BC-02 Place aggregate root (HU-009/010/011). Location = city_id (country comes from city -> subdivision). is_default = selected place; deleted_at = soft delete
CREATE TABLE places.places (
    id               UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_places_id         DEFAULT (NEWID()),
    owner_id         UNIQUEIDENTIFIER NOT NULL,
    city_id          UNIQUEIDENTIFIER NOT NULL,
    name             NVARCHAR(200)    NOT NULL,
    place_type       NVARCHAR(15)     NOT NULL,
    address          NVARCHAR(500)    NOT NULL,
    currency         NVARCHAR(3)      NOT NULL,
    measurement_unit NVARCHAR(15)     NOT NULL CONSTRAINT DF_places_unit       DEFAULT (N'LITERS'),
    is_default       BIT              NOT NULL CONSTRAINT DF_places_is_default DEFAULT (0),
    created_at       DATETIME2        NOT NULL CONSTRAINT DF_places_created_at DEFAULT (SYSUTCDATETIME()),
    updated_at       DATETIME2        NOT NULL CONSTRAINT DF_places_updated_at DEFAULT (SYSUTCDATETIME()),
    deleted_at       DATETIME2        NULL,
    CONSTRAINT PK_places          PRIMARY KEY (id),
    CONSTRAINT CK_places_type     CHECK (place_type IN (N'RESIDENTIAL', N'COMMERCIAL')),
    CONSTRAINT CK_places_currency CHECK (currency IN (N'COP', N'USD')),
    CONSTRAINT CK_places_unit     CHECK (measurement_unit IN (N'LITERS', N'CUBIC_METERS', N'GALLONS'))
);
--rollback DROP TABLE places.places;