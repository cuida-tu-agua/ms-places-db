-- Runs once as sa. The database and security.users are created by ms-iam-db.
IF DB_ID('sy-water-db') IS NULL
    THROW 50001, 'Database sy-water-db does not exist. Run ms-iam-db first.', 1;
GO

USE [sy-water-db];
GO

IF SCHEMA_ID('places') IS NULL
    EXEC('CREATE SCHEMA places');
GO

-- Runtime user for place-service
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name='places_app')
    CREATE LOGIN places_app WITH PASSWORD='$(PLACES_APP_PASSWORD)';
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name='places_app')
BEGIN
    CREATE USER places_app FOR LOGIN places_app
        WITH DEFAULT_SCHEMA = places;
END
GO

-- Migration user for Liquibase
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name='places_migrator')
    CREATE LOGIN places_migrator WITH PASSWORD='$(PLACES_MIGRATOR_PASSWORD)';
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name='places_migrator')
BEGIN
    CREATE USER places_migrator FOR LOGIN places_migrator
        WITH DEFAULT_SCHEMA = places;
END
GO

GRANT CONTROL ON SCHEMA::places TO places_migrator;
GRANT CREATE TABLE TO places_migrator;
GRANT CREATE ROLE TO places_migrator;
GRANT ALTER ANY ROLE TO places_migrator;
GO

-- Needed to create FK_places_owner (cross-schema FK)
IF OBJECT_ID(N'security.users', N'U') IS NOT NULL
    GRANT REFERENCES ON OBJECT::security.users TO places_migrator;
GO
