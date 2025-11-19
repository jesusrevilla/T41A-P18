-- --- Ejercicio 1: Arrays (Productos) ---
INSERT INTO productos (nombre, etiquetas) VALUES
('Laptop Pro', ARRAY['tecnología', 'electrónica', 'computadora']),
('Teclado Mecánico RGB', ARRAY['tecnología', 'periférico']),
('Monitor 4K UHD', ARRAY['tecnología', 'monitor', 'electrónica']),
('Libro de Cocina', ARRAY['libros', 'cocina', 'hogar']),
('Sartén de Hierro', ARRAY['cocina', 'hogar']);

-- --- Ejercicio 2: CTE Recursiva (Empleados) ---
INSERT INTO empleados (id, nombre, jefe_id) VALUES
(1, 'Carlos (CEO)', NULL),
(2, 'Ana (Gerente)', 1),
(3, 'David (Gerente)', 1),
(4, 'Maria (Desarrollador)', 2),
(5, 'Pedro (Desarrollador)', 3),
(6, 'Luis (Pasante)', 4);
