-- 1. Crear tabla productos con array de etiquetas
CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    precio DECIMAL(10,2),
    etiquetas TEXT[]
);

-- 2. Insertar al menos 3 productos con diferentes etiquetas
INSERT INTO productos (nombre, precio, etiquetas) VALUES
('Laptop Gaming', 1200.00, ARRAY['tecnología', 'computación', 'gaming']),
('Smartphone', 800.00, ARRAY['tecnología', 'comunicación', 'móvil']),
('Libro PostgreSQL', 45.00, ARRAY['educación', 'programación', 'base de datos']),
('Auriculares Bluetooth', 150.00, ARRAY['tecnología', 'audio', 'inalámbrico']),
('Mochila', 75.00, ARRAY['accesorio', 'viaje']);

-- 3. Consultar todos los productos que contengan la etiqueta 'tecnología'
SELECT id, nombre, precio, etiquetas
FROM productos
WHERE 'tecnología' = ANY(etiquetas);

SELECT nombre, etiquetas
FROM productos
WHERE etiquetas @> ARRAY['tecnología', 'audio']::text[];

SELECT nombre, array_length(etiquetas, 1) as num_etiquetas, etiquetas
FROM productos
ORDER BY num_etiquetas DESC;
