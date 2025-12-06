CREATE TABLE productos(
  id SERIAL PRIMARY KEY,
  nombre TEXT,
  etiquetas TEXT[]
);

CREATE TABLE empleados(
  id SERIAL PRIMARY KEY,
  nombre TEXT,
  jefe_id INT
);

CREATE TABLE rutas (
    ciudad_origen TEXT PRIMARY KEY,
    ciudades_destino TEXT[] NOT NULL
);
