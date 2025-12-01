--- Consulta Ejercicio 1: Productos con la etiqueta "tecnología" ---'
SELECT * FROM productos 
WHERE 'tecnología' = ANY(etiquetas);

--- Consulta Ejercicio 2: Subordinados de "Ana (Gerente)" (ID 2) ---
WITH RECURSIVE red_empleados AS (
    SELECT id, nombre, jefe_id
    FROM empleados
    WHERE jefe_id = 2

    UNION ALL

    SELECT e.id, e.nombre, e.jefe_id
    FROM empleados e
    INNER JOIN red_empleados r ON e.jefe_id = r.id
)
SELECT * FROM red_empleados;