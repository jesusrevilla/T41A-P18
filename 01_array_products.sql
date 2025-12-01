-- 1_ Crear una tabla productos con un array de etiquetas (TEXT[])
DROP TABLE IF EXISTS productos_array CASCADE;

CREATE TABLE productos_array (
    id SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    precio NUMERIC,
    etiquetas TEXT[] -- Array unidimensional para las etiquetas
);

-- 2_ Insertar al menos 3 productos con diferentes etiquetas
INSERT INTO productos_array (nombre, precio, etiquetas)
VALUES 
    ('Smartphone X', 799.00, ARRAY['electrónica', 'tecnología', 'móvil']),
    ('Libro de Ciencia', 25.50, ARRAY['educación', 'ciencia', 'papel']),
    ('Teclado Mecánico', 120.00, ARRAY['tecnología', 'gaming', 'periférico']),
    ('Mesa de Comedor', 450.00, ARRAY['hogar', 'mueble', 'madera']);

-- 3. Consultar todos los productos que contengan la etiqueta 'tecnología'
-- Usamos el operador ANY para verificar si el array contiene el valor.
SELECT 
    nombre, 
    etiquetas
FROM 
    productos_array
WHERE 
    'tecnología' = ANY(etiquetas);
