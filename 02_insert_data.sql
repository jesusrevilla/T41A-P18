--Insertar al menos 3 productos con diferentes etiquetas.
INSERT INTO productos (nombre, etiqueta) VALUES
('Laptop Dell', ARRAY['tecnología', 'computo']),
('Silla Gamer', ARRAY['muebles', 'gaming']),
('Smartphone Samsung', ARRAY['tecnología', 'movil']),
('Cafetera Oster', ARRAY['hogar', 'electrodomésticos']);

--Insertar una jerarquía de empleados.
INSERT INTO empleados (nombre, jefe_id) VALUES
('Ana', NULL),
('Luis', 1),
('Marta', 2),
('Pedro', 2),
('Coral', 1),
('Lupe', 5);

INSERT INTO ciudades (ciudad, conexiones) VALUES
('A', ARRAY['B','C']),
('B', ARRAY['A','D']),
('C', ARRAY['A','D','E']),
('D', ARRAY['B','C']),
('E', ARRAY['C']);
