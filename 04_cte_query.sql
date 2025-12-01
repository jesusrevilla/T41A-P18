-- Ejercicio CTE: Toda la jerarquía de empleados

WITH RECURSIVE jerarquia AS (
    -- 1.Inicio
    SELECT id, nombre, jefe_id
    FROM empleados
    WHERE id = 1 -- ID del Jefe a consultar

    UNION ALL
    
    -- 2. Paso Recursivo: Buscar todos los empleados que reportan a los empleados encontrados antes
    SELECT e.id, e.nombre, e.jefe_id
    FROM empleados e
    INNER JOIN jerarquia j ON e.jefe_id = j.id
)
SELECT * FROM jerarquia;
