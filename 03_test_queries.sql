-- Consultar todos los productos
SELECT * FROM productos;

-- Consultar jerarquía completa
WITH RECURSIVE jerarquia AS (
    SELECT id, nombre, jefe_id FROM empleados WHERE nombre = 'Director'
    UNION ALL
    SELECT e.id, e.nombre, e.jefe_id
    FROM empleados e
    INNER JOIN jerarquia j ON e.jefe_id = j.id
)
SELECT * FROM jerarquia;
