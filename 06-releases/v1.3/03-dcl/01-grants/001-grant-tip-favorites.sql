--liquibase formatted sql

--changeset diego:v1.3-dcl-grant-001-tip-favorites runInTransaction:false
--comment: places_rw has no DELETE on the schema. Un-marking a favorite deletes its row, so this table (and only this one) gets DELETE. Tips are never deleted: they are deactivated (HU-064)
GRANT DELETE ON OBJECT::places.tip_favorites TO places_rw;
DENY  DELETE ON OBJECT::places.tips          TO places_rw;
--rollback REVOKE DELETE ON OBJECT::places.tips FROM places_rw;
--rollback REVOKE DELETE ON OBJECT::places.tip_favorites FROM places_rw;
