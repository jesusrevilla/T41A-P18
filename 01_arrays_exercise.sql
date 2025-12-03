CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    nombre TEXT,
    etiquetas TEXT[]
);

INSERT INTO productos (nombre, etiquetas)
VALUES 
('Mouse', ARRAY['tecnología', 'periferico', 'inalambrico']),
('Monitor', ARRAY['tecnología', '1080p', 'IA']),
('Playera', ARRAY['niño', 'azul', 'descuento']);

SELECT * FROM productos WHERE 'tecnología' = ANY(etiquetas);
