--liquibase formatted sql

--changeset esteban:ddl-ix-001-places
--comment: HU-010 list an owner's places; HU-009/010 at most one active default place per owner
CREATE INDEX        IX_places_owner         ON places.places (owner_id);
CREATE UNIQUE INDEX UX_places_owner_default ON places.places (owner_id) WHERE is_default = 1 AND deleted_at IS NULL;
--rollback DROP INDEX UX_places_owner_default ON places.places;
--rollback DROP INDEX IX_places_owner         ON places.places;