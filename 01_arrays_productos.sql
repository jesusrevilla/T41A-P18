CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    etiquetas TEXT[]
);


INSERT INTO productos (nombre, etiquetas) VALUES
('Laptop', ARRAY['tecnología', 'portátil', 'oficina']),
('Silla ergonómica', ARRAY['muebles', 'oficina']),
('Smartphone', ARRAY['tecnología', 'móvil', 'comunicación']);


SELECT id, nombre, etiquetas
FROM productos
WHERE 'tecnología' = ANY(etiquetas);


SELECT nombre, etiquetas[1] AS primera_etiqueta
FROM productos;
