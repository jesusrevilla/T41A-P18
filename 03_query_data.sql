SELECT nombre from productos WHERE etiquetas@>ARRAY['TECNOLOGIA'];


CREATE OR REPLACE VIEW subordinados_view AS
WITH RECURSIVE red_subordinados AS (
  SELECT id,nombre,jefe_id from empleados where id=1
  UNION ALL
  SELECT e.id,e.nombre,e.jefe_id
  FROM empleados e
  JOIN red_subordinados r ON e.jefe_id = r.id
)
SELECT * FROM red_subordinados;

CREATE OR REPLACE VIEW alcanzables_view AS
WITH RECURSIVE alcanzables AS (
    SELECT
        ciudad_origen AS origen_inicial,
        unnest(ciudades_destino) AS destino,
        ARRAY[ciudad_origen, unnest(ciudades_destino)] AS camino
    FROM
        rutas
    WHERE
        ciudad_origen = 'SLP'
    UNION ALL
    SELECT
        a.origen_inicial,
        r_new_dest.ciudad AS destino,
        a.camino || r_new_dest.ciudad
    FROM
        alcanzables a 
    JOIN
        rutas r ON r.ciudad_origen = a.destino 
    JOIN
        unnest(r.ciudades_destino) AS r_new_dest(ciudad) ON TRUE
    WHERE
        r_new_dest.ciudad <> ALL(a.camino) 
)
SELECT * FROM alcanzables
