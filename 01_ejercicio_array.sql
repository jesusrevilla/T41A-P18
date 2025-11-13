CREATE TABLE productos(
  id SERIAL PRIMARY KEY,
  nombre TEXT,
  categoria TEXT[]
);

INSERT INTO productos (nombre, categoria)
VALUES ('Teclado Gamer', ARRAY['Tecnología', 'Perifericos', 'Gamer']),
('Refrigerador', ARRAY['Tecnología', 'Hogar', 'Linea Blanca']),
('Camisa de vestir blanca', ARRAY['Ropa', 'Moda', 'Caballero']);

SELECT * FROM productos WHERE 'Tecnología' = ANY(categoria);
