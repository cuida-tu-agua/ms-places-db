--liquibase formatted sql

--changeset juan:v1.4-ddl-fk-001-fk-pmem-place
--comment: place_members -> places. Places are soft-deleted, so a membership is never orphaned
ALTER TABLE places.place_members
    ADD CONSTRAINT FK_pmem_place
    FOREIGN KEY (place_id) REFERENCES places.places (id);
--rollback ALTER TABLE places.place_members DROP CONSTRAINT FK_pmem_place;

--changeset juan:v1.4-ddl-fk-002-fk-pmem-user
--comment: place_members -> security.users (same cross-schema reference that places.owner_id uses). Accounts are soft-deleted too
ALTER TABLE places.place_members
    ADD CONSTRAINT FK_pmem_user
    FOREIGN KEY (user_id) REFERENCES security.users (id);
--rollback ALTER TABLE places.place_members DROP CONSTRAINT FK_pmem_user;

--changeset juan:v1.4-ddl-fk-003-fk-inv-place
--comment: invitations -> places
ALTER TABLE places.invitations
    ADD CONSTRAINT FK_inv_place
    FOREIGN KEY (place_id) REFERENCES places.places (id);
--rollback ALTER TABLE places.invitations DROP CONSTRAINT FK_inv_place;

--changeset juan:v1.4-ddl-fk-004-fk-inv-invited-by
--comment: invitations -> security.users (the owner who invited)
ALTER TABLE places.invitations
    ADD CONSTRAINT FK_inv_invited_by
    FOREIGN KEY (invited_by) REFERENCES security.users (id);
--rollback ALTER TABLE places.invitations DROP CONSTRAINT FK_inv_invited_by;

--changeset juan:v1.4-ddl-fk-005-fk-glink-place
--comment: guest_links -> places
ALTER TABLE places.guest_links
    ADD CONSTRAINT FK_glink_place
    FOREIGN KEY (place_id) REFERENCES places.places (id);
--rollback ALTER TABLE places.guest_links DROP CONSTRAINT FK_glink_place;

--changeset juan:v1.4-ddl-fk-006-fk-glink-created-by
--comment: guest_links -> security.users (the owner who generated it)
ALTER TABLE places.guest_links
    ADD CONSTRAINT FK_glink_created_by
    FOREIGN KEY (created_by) REFERENCES security.users (id);
--rollback ALTER TABLE places.guest_links DROP CONSTRAINT FK_glink_created_by;

--changeset juan:v1.4-ddl-alter-007-activity-log-actions
--comment: HU-046 "the revocation is logged". The audit log only accepted PLACE_DELETED; it now also accepts COLLABORATOR_REVOKED. The table stays append-only for places_rw (v1.1)
ALTER TABLE places.activity_log DROP CONSTRAINT CK_place_activity_action;
ALTER TABLE places.activity_log
    ADD CONSTRAINT CK_place_activity_action CHECK (action IN (N'PLACE_DELETED', N'COLLABORATOR_REVOKED'));
--rollback ALTER TABLE places.activity_log DROP CONSTRAINT CK_place_activity_action;
--rollback ALTER TABLE places.activity_log ADD CONSTRAINT CK_place_activity_action CHECK (action IN (N'PLACE_DELETED'));
