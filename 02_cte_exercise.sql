CREATE TABLE empleados (
    id SERIAL PRIMARY KEY,
    nombre TEXT,
    jefe_id INT
);

INSERT INTO empleados (id, nombre, jefe_id) VALUES
(1, 'Ana (CEO)', NULL),
(2, 'Carlos (VP IT)', 1),
(3, 'Maria (VP Finanzas)', 1),
(4, 'Pedro (Manager IT)', 2),
(5, 'Laura (Manager Finanzas)', 3),
(6, 'Juan (Dev)', 4),
(7, 'Sofia (Contadora)', 5);

WITH RECURSIVE red_empleados AS (
    SELECT id, nombre, jefe_id FROM empleados WHERE nombre = 'Carlos (VP IT)'
    UNION ALL
    SELECT a.id, a.nombre, a.jefe_id
    FROM empleados a
    INNER JOIN red_empleados r ON a.jefe_id = r.id
)
SELECT * FROM red_empleados;
