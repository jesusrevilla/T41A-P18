INSERT INTO productos (nombre, etiquetas) VALUES
('Laptop X200', ARRAY['tecnología', 'computadoras', 'portátiles']),
('Cafetera Pro', ARRAY['hogar', 'cocina', 'electrodomésticos']),
('Smartphone Z10', ARRAY['tecnología', 'móviles', 'gadgets']);

INSERT INTO empleados (nombre, jefe_id) VALUES
('Carla', NULL),    
('Luis', 1),        
('Marta', 1),       
('Pedro', 2),       
('Ana', 2),         
('Jorge', 3),       
('Lucía', 3);       

INSERT INTO rutas (ciudad, destino) VALUES
('A', 'B'),
('A', 'C'),
('B', 'D'),
('C', 'D'),
('D', 'E'),
('E', 'F');

INSERT INTO ciudades VALUES
('A', ARRAY['B','C']),
('B', ARRAY['D']),
('C', ARRAY['D']),
('D', ARRAY['E']),
('E', ARRAY['F']);
