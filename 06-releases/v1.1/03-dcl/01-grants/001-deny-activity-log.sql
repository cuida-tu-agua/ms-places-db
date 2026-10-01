--liquibase formatted sql

--changeset esteban:v1.1-dcl-grant-001-activity-log-append-only runInTransaction:false
--comment: places_rw already has SELECT/INSERT/UPDATE on the whole schema. An audit log must not be edited: only INSERT and SELECT
DENY UPDATE, DELETE ON OBJECT::places.activity_log TO places_rw;
--rollback REVOKE UPDATE, DELETE ON OBJECT::places.activity_log FROM places_rw;
