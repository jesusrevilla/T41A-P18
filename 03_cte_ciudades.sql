CREATE TABLE rutas (
    origen TEXT,
    destino TEXT
);


INSERT INTO rutas (origen, destino) VALUES
('Madrid', 'Barcelona'),
('Madrid', 'Valencia'),
('Valencia', 'Sevilla'),
('Sevilla', 'Granada'),
('Barcelona', 'Zaragoza'),
('Zaragoza', 'Bilbao'),
('Granada', 'Málaga');



WITH RECURSIVE conexiones AS (
    SELECT origen, destino
    FROM rutas
    WHERE origen = 'Madrid'
    UNION
    SELECT r.origen, r.destino
    FROM rutas r
    INNER JOIN conexiones c ON r.origen = c.destino
)
SELECT DISTINCT destino AS ciudad_alcanzable
FROM conexiones;


WITH RECURSIVE mapa AS (
    SELECT origen, destino
    FROM rutas
    WHERE origen = 'Madrid'
    UNION
    SELECT r.origen, r.destino
    FROM rutas r
    INNER JOIN mapa m ON r.origen = m.destino
)
SELECT * FROM mapa;
