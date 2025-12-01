-- Tabla con array de intereses
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nombre TEXT,
    intereses TEXT[]
);

-- Tabla productos con array de etiquetas
CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    nombre TEXT,
    etiquetas TEXT[]
);

-- Tabla para grafo de amigos
CREATE TABLE amigos (
    id SERIAL PRIMARY KEY,
    nombre TEXT,
    amigo_id INT
);

-- Tabla para jerarquía de empleados
CREATE TABLE empleados (
    id SERIAL PRIMARY KEY,
    nombre TEXT,
    jefe_id INT
);

-- Tabla para ciudades conectadas por rutas
CREATE TABLE ciudades (
    id SERIAL PRIMARY KEY,
    nombre TEXT,
    conexiones TEXT[]
);
