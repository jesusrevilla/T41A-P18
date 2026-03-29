SELECT nombre, etiquetas FROM productos WHERE etiquetas @> ARRAY['tecnología']; 

WITH RECURSIVE red_empleados AS (
    SELECT id, nombre, jefe_id FROM empleados WHERE nombre = 'Uriel'
    UNION ALL
    SELECT e.id, e.nombre, e.jefe_id
    FROM empleados e
    INNER JOIN red_empleados r ON e.jefe_id = r.id
)
SELECT * FROM red_empleados;

WITH RECURSIVE ciudades_alcanzables AS (
    SELECT  nombre, alrededores FROM ciudades WHERE nombre = 'San Luis Potosí'
    UNION ALL
    SELECT c.nombre, c.alrededores
    FROM ciudades c
    INNER JOIN ciudades_alcanzables a ON c.nombre = ANY(a.alrededores)
)
SELECT * FROM ciudades_alcanzables;
