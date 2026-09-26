--liquibase formatted sql

--changeset esteban:ddl-fk-001-subdivisions-country
--comment: subdivisions -> countries
ALTER TABLE places.subdivisions
    ADD CONSTRAINT FK_subdivisions_country
    FOREIGN KEY (country_id) REFERENCES places.countries (id);
--rollback ALTER TABLE places.subdivisions DROP CONSTRAINT FK_subdivisions_country;