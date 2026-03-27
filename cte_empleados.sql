DROP TABLE IF EXISTS empleados CASCADE;

CREATE TABLE empleados (
  id SERIAL PRIMARY KEY,
  nombre TEXT,
  jefe_id INT
);

-- Insertar jerarquía
INSERT INTO empleados (nombre, jefe_id) VALUES
('Ana', NULL),       -- CEO
('Luis', 1),         -- Subordinado de Ana
('Marta', 2),        -- Subordinado de Luis
('Pedro', 2),        -- Subordinado de Luis
('Sofía', 3);        -- Subordinado de Marta

-- CTE recursiva para listar subordinados de Ana
WITH RECURSIVE jerarquia AS (
  SELECT id, nombre, jefe_id FROM empleados WHERE nombre = 'Ana'
  UNION ALL
  SELECT e.id, e.nombre, e.jefe_id
  FROM empleados e
  INNER JOIN jerarquia j ON e.jefe_id = j.id
)
SELECT * FROM jerarquia;
