CREATE EXTENSION IF NOT EXISTS hstore;

CREATE TABLE productos(
  id SERIAL PRIMARY KEY,
  nombre TEXT,
  etiqueta TEXT[]
);

INSERT INTO productos (nombre, etiqueta)
VALUES ('Teclado Gamer', ARRAY['Tecnología', 'Perifericos', 'Gamer']),
('Refrigerador', ARRAY['Tecnología', 'Hogar', 'Linea Blanca']),
('Camisa de vestir blanca', ARRAY['Ropa', 'Moda', 'Caballero']);

SELECT * FROM productos WHERE 'Tecnología' = ANY(etiqueta);
