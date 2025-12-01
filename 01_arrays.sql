-- Crear tabla con ARRAY de etiquetas
DROP TABLE IF EXISTS productos CASCADE;
CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    nombre TEXT,
    etiquetas TEXT[]
);

-- Insertar productos con diferentes etiquetas
INSERT INTO productos (nombre, etiquetas) VALUES
('Laptop', ARRAY['tecnología', 'portátil', 'oficina']),
('Teléfono', ARRAY['tecnología', 'móvil', 'comunicación']),
('Refrigerador', ARRAY['hogar', 'electrodoméstico']);

-- Consultar productos con etiqueta 'tecnología'
SELECT nombre
FROM productos
WHERE 'tecnología' = ANY(etiquetas);
