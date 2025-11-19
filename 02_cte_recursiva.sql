-- Crear tabla empleados con jerarquía (grafo)
DROP TABLE IF EXISTS empleados CASCADE;
CREATE TABLE empleados (
    id SERIAL PRIMARY KEY,
    nombre TEXT,
    jefe_id INT REFERENCES empleados(id)
);

-- Insertar jerarquía de empleados
INSERT INTO empleados (nombre, jefe_id) VALUES
('Director', NULL),
('Gerente', 1),
('Supervisor', 2),
('Analista', 3),
('Técnico', 3);

-- CTE recursiva para listar subordinados del Director
WITH RECURSIVE jerarquia AS (
    SELECT id, nombre, jefe_id FROM empleados WHERE nombre = 'Director'
    UNION ALL
    SELECT e.id, e.nombre, e.jefe_id
    FROM empleados e
    INNER JOIN jerarquia j ON e.jefe_id = j.id
)
SELECT * FROM jerarquia;
