--liquibase formatted sql

--changeset esteban:dcl-role-001-places-rw runInTransaction:false
--comment: DB role for app read/write + places_app membership
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name='places_rw' AND type='R')
    CREATE ROLE places_rw;
ALTER ROLE places_rw ADD MEMBER places_app;
--rollback ALTER ROLE places_rw DROP MEMBER places_app;
--rollback DROP ROLE places_rw;