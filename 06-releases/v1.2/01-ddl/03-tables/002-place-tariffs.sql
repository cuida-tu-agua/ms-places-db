--liquibase formatted sql

--changeset diego:v1.2-ddl-table-002-place-tariffs
--comment: HU-054/069 tariff history of a place. MANUAL = the user types the price per m3 (and optionally a monthly fixed charge); CATALOG = the user picks a stratum and the prices come from tariff_catalog. Append-only: the tariff in force at a date is the newest row with valid_from <= that date, so changing it never alters past costs
CREATE TABLE places.place_tariffs (
    id           BIGINT           IDENTITY(1,1) NOT NULL,
    place_id     UNIQUEIDENTIFIER NOT NULL,
    source       NVARCHAR(10)     NOT NULL,
    unit_price   DECIMAL(12,2)    NULL,
    fixed_charge DECIMAL(12,2)    NULL,
    stratum      TINYINT          NULL,
    valid_from   DATETIME2        NOT NULL CONSTRAINT DF_ptar_valid_from DEFAULT (SYSUTCDATETIME()),
    created_by   UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT PK_place_tariffs  PRIMARY KEY (id),
    CONSTRAINT CK_ptar_source    CHECK (source IN (N'MANUAL', N'CATALOG')),
    CONSTRAINT CK_ptar_shape     CHECK (
        (source = N'MANUAL'  AND unit_price IS NOT NULL AND stratum IS NULL)
        OR
        (source = N'CATALOG' AND stratum IS NOT NULL AND unit_price IS NULL AND fixed_charge IS NULL)),
    CONSTRAINT CK_ptar_amounts   CHECK ((unit_price IS NULL OR unit_price >= 0) AND (fixed_charge IS NULL OR fixed_charge >= 0)),
    CONSTRAINT CK_ptar_stratum   CHECK (stratum IS NULL OR stratum BETWEEN 1 AND 6)
);
--rollback DROP TABLE places.place_tariffs;
