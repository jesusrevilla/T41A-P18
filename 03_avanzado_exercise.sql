CREATE TABLE ciudades2 (
    id SERIAL PRIMARY KEY,
    nombre TEXT,
    rutas_directas TEXT[]
);

INSERT INTO ciudades2 (nombre, rutas_directas)
VALUES 
('San Luis Potosí', ARRAY['Ciudad Fernandez', 'Soledad de Graciano Sanchez', 'Ahualulco']),
('Ciudad Fernandez', ARRAY['Rioverde', 'Cerritos', 'Villa de Reyes']),
('Ahualulco', ARRAY['Moctezuma', 'Matehuala', 'Cerritos']);

WITH RECURSIVE viajes_posibles (ciudad, visitadas) AS (


    SELECT
        nombre,
        ARRAY[nombre] AS visitadas
        FROM
        ciudades2
    WHERE
        nombre = 'San Luis Potosí' 

    UNION ALL

    SELECT
        s.ruta_siguiente,
        v.visitadas || s.ruta_siguiente
    FROM
        viajes_posibles AS v
    JOIN
        ciudades2 AS c ON v.ciudad = c.nombre
    CROSS JOIN
        unnest(c.rutas_directas) AS s(ruta_siguiente)
        
    WHERE
        NOT (s.ruta_siguiente = ANY(v.visitadas))
)

SELECT DISTINCT ciudad FROM viajes_posibles;
