--liquibase formatted sql

--changeset diego:v1.3-dml-001-seed-starter-tips
--comment: HU-063/065 starter tips (general good practices, not personalised) so a user always has at least 3 tips per kind of place from day one. Administrators can edit or deactivate them. Product content: loads in every environment
INSERT INTO places.tips (title, body, category)
SELECT v.title, v.body, v.category
FROM (VALUES
    (N'Cierra el grifo mientras te cepillas',        N'Dejar la llave abierta al cepillarte los dientes gasta hasta 12 litros por minuto. Ábrela solo para enjuagar.', N'RESIDENTIAL'),
    (N'Duchas de cinco minutos',                      N'Reducir la ducha de diez a cinco minutos ahorra cerca de 60 litros cada vez. Cierra la llave mientras te enjabonas.', N'RESIDENTIAL'),
    (N'Revisa fugas del sanitario',                   N'Echa unas gotas de colorante en el tanque: si el color aparece en la taza sin accionar la descarga, hay una fuga que puede perder cientos de litros al día.', N'RESIDENTIAL'),
    (N'Lava la ropa con carga completa',              N'La lavadora gasta casi lo mismo con media carga que con carga completa. Espera a llenarla y usa el programa económico.', N'RESIDENTIAL'),
    (N'Riega al amanecer o al atardecer',             N'Con menos sol y viento se evapora menos agua. Riega las plantas a primera o a última hora y usa regadera en lugar de manguera.', N'RESIDENTIAL'),
    (N'Reutiliza el agua de la cocina',               N'El agua con la que lavas frutas y verduras sirve para regar las plantas. Recógela en un balde en vez de dejarla ir por el desagüe.', N'RESIDENTIAL'),
    (N'Mide el consumo en horas de menor actividad',  N'Si el medidor marca flujo cuando el negocio está cerrado, hay una fuga. Revisa el consumo nocturno y fines de semana.', N'COMMERCIAL'),
    (N'Aireadores en los grifos',                     N'Instalar aireadores o grifos de bajo caudal en baños y cocinas reduce el flujo hasta un 50 % sin que los clientes lo noten.', N'COMMERCIAL'),
    (N'Sanitarios de doble descarga',                 N'Una descarga corta para líquidos y otra larga para sólidos ahorra miles de litros al mes en locales con mucho público.', N'COMMERCIAL'),
    (N'Lavado de pisos sin manguera abierta',         N'Barre antes de lavar y usa balde o hidrolavadora de bajo caudal. Una manguera abierta puede gastar 15 litros por minuto.', N'COMMERCIAL'),
    (N'Capacita a tu personal',                       N'Una breve charla sobre cerrar llaves, reportar goteos y no dejar equipos funcionando en vacío reduce el consumo de forma sostenida.', N'COMMERCIAL'),
    (N'Programa mantenimiento preventivo',            N'Revisar tuberías, válvulas y flotadores cada trimestre evita fugas ocultas que se notan solo en la factura del mes siguiente.', N'COMMERCIAL')
) AS v(title, body, category)
WHERE NOT EXISTS (SELECT 1 FROM places.tips t WHERE t.title = v.title AND t.category = v.category);
--rollback DELETE FROM places.tips WHERE created_by IS NULL AND title IN (N'Cierra el grifo mientras te cepillas', N'Duchas de cinco minutos', N'Revisa fugas del sanitario', N'Lava la ropa con carga completa', N'Riega al amanecer o al atardecer', N'Reutiliza el agua de la cocina', N'Mide el consumo en horas de menor actividad', N'Aireadores en los grifos', N'Sanitarios de doble descarga', N'Lavado de pisos sin manguera abierta', N'Capacita a tu personal', N'Programa mantenimiento preventivo');
