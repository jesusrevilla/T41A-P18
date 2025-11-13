-- 1_ Crear una tabla empleados con columnas id, nombre, jefe_id
DROP TABLE IF EXISTS empleados CASCADE;

CREATE TABLE empleados (
    id SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    jefe_id INT REFERENCES empleados(id)
);

-- 2_ Insertar una jerarquía de empleados
INSERT INTO empleados (id, nombre, jefe_id) VALUES
(1, 'CEO Mark', NULL),
(2, 'Gerente A', 1),       -- Jefe que se consultara
(3, 'Gerente B', 1),
(4, 'Líder Equipo X', 2),  -- Nivel 1
(5, 'Desarrollador 1', 4), -- Nivel 2
(6, 'Desarrollador 2', 4), -- Nivel 2
(7, 'Asistente', 3);

-- 3_ Usar una CTE recursiva para listar todos los subordinados del jefe con ID 2
\set jefe_a_id 2

WITH RECURSIVE subordinados_red AS (
    -- Selecciona el jefe inicial con ID 2
    SELECT 
        id, 
        nombre, 
        jefe_id, 
        0 AS nivel 
    FROM 
        empleados 
    WHERE 
        id = :jefe_a_id
        
    UNION ALL
    
    -- RECURSIÓN: Encuentra los empleados cuyo jefe_id es uno de los IDs ya encontrados
    SELECT 
        e.id, 
        e.nombre, 
        e.jefe_id,
        r.nivel + 1 
    FROM 
        empleados e
    INNER JOIN 
        subordinados_red r ON e.jefe_id = r.id
)
-- Muestra solo los subordinados de nivel > 0
SELECT 
    id, 
    nombre, 
    jefe_id,
    'Nivel ' || nivel AS profundidad
FROM 
    subordinados_red
WHERE 
    nivel > 0 
ORDER BY 
    nivel, id;
