-- 1. Tabla para el Ejercicio de Arrays (Productos y Etiquetas)
CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    etiquetas TEXT[] 
);

-- 2. Tabla para el Ejercicio de CTE Recursiva (Empleados y Jefes)
CREATE TABLE empleados (
    id SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    jefe_id INT REFERENCES empleados(id) 
);
