--liquibase formatted sql

--changeset esteban:dml-002-seed-subdivisions
--comment: CO departments (DANE DIVIPOLA, 33) and EC provinces (INEC DPA, 24). code = official 2-digit code
INSERT INTO places.subdivisions (country_id, code, name)
SELECT c.id, v.code, v.name
FROM (VALUES
    (N'05', N'Antioquia'),
    (N'08', N'Atlántico'),
    (N'11', N'Bogotá, D.C.'),
    (N'13', N'Bolívar'),
    (N'15', N'Boyacá'),
    (N'17', N'Caldas'),
    (N'18', N'Caquetá'),
    (N'19', N'Cauca'),
    (N'20', N'Cesar'),
    (N'23', N'Córdoba'),
    (N'25', N'Cundinamarca'),
    (N'27', N'Chocó'),
    (N'41', N'Huila'),
    (N'44', N'La Guajira'),
    (N'47', N'Magdalena'),
    (N'50', N'Meta'),
    (N'52', N'Nariño'),
    (N'54', N'Norte de Santander'),
    (N'63', N'Quindío'),
    (N'66', N'Risaralda'),
    (N'68', N'Santander'),
    (N'70', N'Sucre'),
    (N'73', N'Tolima'),
    (N'76', N'Valle del Cauca'),
    (N'81', N'Arauca'),
    (N'85', N'Casanare'),
    (N'86', N'Putumayo'),
    (N'88', N'Archipiélago de San Andrés, Providencia y Santa Catalina'),
    (N'91', N'Amazonas'),
    (N'94', N'Guainía'),
    (N'95', N'Guaviare'),
    (N'97', N'Vaupés'),
    (N'99', N'Vichada')
) AS v (code, name)
JOIN places.countries c ON c.code = N'CO';

INSERT INTO places.subdivisions (country_id, code, name)
SELECT c.id, v.code, v.name
FROM (VALUES
    (N'01', N'Azuay'),
    (N'02', N'Bolívar'),
    (N'03', N'Cañar'),
    (N'04', N'Carchi'),
    (N'05', N'Cotopaxi'),
    (N'06', N'Chimborazo'),
    (N'07', N'El Oro'),
    (N'08', N'Esmeraldas'),
    (N'09', N'Guayas'),
    (N'10', N'Imbabura'),
    (N'11', N'Loja'),
    (N'12', N'Los Ríos'),
    (N'13', N'Manabí'),
    (N'14', N'Morona Santiago'),
    (N'15', N'Napo'),
    (N'16', N'Pastaza'),
    (N'17', N'Pichincha'),
    (N'18', N'Tungurahua'),
    (N'19', N'Zamora Chinchipe'),
    (N'20', N'Galápagos'),
    (N'21', N'Sucumbíos'),
    (N'22', N'Orellana'),
    (N'23', N'Santo Domingo de los Tsáchilas'),
    (N'24', N'Santa Elena')
) AS v (code, name)
JOIN places.countries c ON c.code = N'EC';
--rollback DELETE s FROM places.subdivisions s JOIN places.countries c ON c.id = s.country_id WHERE c.code IN (N'CO', N'EC');
