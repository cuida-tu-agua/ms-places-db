--liquibase formatted sql

--changeset esteban:ddl-fk-003-places-owner
--comment: Cross-schema FK places.owner_id -> security.users.id (ADR-002 rule 3). No cascade: users are soft-deleted (HU-008)
--preconditions onFail:HALT onError:HALT
--precondition-sql-check expectedResult:1 SELECT CASE WHEN OBJECT_ID(N'security.users', N'U') IS NULL THEN 0 ELSE 1 END
ALTER TABLE places.places
    ADD CONSTRAINT FK_places_owner
    FOREIGN KEY (owner_id) REFERENCES security.users (id);
--rollback ALTER TABLE places.places DROP CONSTRAINT FK_places_owner;