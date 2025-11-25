DROP TABLE IF EXISTS productos CASCADE;

CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    etiquetas TEXT[]
);
DROP TABLE IF EXISTS empleados CASCADE;

CREATE TABLE empleados (
    id SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    jefe_id INT REFERENCES empleados(id)
);
DROP TABLE IF EXISTS ciudades CASCADE;

CREATE TABLE ciudades (
    id SERIAL PRIMARY KEY,
    nombre TEXT UNIQUE NOT NULL,
    conexiones INT[]   -- IDs de ciudades conectadas
);
