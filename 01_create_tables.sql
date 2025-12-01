DROP TABLE IF EXISTS ciudades_grafo;
DROP TABLE IF EXISTS empleados;
DROP TABLE IF EXISTS productos;


CREATE TABLE productos (
    id        SERIAL PRIMARY KEY,
    nombre    TEXT NOT NULL,
    etiquetas TEXT[] NOT NULL
);


CREATE TABLE empleados (
    id      SERIAL PRIMARY KEY,
    nombre  TEXT NOT NULL,
    jefe_id INT REFERENCES empleados(id)
);

CREATE TABLE ciudades_grafo (
    nombre      TEXT PRIMARY KEY,
    conexiones  TEXT[] NOT NULL
);
