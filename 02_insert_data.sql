-- 1. Datos para 'productos' (Ejercicio Arrays)
INSERT INTO productos (nombre, etiquetas) VALUES
('Laptop', ARRAY['tecnología', 'computadora', 'oficina']),
('Teclado', ARRAY['tecnología', 'accesorio', 'periférico']),
('Camisa de Algodón', ARRAY['ropa', 'moda']),
('Monitor Curvo', ARRAY['tecnología', 'oficina', 'monitor']);

-- 2. Datos para 'empleados' (Ejercicio CTE Recursiva)
INSERT INTO empleados (id, nombre, jefe_id) VALUES (1, 'Director General', NULL);

-- (Managers que reportan al Director)
INSERT INTO empleados (id, nombre, jefe_id) VALUES (2, 'Gerente de TI', 1);
INSERT INTO empleados (id, nombre, jefe_id) VALUES (3, 'Gerente de Ventas', 1);

-- (Empleados que reportan a los managers)
INSERT INTO empleados (id, nombre, jefe_id) VALUES (4, 'Desarrollador Sr', 2);
INSERT INTO empleados (id, nombre, jefe_id) VALUES (5, 'Desarrollador Jr', 2);
INSERT INTO empleados (id, nombre, jefe_id) VALUES (6, 'Vendedor Sr', 3);
