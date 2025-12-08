-- Crear tabla con array de etiquetas
DROP TABLE IF EXISTS productos_array CASCADE;

CREATE TABLE productos_array (
  id SERIAL PRIMARY KEY,
  nombre TEXT,
  etiquetas TEXT[]
);

-- Insertar productos con diferentes etiquetas
INSERT INTO productos_array (nombre, etiquetas)
VALUES 
  ('Laptop', ARRAY['tecnología', 'portátil', 'oficina']),
  ('Smartwatch', ARRAY['tecnología', 'wearable', 'salud']),
  ('Libro', ARRAY['educación', 'papelería', 'lectura']);

-- Consultar productos que contengan la etiqueta 'tecnología'
SELECT nombre
FROM productos_array
WHERE 'tecnología' = ANY(etiquetas);
