
-- Subordinados de "Ana (Jefa)"
WITH RECURSIVE red_empleados AS (
    SELECT id, nombre, jefe_id 
    FROM empleados 
    WHERE jefe_id = 1  -- Maria depende de Ana

    UNION ALL

    SELECT e.id, e.nombre, e.jefe_id
    FROM empleados e
    INNER JOIN red_empleados r ON e.jefe_id = r.id
)
SELECT * FROM red_empleados;


-- Productos con etiqueta "tecnología"
SELECT nombre 
FROM productos
WHERE 'tecnología' = ANY(etiquetas);


-- Mostrar primera etiqueta por producto
SELECT nombre, etiquetas[1] AS primera_etiqueta
FROM productos;


