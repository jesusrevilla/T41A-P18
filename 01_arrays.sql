DROP TABLE IF EXISTS productos CASCADE;
CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    nombre TEXT,
    etiquetas TEXT[]
);

INSERT INTO productos (nombre, etiquetas) VALUES
('Laptop', ARRAY['tecnología', 'portátil', 'oficina']),
('Teléfono', ARRAY['tecnología', 'móvil', 'comunicación']),
('Refrigerador', ARRAY['hogar', 'electrodoméstico']);

SELECT nombre
FROM productos
WHERE 'tecnología' = ANY(etiquetas);
