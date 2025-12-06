CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    nombre TEXT,
    etiquetas TEXT[]
);

CREATE TABLE empleados (
    id SERIAL PRIMARY KEY,
    nombre TEXT,
    jefe_id INT
);

CREATE TABLE rutas (
    id SERIAL PRIMARY KEY,
    ciudad TEXT,
    destino TEXT
);

CREATE TABLE ciudades (
    nombre TEXT PRIMARY KEY,
    conexiones TEXT[]
);
