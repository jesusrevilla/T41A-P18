WITH RECURSIVE subordinates AS (
    -- 1) Nodo raíz: el jefe solicitado
    SELECT 
        e.id,
        e.nombre,
        e.jefe_id,
        0 AS nivel
    FROM empleados e
    WHERE e.id = 3

    UNION ALL

    -- 2) Recursividad: buscar subordinados
    SELECT 
        emp.id,
        emp.nombre,
        emp.jefe_id,
        s.nivel + 1 AS nivel
    FROM empleados emp
    INNER JOIN subordinates s ON emp.jefe_id = s.id
)

