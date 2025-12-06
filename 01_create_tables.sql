CREATE TABLE productos(
  id SERIAL PRIMARY KEY,
  nombre TEXT,
  etiquetas TEXT[]
);

--CTE
CREATE TABLE empleados (
    id SERIAL PRIMARY KEY,
    nombre TEXT,
    jefe_id INT
);

--Ejercicios Recomendados
CREATE TABLE ciudades (
    id SERIAL PRIMARY KEY,
    nombre TEXT,
    ruta_id INT[]
);
