--Crear una tabla productos con un array de etiquetas.
CREATE TABLE productos(
  id SERIAL PRIMARY KEY,
  nombre TEXT,
  etiqueta TEXT[]
);

--Crear una tabla empleados con columnas id, nombre, jefe_id.
CREATE TABLE empleados(
  id SERIAL PRIMARY KEY,
  nombre TEXT,
  jefe_id INT
);

--Crear una tabla con arrays que representen las conexiones directas de cada ciudad.
CREATE TABLE ciudades (
    ciudad TEXT PRIMARY KEY,
    conexiones TEXT[]
);
