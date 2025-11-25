SELECT nombre
FROM productos
WHERE 'tecnología' = ANY(etiquetas);

WITH RECURSIVE sub AS (
    SELECT id, nombre, jefe_id
    FROM empleados
    WHERE nombre = 'Luis'
    UNION ALL
    SELECT e.id, e.nombre, e.jefe_id
    FROM empleados e
    INNER JOIN sub s ON e.jefe_id = s.id
)
SELECT * FROM sub;

WITH RECURSIVE rutas AS (
    SELECT id, nombre, conexiones
    FROM ciudades
    WHERE nombre = 'Ciudad A'

    UNION ALL

    SELECT c.id, c.nombre, c.conexiones
    FROM ciudades c
    JOIN rutas r ON c.id = ANY(r.conexiones)
)
SELECT nombre FROM rutas;
