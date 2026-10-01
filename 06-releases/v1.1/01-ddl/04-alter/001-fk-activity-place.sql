--liquibase formatted sql

--changeset esteban:v1.1-ddl-alter-001-fk-activity-place
--comment: Every log row points to a real place. Places are never physically deleted (soft delete), so the FK never blocks
ALTER TABLE places.activity_log
    ADD CONSTRAINT FK_place_activity_place FOREIGN KEY (place_id) REFERENCES places.places (id);
--rollback ALTER TABLE places.activity_log DROP CONSTRAINT FK_place_activity_place;
