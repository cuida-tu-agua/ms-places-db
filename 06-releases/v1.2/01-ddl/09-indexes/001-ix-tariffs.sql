--liquibase formatted sql

--changeset diego:v1.2-ddl-index-001-ix-place-tariffs
--comment: "tariff in force for this place at this date" = newest valid_from <= date (HU-054/056/069)
CREATE INDEX IX_ptar_place_from ON places.place_tariffs (place_id, valid_from DESC);
--rollback DROP INDEX IX_ptar_place_from ON places.place_tariffs;

--changeset diego:v1.2-ddl-index-002-ix-tariff-catalog
--comment: "catalog row of this city and stratum in force at this date" (HU-066/069); also lists the strata of a city
CREATE INDEX IX_tcat_city_stratum_from ON places.tariff_catalog (city_id, stratum, effective_from DESC);
--rollback DROP INDEX IX_tcat_city_stratum_from ON places.tariff_catalog;
