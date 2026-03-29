DROP TABLE IF EXISTS productos CASCADE;
DROP TABLE IF EXISTS empleados CASCADE;
DROP TABLE IF EXISTS ciudades CASCADE;

CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    nombre TEXT,
    etiquetas TEXT[]
);

CREATE TABLE empleados  (
    id SERIAL PRIMARY KEY,
    nombre TEXT,
    jefe_id INT
);

CREATE TABLE ciudades (
    id SERIAL PRIMARY KEY,
    nombre TEXT,
    alrededores TEXT[]
);
