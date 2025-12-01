-- Consultar todas las ciudades alcanzables desde Atenas
\set start_city 'Atenas'

WITH RECURSIVE ciudades_alcanzables AS (
    -- Selecciona la ciudad inicial
    SELECT 
        nombre AS ciudad_actual,
        ARRAY[nombre] AS ruta_seguida, -- Array para registrar la ruta y detectar ciclos
        0 AS distancia
    FROM 
        ciudades 
    WHERE 
        nombre = :'start_city'
        
    UNION ALL
    
    -- Recursión: Encuentra ciudades en las conexiones de la ciudad actual
    SELECT 
        c.conexion,
        r.ruta_seguida || c.conexion, -- Añade la nueva ciudad a la ruta
        r.distancia + 1
    FROM 
        ciudades_alcanzables r
    JOIN 
        ciudades o ON r.ciudad_actual = o.nombre
    CROSS JOIN 
        unnest(o.conexiones) AS c(conexion) -- Expande el array de conexiones a filas
    WHERE
        -- Condición para detener el ciclo: La ciudad de conexión NO debe estar en la ruta seguida
        NOT (c.conexion = ANY(r.ruta_seguida))
)
-- Muestra todas las ciudades únicas alcanzables, excluyendo la ciudad inicial
SELECT DISTINCT
    ciudad_actual,
    ruta_seguida,
    distancia
FROM 
    ciudades_alcanzables
ORDER BY 
    distancia, ciudad_actual;
