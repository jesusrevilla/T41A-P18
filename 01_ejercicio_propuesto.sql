CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    nombre TEXT,
    etiquetas TEXT[]
);

INSERT INTO productos (nombre, etiquetas) VALUES 
    ('Laptop Gamer', ARRAY['tecnología', 'computación', 'gaming']),
    ('Silla', ARRAY['muebles', 'oficina', 'hogar']),
    ('Smart Watch', ARRAY['tecnología', 'accesorios', 'fitness']);
    
SELECT * FROM productos WHERE 'tecnología' = ANY(etiquetas);


