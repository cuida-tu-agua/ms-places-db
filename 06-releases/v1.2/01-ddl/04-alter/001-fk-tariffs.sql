--liquibase formatted sql

--changeset diego:v1.2-ddl-fk-001-fk-tariff-catalog-city
--comment: tariff_catalog -> cities (HU-066)
ALTER TABLE places.tariff_catalog
    ADD CONSTRAINT FK_tcat_city
    FOREIGN KEY (city_id) REFERENCES places.cities (id);
--rollback ALTER TABLE places.tariff_catalog DROP CONSTRAINT FK_tcat_city;

--changeset diego:v1.2-ddl-fk-002-fk-place-tariffs-place
--comment: place_tariffs -> places (HU-054). Places are soft-deleted, so the history is never orphaned
ALTER TABLE places.place_tariffs
    ADD CONSTRAINT FK_ptar_place
    FOREIGN KEY (place_id) REFERENCES places.places (id);
--rollback ALTER TABLE places.place_tariffs DROP CONSTRAINT FK_ptar_place;
