SELECT * FROM productos WHERE 'tecnología' = ANY(etiquetas);

--CTE
WITH RECURSIVE red_jefes AS (
    SELECT id, nombre, jefe_id FROM empleados WHERE nombre = 'David'
    UNION ALL
    SELECT e.id, e.nombre, e.jefe_id
    FROM empleados e
    INNER JOIN red_jefes r ON e.jefe_id = r.id
)

SELECT * FROM red_jefes;

--Ejercicios Recomendados
WITH RECURSIVE red_rutas AS (
    SELECT
        id,
        nombre,
        ruta_id,
        ARRAY[id] AS visitados
    FROM ciudades
    WHERE nombre = 'Amsterdam'

    UNION ALL

    SELECT
        c.id,
        c.nombre,
        c.ruta_id,
        r.visitados || c.id
    FROM ciudades c
    JOIN red_rutas r ON c.id = ANY(r.ruta_id)
    WHERE NOT c.id = ANY(r.visitados)
)

SELECT id, nombre, ruta_id
FROM red_rutas;
