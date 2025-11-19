CREATE TABLE empleados (
    id SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    jefe_id INT REFERENCES empleados(id)
);


INSERT INTO empleados (nombre, jefe_id) VALUES
('Laura', NULL),        -- Laura es la jefa principal
('Carlos', 1),          -- Carlos reporta a Laura
('María', 1),           -- María también reporta a Laura
('Pedro', 2),           -- Pedro reporta a Carlos
('Sofía', 2),           -- Sofía reporta a Carlos
('Andrés', 3);          -- Andrés reporta a María



WITH RECURSIVE jerarquia AS (
    SELECT id, nombre, jefe_id
    FROM empleados
    WHERE nombre = 'Laura'      
    UNION ALL
    SELECT e.id, e.nombre, e.jefe_id
    FROM empleados e
    INNER JOIN jerarquia j ON e.jefe_id = j.id
)
SELECT * FROM jerarquia;


WITH RECURSIVE jerarquia_carlos AS (
    SELECT id, nombre, jefe_id
    FROM empleados
    WHERE nombre = 'Carlos'
    UNION ALL
    SELECT e.id, e.nombre, e.jefe_id
    FROM empleados e
    INNER JOIN jerarquia_carlos j ON e.jefe_id = j.id
)
SELECT * FROM jerarquia_carlos;
