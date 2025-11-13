--- Ejercicio 1: Arrays (Productos) ---
CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    etiquetas TEXT[]
);

--- Ejercicio 2: CTE Recursiva (Empleados) ---
CREATE TABLE empleados (
    id SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    jefe_id INT,
    
    CONSTRAINT fk_jefe
        FOREIGN KEY(jefe_id) 
        REFERENCES empleados(id)
        ON DELETE SET NULL
);