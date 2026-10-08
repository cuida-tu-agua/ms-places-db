--liquibase formatted sql

--changeset diego:v1.2-dcl-grant-001-tariffs runInTransaction:false
--comment: The app only READS the tariff catalog (it is loaded by migrations) and only APPENDS to the tariff history of a place (HU-054/069: never rewrite the past)
DENY INSERT, UPDATE, DELETE ON OBJECT::places.tariff_catalog TO places_rw;
DENY UPDATE, DELETE         ON OBJECT::places.place_tariffs  TO places_rw;
--rollback REVOKE UPDATE, DELETE ON OBJECT::places.place_tariffs FROM places_rw;
--rollback REVOKE INSERT, UPDATE, DELETE ON OBJECT::places.tariff_catalog FROM places_rw;
