CREATE TABLE ciudades (
    nombre TEXT PRIMARY KEY, 
    conexiones TEXT[]       
);

INSERT INTO ciudades (nombre, conexiones) VALUES 
    ('San Luis Potosí', ARRAY['Rioverde', 'Matehuala']),
    ('Matehuala', ARRAY['San Luis Potosí', 'Real de Catorce']), 
    ('Real de Catorce', ARRAY['Matehuala']),
    ('Rioverde', ARRAY['San Luis Potosí', 'Ciudad Valles']),
    ('Ciudad Valles', ARRAY['Rioverde', 'Xilitla', 'Tamazunchale']),
    ('Xilitla', ARRAY['Ciudad Valles']),
    ('Tamazunchale', ARRAY['Ciudad Valles']);

WITH RECURSIVE viaje AS (
    SELECT 
        nombre, 
        conexiones,
        ARRAY[nombre] AS ruta_recorrida
    FROM ciudades
    WHERE nombre = 'San Luis Potosí'

    UNION ALL
    SELECT 
        c.nombre, 
        c.conexiones,
        v.ruta_recorrida || c.nombre
    FROM ciudades c
    JOIN viaje v ON c.nombre = ANY(v.conexiones)
    WHERE NOT (c.nombre = ANY(v.ruta_recorrida)) 
)
SELECT nombre FROM viaje;
