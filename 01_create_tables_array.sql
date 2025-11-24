--Crear una tabla productos con un array de etiquetas
CREATE TABLE productos(
  id SERIAL PRIMARY KEY,
  nombre TEXT,
  etiquetas TEXT[]
);
