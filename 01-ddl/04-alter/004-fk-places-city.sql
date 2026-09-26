--liquibase formatted sql

--changeset esteban:ddl-fk-004-places-city
--comment: places -> cities (HU-009 location, HU-066 tariffs by city)
ALTER TABLE places.places
    ADD CONSTRAINT FK_places_city
    FOREIGN KEY (city_id) REFERENCES places.cities (id);
--rollback ALTER TABLE places.places DROP CONSTRAINT FK_places_city;