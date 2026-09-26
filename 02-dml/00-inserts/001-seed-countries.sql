--liquibase formatted sql

--changeset esteban:dml-001-seed-countries
--comment: Active countries (HU-053). Reference data: loads in every environment (no context)
INSERT INTO places.countries (code, name, default_currency, default_unit) VALUES
    (N'CO', N'Colombia', N'COP', N'LITERS'),
    (N'EC', N'Ecuador',  N'USD', N'LITERS');
--rollback DELETE FROM places.countries WHERE code IN (N'CO', N'EC');