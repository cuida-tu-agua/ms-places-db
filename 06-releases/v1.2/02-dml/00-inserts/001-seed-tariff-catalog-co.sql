--liquibase formatted sql

--changeset diego:v1.2-dml-001-seed-tariff-catalog-co context:seed splitStatements:false
--comment: HU-066 REFERENCE tariffs (water + sewer, COP) for 9 Colombian cities, strata 1-6, effective 2026-01-01. They are development placeholders with the real SHAPE of the regime (cargo fijo + basic <=20 m3 / complementary <=40 m3 / luxury; subsidy on the basic range of strata 1-3, contribution on strata 5-6), NOT official values. Before production load the real tariffs of each utility as NEW rows (new effective_from) and keep these as history
DECLARE @base TABLE (city_code NVARCHAR(5), fixed_charge DECIMAL(12,2), price_m3 DECIMAL(12,2), source NVARCHAR(200));
INSERT INTO @base (city_code, fixed_charge, price_m3, source) VALUES
    (N'11001', 17500, 7400, N'REFERENCIA de desarrollo (no oficial): Bogotá, D.C. - verificar con la factura'),
    (N'05001', 15800, 6900, N'REFERENCIA de desarrollo (no oficial): Medellín - verificar con la factura'),
    (N'76001', 14900, 6300, N'REFERENCIA de desarrollo (no oficial): Cali - verificar con la factura'),
    (N'08001', 14200, 5900, N'REFERENCIA de desarrollo (no oficial): Barranquilla - verificar con la factura'),
    (N'13001', 15100, 6600, N'REFERENCIA de desarrollo (no oficial): Cartagena de Indias - verificar con la factura'),
    (N'68001', 14600, 6100, N'REFERENCIA de desarrollo (no oficial): Bucaramanga - verificar con la factura'),
    (N'66001', 13900, 5800, N'REFERENCIA de desarrollo (no oficial): Pereira - verificar con la factura'),
    (N'17001', 13700, 5700, N'REFERENCIA de desarrollo (no oficial): Manizales - verificar con la factura'),
    (N'54001', 14000, 6000, N'REFERENCIA de desarrollo (no oficial): San José de Cúcuta - verificar con la factura');

-- subsidy_pct applies to the basic range (strata 1-3); contribution_pct to everything (strata 5-6); stratum 4 pays the full cost
DECLARE @rules TABLE (stratum TINYINT, basic_factor DECIMAL(5,2), other_factor DECIMAL(5,2));
INSERT INTO @rules (stratum, basic_factor, other_factor) VALUES
    (1, 0.30, 1.00), (2, 0.60, 1.00), (3, 0.85, 1.00), (4, 1.00, 1.00), (5, 1.50, 1.50), (6, 1.60, 1.60);

INSERT INTO places.tariff_catalog (city_id, stratum, fixed_charge, basic_price, complementary_price, luxury_price, effective_from, source)
SELECT c.id, r.stratum,
       CAST(b.fixed_charge * r.basic_factor AS DECIMAL(12,2)),
       CAST(b.price_m3 * r.basic_factor     AS DECIMAL(12,2)),
       CAST(b.price_m3 * r.other_factor     AS DECIMAL(12,2)),
       CAST(b.price_m3 * r.other_factor     AS DECIMAL(12,2)),
       '2026-01-01', b.source
FROM @base b
JOIN places.cities c ON c.code = b.city_code
CROSS JOIN @rules r
WHERE NOT EXISTS (SELECT 1 FROM places.tariff_catalog t WHERE t.city_id = c.id AND t.stratum = r.stratum AND t.effective_from = '2026-01-01');
--rollback DELETE FROM places.tariff_catalog WHERE effective_from = '2026-01-01' AND source LIKE N'REFERENCIA de desarrollo%';
