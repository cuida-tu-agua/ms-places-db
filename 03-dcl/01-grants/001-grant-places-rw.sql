--liquibase formatted sql

--changeset esteban:dcl-grant-001-places-rw runInTransaction:false
--comment: Minimum permissions for the app role. No DELETE (soft delete). Catalogs and Liquibase tables are read-only for the app
GRANT SELECT, INSERT, UPDATE ON SCHEMA::places TO places_rw;
DENY  INSERT, UPDATE, DELETE ON OBJECT::places.countries             TO places_rw;
DENY  INSERT, UPDATE, DELETE ON OBJECT::places.subdivisions          TO places_rw;
DENY  INSERT, UPDATE, DELETE ON OBJECT::places.cities                TO places_rw;
DENY  INSERT, UPDATE, DELETE ON OBJECT::places.DATABASECHANGELOG     TO places_rw;
DENY  INSERT, UPDATE, DELETE ON OBJECT::places.DATABASECHANGELOGLOCK TO places_rw;
--rollback REVOKE INSERT, UPDATE, DELETE ON OBJECT::places.DATABASECHANGELOGLOCK FROM places_rw;
--rollback REVOKE INSERT, UPDATE, DELETE ON OBJECT::places.DATABASECHANGELOG     FROM places_rw;
--rollback REVOKE INSERT, UPDATE, DELETE ON OBJECT::places.cities                FROM places_rw;
--rollback REVOKE INSERT, UPDATE, DELETE ON OBJECT::places.subdivisions          FROM places_rw;
--rollback REVOKE INSERT, UPDATE, DELETE ON OBJECT::places.countries             FROM places_rw;
--rollback REVOKE SELECT, INSERT, UPDATE ON SCHEMA::places FROM places_rw;