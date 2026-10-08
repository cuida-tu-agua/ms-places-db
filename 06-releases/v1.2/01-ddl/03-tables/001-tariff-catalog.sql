--liquibase formatted sql

--changeset diego:v1.2-ddl-table-001-tariff-catalog
--comment: HU-066 tariff catalog by city and stratum (Colombia: basic / complementary / luxury ranges, prices per m3). Append-only by effective_from: an official update is a NEW row, so past costs never change (HU-069)
CREATE TABLE places.tariff_catalog (
    id                    UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_tcat_id         DEFAULT (NEWID()),
    city_id               UNIQUEIDENTIFIER NOT NULL,
    stratum               TINYINT          NOT NULL,
    currency              NVARCHAR(3)      NOT NULL CONSTRAINT DF_tcat_currency   DEFAULT (N'COP'),
    fixed_charge          DECIMAL(12,2)    NOT NULL,
    basic_price           DECIMAL(12,2)    NOT NULL,
    complementary_price   DECIMAL(12,2)    NOT NULL,
    luxury_price          DECIMAL(12,2)    NOT NULL,
    basic_limit_m3        DECIMAL(6,2)     NOT NULL CONSTRAINT DF_tcat_basic_limit DEFAULT (20),
    complementary_limit_m3 DECIMAL(6,2)    NOT NULL CONSTRAINT DF_tcat_comp_limit  DEFAULT (40),
    effective_from        DATE             NOT NULL,
    source                NVARCHAR(200)    NOT NULL,
    created_at            DATETIME2        NOT NULL CONSTRAINT DF_tcat_created_at DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT PK_tariff_catalog        PRIMARY KEY (id),
    CONSTRAINT UQ_tcat_city_stratum_from UNIQUE (city_id, stratum, effective_from),
    CONSTRAINT CK_tcat_stratum          CHECK (stratum BETWEEN 1 AND 6),
    CONSTRAINT CK_tcat_currency         CHECK (currency IN (N'COP', N'USD')),
    CONSTRAINT CK_tcat_prices           CHECK (fixed_charge >= 0 AND basic_price >= 0 AND complementary_price >= 0 AND luxury_price >= 0),
    CONSTRAINT CK_tcat_limits           CHECK (basic_limit_m3 > 0 AND complementary_limit_m3 > basic_limit_m3)
);
--rollback DROP TABLE places.tariff_catalog;
