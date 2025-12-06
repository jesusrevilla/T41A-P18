-- 1. Crear tabla empleados con columnas id, nombre, jefe_id
CREATE TABLE empleados (
    id SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    puesto TEXT,
    jefe_id INTEGER REFERENCES empleados(id)
);

-- 2. Insertar una jerarquía de empleados
INSERT INTO empleados (nombre, puesto, jefe_id) VALUES
('Carlos Rodríguez', 'CEO', NULL),
('María González', 'Directora de Tecnología', 1),
('Juan Pérez', 'Gerente de Desarrollo', 2),
('Ana López', 'Desarrollador Senior', 3),
('Pedro Martínez', 'Desarrollador Junior', 3),
('Laura Sánchez', 'Directora de Marketing', 1),
('Miguel Torres', 'Especialista en Marketing', 6);

-- 3. Usar CTE recursiva para listar todos los subordinados de un jefe específico
WITH RECURSIVE jerarquia_empleados AS (
    -- Caso base: el jefe inicial
    SELECT id, nombre, puesto, jefe_id, 0 as nivel
    FROM empleados 
    WHERE nombre = 'Carlos Rodríguez'
    
    UNION ALL
    
    SELECT e.id, e.nombre, e.puesto, e.jefe_id, j.nivel + 1
    FROM empleados e
    INNER JOIN jerarquia_empleados j ON e.jefe_id = j.id
)
SELECT 
    id,
    nombre,
    puesto,
    nivel,
    CASE 
        WHEN nivel = 0 THEN 'Jefe Superior'
        ELSE 'Subordinado nivel ' || nivel::text
    END as tipo
FROM jerarquia_empleados
ORDER BY nivel, nombre;

WITH RECURSIVE subordinados_tecnologia AS (
    SELECT id, nombre, puesto, jefe_id, 0 as nivel
    FROM empleados 
    WHERE nombre = 'María González'
    
    UNION ALL
    
    SELECT e.id, e.nombre, e.puesto, e.jefe_id, s.nivel + 1
    FROM empleados e
    INNER JOIN subordinados_tecnologia s ON e.jefe_id = s.id
)
SELECT 
    nombre,
    puesto,
    nivel,
    REPEAT('  ', nivel) || nombre as arbol_jerarquico
FROM subordinados_tecnologia
ORDER BY nivel, nombre;
