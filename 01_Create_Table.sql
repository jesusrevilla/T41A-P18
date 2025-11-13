DROP TABLE IF EXISTS empleados;

CREATE TABLE empleados (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    jefe_id INTEGER,
    CONSTRAINT fk_jefe
        FOREIGN KEY (jefe_id)
        REFERENCES empleados(id)
        ON DELETE SET NULL
);
