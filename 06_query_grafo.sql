-- 3 - Usar una CTE recursiva para listar todos los subordinados de un jefe específico.
WITH RECURSIVE subs_jefe AS(
  SELECT id, nombre, jefe_id FROM empleados WHERE jefe_id='2'
  UNION ALL
  SELECT e.id, e.nombre, e.jefe_id
  FROM empleados e
  INNER JOIN subs_jefe j ON e.jefe_id = j.id
)
SELECT * FROM subs_jefe;
