CREATE TABLE empleados (
    id SERIAL PRIMARY KEY,
    nombre TEXT,
    jefe_id INT
);

INSERT INTO empleados (nombre, jefe_id) VALUES
('Maria', NULL),
('Jose', 1),
('Juan', 2),
('Brandon', 2),
('Rafael', 2);

CREATE OR REPLACE FUNCTION obtener_subordinados_de(
    p_id_jefe INT
)
RETURNS TABLE(
    id_jefe INT,
    nombre_jefe TEXT,
    id_empleado INT,
    nombre_empleado TEXT
) AS $$
BEGIN
    RETURN QUERY
    WITH RECURSIVE subordinados_de AS (
        SELECT id, nombre, jefe_id 
        FROM empleados 
        WHERE jefe_id = p_id_jefe
        UNION ALL
        SELECT e.id, e.nombre, e.jefe_id
        FROM empleados e
        INNER JOIN subordinados_de sd ON e.jefe_id = sd.id
    )
    SELECT
        j.id AS id_jefe,
        j.nombre AS nombre_jefe,
        sd.id AS id_empleado,
        sd.nombre AS nombre_empleado
    FROM
        subordinados_de sd
    LEFT JOIN empleados j ON sd.jefe_id = j.id;
END;
$$ LANGUAGE plpgsql;
