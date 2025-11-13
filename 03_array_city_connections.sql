-- Creación de la tabla de ciudades con conexiones usando arrays (TEXT[])
DROP TABLE IF EXISTS ciudades CASCADE;

CREATE TABLE ciudades (
    id SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    conexiones TEXT[] -- Array de nombres de ciudades directamente conectadas
);

-- Insertar datos para modelar el grafo
-- A -> B, C
-- B -> D
-- C -> E
-- D -> E, F
-- E -> B
-- F -> G
INSERT INTO ciudades (nombre, conexiones)
VALUES 
    ('Atenas', ARRAY['Berlín', 'Caracas']),
    ('Berlín', ARRAY['Dakar']),
    ('Caracas', ARRAY['Estambul']),
    ('Dakar', ARRAY['Estambul', 'Fuji']),
    ('Estambul', ARRAY['Berlín']),
    ('Fuji', ARRAY['Guadalajara']),
    ('Guadalajara', NULL); -- Ciudad sin salidas
