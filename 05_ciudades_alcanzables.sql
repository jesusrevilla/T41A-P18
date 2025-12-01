WITH RECURSIVE ciudades_reachable AS (
    -- Ciudad inicial
    SELECT
        nombre      AS origen,
        nombre      AS actual,
        conexiones,
        0           AS nivel
    FROM ciudades_grafo
    WHERE nombre = 'Monterrey'  

    UNION ALL

    
    SELECT
        cr.origen,
        c.nombre      AS actual,
        c.conexiones,
        cr.nivel + 1  AS nivel
    FROM ciudades_reachable cr
    JOIN LATERAL unnest(cr.conexiones) AS conexion(nombre_conectada) ON TRUE
    JOIN ciudades_grafo c ON c.nombre = conexion.nombre_conectada
)
SELECT DISTINCT actual
FROM ciudades_reachable
WHERE nivel > 0      
ORDER BY actual;
