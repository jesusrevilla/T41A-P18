
-- Tabla USUARIOS (JSONB)
CREATE TABLE IF NOT EXISTS usuarios (
    id SERIAL PRIMARY KEY,
    data JSONB NOT NULL
);

-- Tabla PRODUCTOS (etiquetas tipo TEXT[])
CREATE TABLE IF NOT EXISTS productos (
    id SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    etiquetas TEXT[]
);

-- Tabla EMPLEADOS (jerarquía recursiva)
CREATE TABLE IF NOT EXISTS empleados (
    id SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    jefe_id INT REFERENCES empleados(id)
);

