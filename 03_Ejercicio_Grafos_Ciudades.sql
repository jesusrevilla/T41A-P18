CREATE TABLE ciudades (
    id SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    pais TEXT DEFAULT 'España'
);

CREATE TABLE rutas (
    id SERIAL PRIMARY KEY,
    ciudad_origen_id INTEGER REFERENCES ciudades(id),
    ciudad_destino_id INTEGER REFERENCES ciudades(id),
    distancia_km INTEGER,
    UNIQUE(ciudad_origen_id, ciudad_destino_id)
);

INSERT INTO ciudades (nombre, pais) VALUES
('Madrid', 'España'),
('Barcelona', 'España'),
('Valencia', 'España'),
('Sevilla', 'España'),
('Zaragoza', 'España'),
('Bilbao', 'España'),
('París', 'Francia'),
('Lyon', 'Francia');

INSERT INTO rutas (ciudad_origen_id, ciudad_destino_id, distancia_km) VALUES
(1, 2, 621), (2, 1, 621),   -- Madrid <-> Barcelona
(1, 3, 355), (3, 1, 355),   -- Madrid <-> Valencia
(1, 4, 534), (4, 1, 534),   -- Madrid <-> Sevilla
(1, 5, 325), (5, 1, 325),   -- Madrid <-> Zaragoza
(2, 5, 296), (5, 2, 296),   -- Barcelona <-> Zaragoza
(5, 6, 324), (6, 5, 324),   -- Zaragoza <-> Bilbao
(2, 7, 1038), (7, 2, 1038), -- Barcelona <-> París
(7, 8, 466), (8, 7, 466);   -- París <-> Lyon

WITH RECURSIVE ciudades_alcanzables AS (
    SELECT 
        c.id,
        c.nombre,
        c.pais,
        0 as saltos,
        ARRAY[c.id] as camino,
        ARRAY[c.nombre] as camino_nombres,
        0 as distancia_acumulada
    
    FROM ciudades c
    WHERE c.nombre = 'Madrid'
    
    UNION ALL
    
    SELECT 
        cd.id,
        cd.nombre,
        cd.pais,
        ca.saltos + 1 as saltos,
        ca.camino || cd.id as camino,
        ca.camino_nombres || cd.nombre as camino_nombres,
        ca.distancia_acumulada + r.distancia_km as distancia_acumulada
    
    FROM rutas r
    INNER JOIN ciudades cd ON r.ciudad_destino_id = cd.id
    INNER JOIN ciudades_alcanzables ca ON r.ciudad_origen_id = ca.id

    WHERE 
        ca.saltos < 3 AND  
        cd.id != ALL(ca.camino)  
)
SELECT 
    nombre as ciudad,
    pais,
    saltos,
    distancia_acumulada || ' km' as distancia_total,
    array_to_string(camino_nombres, ' -> ') as ruta
FROM ciudades_alcanzables
ORDER BY saltos, distancia_acumulada;

CREATE TABLE ciudades_con_conexiones (
    id SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    pais TEXT,
    conexiones_directas INTEGER[], 
    distancias INTEGER[] 
);

INSERT INTO ciudades_con_conexiones (nombre, pais, conexiones_directas, distancias) VALUES
('Madrid', 'España', ARRAY[2,3,4,5], ARRAY[621,355,534,325]),
('Barcelona', 'España', ARRAY[1,5,7], ARRAY[621,296,1038]),
('Valencia', 'España', ARRAY[1], ARRAY[355]),
('Sevilla', 'España', ARRAY[1], ARRAY[534]),
('Zaragoza', 'España', ARRAY[1,2,6], ARRAY[325,296,324]),
('Bilbao', 'España', ARRAY[5], ARRAY[324]),
('París', 'Francia', ARRAY[2,8], ARRAY[1038,466]),
('Lyon', 'Francia', ARRAY[7], ARRAY[466]);

CREATE OR REPLACE FUNCTION obtener_distancia(ciudad_id INTEGER, conexion_id INTEGER)
RETURNS INTEGER AS $$
DECLARE
    posicion INTEGER;
    dist INTEGER;
BEGIN
    SELECT array_position(conexiones_directas, conexion_id) INTO posicion;
    IF posicion IS NOT NULL THEN
        dist := distancias[posicion];
    ELSE
        dist := NULL;
    END IF;
    RETURN dist;
END;
$$ LANGUAGE plpgsql;

WITH RECURSIVE viaje_ciudades AS (
    SELECT 
        id,
        nombre,
        pais,
        0 as saltos,
        ARRAY[id] as visitadas,
        ARRAY[nombre] as ruta,
        0 as distancia_total
    FROM ciudades_con_conexiones 
    WHERE nombre = 'Madrid'
    
    UNION ALL
    
    SELECT 
        dest.id,
        dest.nombre,
        dest.pais,
        vc.saltos + 1,
        vc.visitadas || dest.id,
        vc.ruta || dest.nombre,
        vc.distancia_total + obtener_distancia(
            (SELECT id FROM ciudades_con_conexiones WHERE nombre = vc.ruta[array_length(vc.ruta, 1)]),
            dest.id
        )
    FROM ciudades_con_conexiones dest, viaje_ciudades vc
    WHERE 
        dest.id = ANY(
            SELECT unnest(conexiones_directas) 
            FROM ciudades_con_conexiones orig 
            WHERE orig.id = vc.id
        )
        AND dest.id != ALL(vc.visitadas)
        AND vc.saltos < 3
)
SELECT 
    nombre as ciudad_destino,
    pais,
    saltos as "numero_saltos",
    distancia_total || ' km' as "distancia_acumulada",
    array_to_string(ruta, ' → ') as itinerario
FROM viaje_ciudades
ORDER BY saltos, distancia_total;
