WITH RECURSIVE subalternos AS (
    -- Parte base: el jefe raíz
    SELECT
        id,
        nombre,
        jefe_id,
        0 AS nivel
    FROM empleados
    WHERE nombre = 'Ana'  

    UNION ALL

   
    SELECT
        e.id,
        e.nombre,
        e.jefe_id,
        s.nivel + 1 AS nivel
    FROM empleados e
    INNER JOIN subalternos s ON e.jefe_id = s.id
)
SELECT
    id,
    nombre,
    jefe_id,
    nivel
FROM subalternos
WHERE nivel > 0         
ORDER BY nivel, nombre;
