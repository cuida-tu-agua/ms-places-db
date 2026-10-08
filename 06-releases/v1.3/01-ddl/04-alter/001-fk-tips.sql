--liquibase formatted sql

--changeset diego:v1.3-ddl-fk-001-fk-tipfav-tip
--comment: tip_favorites -> tips (HU-065). Tips are deactivated, never deleted, so a favorite is never orphaned
ALTER TABLE places.tip_favorites
    ADD CONSTRAINT FK_tipfav_tip
    FOREIGN KEY (tip_id) REFERENCES places.tips (id);
--rollback ALTER TABLE places.tip_favorites DROP CONSTRAINT FK_tipfav_tip;

--changeset diego:v1.3-ddl-fk-002-fk-tipfav-user
--comment: tip_favorites -> security.users (same cross-schema reference that places.owner_id uses)
ALTER TABLE places.tip_favorites
    ADD CONSTRAINT FK_tipfav_user
    FOREIGN KEY (user_id) REFERENCES security.users (id);
--rollback ALTER TABLE places.tip_favorites DROP CONSTRAINT FK_tipfav_user;
