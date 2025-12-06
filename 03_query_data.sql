SELECT *
FROM productos
WHERE 'tecnología' = ANY (etiquetas);

WITH RECURSIVE subalternos AS (
    SELECT id, nombre, jefe_id
    FROM empleados
    WHERE nombre = 'Luis'

    UNION ALL

    SELECT e.id, e.nombre, e.jefe_id
    FROM empleados e
    INNER JOIN subalternos s ON e.jefe_id = s.id
)
SELECT * FROM subalternos;

WITH RECURSIVE conexiones AS (
    SELECT ciudad, destino
    FROM rutas
    WHERE ciudad = 'A'

    UNION ALL

    SELECT r.ciudad, r.destino
    FROM rutas r
    INNER JOIN conexiones c ON r.ciudad = c.destino
)
SELECT * FROM conexiones;

WITH RECURSIVE conexiones AS (
    SELECT nombre, conexiones
    FROM ciudades
    WHERE nombre = 'A'

    UNION ALL

    SELECT c.nombre, c.conexiones
    FROM ciudades c
    INNER JOIN LATERAL unnest(conexiones.conexiones) AS next(n) ON c.nombre = next.n
    INNER JOIN conexiones ON TRUE
)
SELECT DISTINCT nombre FROM conexiones;
