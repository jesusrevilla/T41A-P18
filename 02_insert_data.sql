INSERT INTO productos (nombre, etiquetas) VALUES ('refrigerador', ARRAY['electrónicos', 'electrodoméstico', 'tecnología']), ('sillón', ARRAY['mueble', 'decoración', 'inmobiliario']), ('hamburguesa', ARRAY['comida', 'comida rápida', 'chatarra']);

--CTE
INSERT INTO empleados (nombre, jefe_id) VALUES
('David', NULL),
('Angel', 1),
('Jesús', 2),
('Carlos', 2),
('Cruz', 3);

--Ejercicios Recomendados
INSERT INTO ciudades (nombre, ruta_id) VALUES
('Amsterdam', ARRAY[3, 1]),
('Berlín', ARRAY[4, 3]),
('Frankfurt', ARRAY[1, 2]),
('Dortmund', ARRAY[4, 1]),
('Munich', ARRAY[1, 2]);
