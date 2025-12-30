CREATE TABLE ciudad (
  id INT PRIMARY KEY, 
  nombre TEXT,
  rutas INT[]
);

INSERT INTO ciudad (id, nombre, rutas)
VALUES
(1, 'Ciudad de México', ARRAY[5]),
(2, 'San Luis Potosí',  ARRAY[3, 4]),
(3, 'Monterrey',        ARRAY[]::INT[]),
(4, 'Guadalajara',      ARRAY[3]),
(5, 'Querétaro',        ARRAY[1, 2]);


CREATE OR REPLACE FUNCTION obtener_ciudades_alcanzables(
    p_ciudad_id INT
)
RETURNS TABLE(
    id_ciudad INT,
    nombre_ciudad TEXT,
    distancia INT,
    camino_recorrido INT[]
) AS $$
BEGIN
    RETURN QUERY
    WITH RECURSIVE ciudades_alcanzables AS (
        SELECT 
            id, 
            nombre, 
            rutas,
            0 AS dist, 
            ARRAY[id] AS visit
        FROM ciudad
        WHERE id = p_ciudad_id
        UNION ALL
        SELECT 
            c.id, 
            c.nombre, 
            c.rutas,
            ca.dist + 1, 
            ca.visit || c.id
        FROM ciudad c
        INNER JOIN ciudades_alcanzables ca ON c.id = ANY(ca.rutas) 
        
        WHERE NOT (c.id = ANY(ca.visit))
    )
    SELECT 
        id, 
        nombre, 
        dist, 
        visit
    FROM ciudades_alcanzables;
END;
$$ LANGUAGE plpgsql;
