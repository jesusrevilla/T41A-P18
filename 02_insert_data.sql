INSERT INTO productos (nombre, etiquetas) VALUES
('Laptop para desarrolladores', ARRAY['tecnología', 'cómputo', 'programación']),
('Silla ergonómica de oficina', ARRAY['oficina', 'ergonomía', 'muebles']),
('Celular gama media',           ARRAY['tecnología', 'smartphone', 'consumo']);

INSERT INTO empleados (nombre, jefe_id) VALUES
('Ana',   NULL),  -- id = 1
('Luis',  1),     -- id = 2
('Marta', 1),     -- id = 3
('Pedro', 2),     -- id = 4
('Sofía', 2),     -- id = 5
('Carlos',3);     -- id = 6

INSERT INTO ciudades_grafo (nombre, conexiones) VALUES
('Monterrey',       ARRAY['Saltillo', 'CDMX']),
('Saltillo',        ARRAY['Torreón']),
('Torreón',         ARRAY[]::TEXT[]),
('CDMX',            ARRAY['Guadalajara']),
('Guadalajara',     ARRAY['Puerto Vallarta']),
('Puerto Vallarta', ARRAY[]::TEXT[]);
