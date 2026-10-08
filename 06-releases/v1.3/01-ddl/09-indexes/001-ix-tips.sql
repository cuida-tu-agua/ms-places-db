--liquibase formatted sql

--changeset diego:v1.3-ddl-index-001-ix-tips
--comment: HU-065 "active tips of this kind of place"; HU-063/064 admin list by category
CREATE INDEX IX_tips_category_active ON places.tips (category, is_active);
--rollback DROP INDEX IX_tips_category_active ON places.tips;

--changeset diego:v1.3-ddl-index-002-ix-tip-favorites
--comment: HU-065 favorites of a tip (how many users keep it); the primary key already serves "favorites of a user"
CREATE INDEX IX_tipfav_tip ON places.tip_favorites (tip_id);
--rollback DROP INDEX IX_tipfav_tip ON places.tip_favorites;
