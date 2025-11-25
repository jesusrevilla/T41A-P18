INSERT INTO productos (nombre, etiquetas) VALUES
('Laptop Gamer', ARRAY['tecnología', 'computo', 'gaming']),
('Smartphone', ARRAY['tecnología', 'moviles']),
('Silla ergonómica', ARRAY['muebles', 'oficina']);

INSERT INTO empleados (nombre, jefe_id) VALUES
('Ana', NULL),     -- Jefa principal
('Luis', 1),       -- Reporta a Ana
('Marta', 2),      -- Reporta a Luis
('Pedro', 2),      -- Reporta a Luis
('Sofía', 3);      -- Reporta a Marta

INSERT INTO ciudades (nombre, conexiones) VALUES
('Ciudad A', ARRAY[2, 3]),  -- A → B, C
('Ciudad B', ARRAY[4]),     -- B → D
('Ciudad C', ARRAY[4, 5]),  -- C → D, E
('Ciudad D', ARRAY[5]),     -- D → E
('Ciudad E', ARRAY[]::INT[]); -- E → (ninguna)
