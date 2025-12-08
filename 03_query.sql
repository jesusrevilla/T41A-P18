CREATE OR REPLACE VIEW productos_tecnologia AS
SELECT nombre
FROM productos
WHERE etiqueta @> ARRAY['tecnología'];


CREATE OR REPLACE VIEW jerarquia_empleados AS
WITH RECURSIVE jerarquia AS (
    SELECT id, nombre, jefe_id
    FROM empleados
    WHERE jefe_id = 1
    
    UNION ALL
    
    SELECT e.id, e.nombre, e.jefe_id
    FROM empleados e
    INNER JOIN jerarquia j ON e.jefe_id = j.id
)
SELECT nombre FROM jerarquia;

CREATE OR REPLACE VIEW recorrido AS
WITH RECURSIVE r AS (
    SELECT 
        ciudad,
        conexiones,
        ARRAY[ciudad] AS visitadas
    FROM ciudades
    WHERE ciudad = 'A'

    UNION ALL

    SELECT 
        c.ciudad,
        c.conexiones,
        r.visitadas || c.ciudad
    FROM ciudades c
    JOIN r ON c.ciudad = ANY(r.conexiones)
    WHERE NOT (c.ciudad = ANY(r.visitadas))
)
SELECT ciudad FROM r;

