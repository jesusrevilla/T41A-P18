CREATE TABLE IF NOT EXISTS empleados(
    id SERIAL PRIMARY KEY,
    nombre TEXT,
    jefe_id INT
);

CREATE TABLE IF NOT EXISTS productos(
    id SERIAL PRIMARY KEY,
    nombre TEXT,
    etiquetas TEXT[]
);

