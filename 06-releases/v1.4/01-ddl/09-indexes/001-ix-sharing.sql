--liquibase formatted sql

--changeset juan:v1.4-ddl-index-001-ix-place-members
--comment: HU-010 the places shared with a user (their list) and HU-046 the collaborators of a place. UQ_pmem_place_user already serves "membership of this user in this place"
CREATE INDEX IX_pmem_user  ON places.place_members (user_id)  WHERE revoked_at IS NULL;
CREATE INDEX IX_pmem_place ON places.place_members (place_id) WHERE revoked_at IS NULL;
--rollback DROP INDEX IX_pmem_place ON places.place_members;
--rollback DROP INDEX IX_pmem_user  ON places.place_members;

--changeset juan:v1.4-ddl-index-002-ix-invitations
--comment: HU-042 invitations of a place, newest first; HU-043 the pending invitations of an e-mail; INV-I003 only one PENDING invitation per place + e-mail
CREATE INDEX        IX_inv_place        ON places.invitations (place_id, created_at DESC);
CREATE INDEX        IX_inv_email_status ON places.invitations (email, status);
CREATE UNIQUE INDEX UX_inv_pending      ON places.invitations (place_id, email) WHERE status = N'PENDING';
--rollback DROP INDEX UX_inv_pending      ON places.invitations;
--rollback DROP INDEX IX_inv_email_status ON places.invitations;
--rollback DROP INDEX IX_inv_place        ON places.invitations;

--changeset juan:v1.4-ddl-index-003-ix-guest-links
--comment: HU-039 a place has at most one active link. The token is already unique (UQ_glink_token), which serves the anonymous lookups
CREATE UNIQUE INDEX UX_glink_active_place ON places.guest_links (place_id) WHERE deactivated_at IS NULL;
--rollback DROP INDEX UX_glink_active_place ON places.guest_links;
