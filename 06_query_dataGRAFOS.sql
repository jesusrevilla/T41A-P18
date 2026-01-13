WITH RECURSIVE subordinados AS (
    SELECT id, nombre, jefe_id 
    FROM empleados 
    WHERE nombre = 'Ana'
    
    UNION ALL
    
    SELECT e.id, e.nombre, e.jefe_id
    FROM empleados e
    INNER JOIN subordinados s ON e.jefe_id = s.id 
)
SELECT * FROM subordinados;
