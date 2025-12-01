-- Usuarios con intereses
INSERT INTO usuarios (nombre, intereses)
VALUES ('Ana', ARRAY['PostgreSQL', 'Grafos', 'NoSQL']);

-- Productos con etiquetas
INSERT INTO productos (nombre, etiquetas)
VALUES 
  ('Laptop', ARRAY['tecnología', 'portátil']),
  ('Teléfono', ARRAY['tecnología', 'móvil']),
  ('Mesa', ARRAY['hogar', 'madera']);

-- Amigos en grafo
INSERT INTO amigos (nombre, amigo_id)
VALUES 
  ('Ana', NULL),
  ('Luis', 1),
  ('Marta', 2),
  ('Pedro', 2);

-- Empleados en jerarquía
INSERT INTO empleados (nombre, jefe_id)
VALUES 
  ('Carlos', NULL),
  ('Lucía', 1),
  ('Andrés', 2),
  ('Sofía', 2);

-- Ciudades conectadas
INSERT INTO ciudades (nombre, conexiones)
VALUES 
  ('A', ARRAY['B', 'C']),
  ('B', ARRAY['D']),
  ('C', ARRAY['D', 'E']),
  ('D', ARRAY['F']),
  ('E', ARRAY[]::TEXT[]);
