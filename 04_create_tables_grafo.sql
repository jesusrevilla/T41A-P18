-- 1 - Crear una tabla empleados con columnas id, nombre, jefe_id.
CREATE TABLE empleados(
  id SERIAL PRIMARY KEY,
  nombre TEXT,
  jefe_id INT
);
