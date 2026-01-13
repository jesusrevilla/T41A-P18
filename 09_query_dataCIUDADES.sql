WITH RECURSIVE ruta_viaje AS (
    SELECT 
        nombre AS ciudad_origen, 
        conexiones
    FROM red_ciudades
    WHERE nombre = 'CDMX' 
    
    UNION
    
    SELECT 
        c.nombre, 
        c.conexiones
    FROM red_ciudades c
    INNER JOIN ruta_viaje r 
        ON c.nombre = ANY(r.conexiones)
)
SELECT * FROM ruta_viaje;
