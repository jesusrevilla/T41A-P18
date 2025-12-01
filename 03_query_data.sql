-- Consultar primer interés de cada usuario
SELECT nombre, intereses[1] AS primer_interes FROM usuarios;

-- Consultar productos con etiqueta 'tecnología'
SELECT nombre FROM productos
WHERE 'tecnología' = ANY(etiquetas);

-- Grafo de amigos desde Ana
WITH RECURSIVE red_amigos AS (
    SELECT id, nombre, amigo_id FROM amigos WHERE nombre = 'Ana'
    UNION ALL
    SELECT a.id, a.nombre, a.amigo_id
    FROM amigos a
    INNER JOIN red_amigos r ON a.amigo_id = r.id
)
SELECT * FROM red_amigos;

-- Subordinados de Carlos
WITH RECURSIVE jerarquia AS (
    SELECT id, nombre, jefe_id FROM empleados WHERE nombre = 'Carlos'
    UNION ALL
    SELECT e.id, e.nombre, e.jefe_id
    FROM empleados e
    INNER JOIN jerarquia j ON e.jefe_id = j.id
)
SELECT * FROM jerarquia;

-- Ciudades alcanzables desde A
WITH RECURSIVE rutas AS (
    SELECT nombre, conexiones FROM ciudades WHERE nombre = 'A'
    UNION ALL
    SELECT c.nombre, c.conexiones
    FROM ciudades c
    JOIN rutas r ON c.nombre = ANY(r.conexiones)
)
SELECT nombre FROM rutas;
