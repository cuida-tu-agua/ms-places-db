--liquibase formatted sql

--changeset esteban:v1.1-ddl-ix-001-activity-log
--comment: "History of this place" and "what did this owner do", newest first
CREATE INDEX IX_place_activity_place ON places.activity_log (place_id, created_at DESC);
CREATE INDEX IX_place_activity_owner ON places.activity_log (owner_id, created_at DESC);
--rollback DROP INDEX IX_place_activity_owner ON places.activity_log;
--rollback DROP INDEX IX_place_activity_place ON places.activity_log;
