--liquibase formatted sql

--changeset esteban:ddl-fk-002-cities-subdivision
--comment: cities -> subdivisions
ALTER TABLE places.cities
    ADD CONSTRAINT FK_cities_subdivision
    FOREIGN KEY (subdivision_id) REFERENCES places.subdivisions (id);
--rollback ALTER TABLE places.cities DROP CONSTRAINT FK_cities_subdivision;