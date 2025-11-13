CREATE TABLE ciudad (
  id INT PRIMARY KEY, 
  nombre TEXT,
  rutas INT[]
);

INSERT INTO ciudad (id, nombre, rutas)
VALUES
(1, 'Ciudad de México', ARRAY[5]),
(2, 'San Luis Potosí',  ARRAY[3, 4]),
(3, 'Monterrey',        ARRAY[]),
(4, 'Guadalajara',      ARRAY[3]),
(5, 'Querétaro',        ARRAY[1, 2]);


WITH RECURSIVE ciudades_alcanzables AS (
    SELECT 
        id, 
        nombre, 
        rutas,
        0 AS distancia, 
        ARRAY[id] AS visitados 
    FROM ciudad
    WHERE id = 1
    UNION ALL
    SELECT 
        c.id, 
        c.nombre, 
        c.rutas,
        ca.distancia + 1,
        ca.visitados || c.id
    FROM ciudad c
    INNER JOIN ciudades_alcanzables ca ON c.id = ANY(ca.rutas)
    WHERE NOT (c.id = ANY(ca.visitados))
)

SELECT id, nombre, distancia, visitados AS camino
FROM ciudades_alcanzables;
