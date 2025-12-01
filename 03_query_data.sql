SELECT * FROM productos WHERE etiquetas @> ARRAY['tecnologia'];

WITH RECURSIVE red_jefes AS (
    SELECT id, nombre, jefe_id
    FROM empleados
    WHERE id = 1
    
    UNION ALL

    SELECT e.id, e.nombre, e.jefe_id
    FROM empleados e
    JOIN red_jefes r ON e.jefe_id = r.id
)
SELECT * FROM red_jefes;
