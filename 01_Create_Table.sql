CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    etiquetas TEXT[]
);

CREATE TABLE IF NOT EXISTS usuarios (
    id SERIAL PRIMARY KEY,
    data JSONB NOT NULL
);


INSERT INTO productos (nombre, etiquetas) VALUES
('Laptop', ARRAY['tecnología', 'portátil', 'oficina']),
('Silla ergonómica', ARRAY['muebles', 'oficina']),
('Smartphone', ARRAY['tecnología', 'móvil', 'comunicación']);

INSERT INTO usuarios (data) VALUES
    ('{"nombre": "Ana", "activo": true, "edad": 30}'),
    ('{"nombre": "Juan", "activo": false, "edad": 25}');

SELECT id, nombre, etiquetas
FROM productos
WHERE 'tecnología' = ANY(etiquetas);


SELECT nombre, etiquetas[1] AS primera_etiqueta
FROM productos;
