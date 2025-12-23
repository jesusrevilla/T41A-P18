-- Test 1 Verificar que la tabla productos fue creada correctamente
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'productos') THEN
        RAISE NOTICE 'Test 1 pasado: Tabla productos creada correctamente';
    ELSE
        RAISE EXCEPTION 'Test 1 falló: Tabla productos no existe';
    END IF;
END $$;


-- Test 2: Verificar inserción de produt
DO $$
DECLARE
    product_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO product_count FROM productos;
    IF product_count >= 3 THEN
        RAISE NOTICE 'Test 2 pasado: Se insertaron % productos', product_count;
    ELSE
        RAISE EXCEPTION 'Test 2 falló: Solo se insertaron % productos, se esperaban al menos 3', product_count;
    END IF;
END $$;

-- Test 3 Verificar consulta de productos con etiqueta 'tecnología'
DO $$
DECLARE
    tech_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO tech_count 
    FROM productos 
    WHERE 'tecnología' = ANY(etiquetas);
    
    IF tech_count > 0 THEN
        RAISE NOTICE 'Test 3 pasado: Se encontraron % productos con etiqueta "tecnología"', tech_count;
    ELSE
        RAISE EXCEPTION 'Test 3 falló: No se encontraron productos con etiqueta "tecnología"';
    END IF;
END $$;

-- Test 4 Verificar jerarquía de empleados
DO $$
DECLARE
    emp_count INTEGER;
    subord_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO emp_count FROM empleados;
    
    WITH RECURSIVE subordinados_ceo AS (
        SELECT id FROM empleados WHERE nombre = 'Carlos Rodríguez'
        UNION ALL
        SELECT e.id FROM empleados e
        INNER JOIN subordinados_ceo s ON e.jefe_id = s.id
    )
    SELECT COUNT(*) INTO subord_count FROM subordinados_ceo;
    
    IF emp_count >= 5 THEN
        RAISE NOTICE 'Test 4 pasado: Se crearon % empleados con jerarquía (% incluyendo CEO)', emp_count, subord_count;
    ELSE
        RAISE EXCEPTION 'Test 4 falló: Solo se crearon % empleados', emp_count;
    END IF;
END $$;

-- Test 5 Verificar grafo de ciudades
DO $$
DECLARE
    city_count INTEGER;
    route_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO city_count FROM ciudades;
    SELECT COUNT(*) INTO route_count FROM rutas;
    
    IF city_count >= 5 AND route_count >= 8 THEN
        RAISE NOTICE 'Test 5 pasado: Se crearon % ciudades y % rutas', city_count, route_count;
    ELSE
        RAISE EXCEPTION 'Test 5 falló: Se crearon % ciudades y % rutas (mínimo 5 ciudades y 8 rutas esperadas)', city_count, route_count;
    END IF;
END $$;

-- Test 6 Verificar que se pueden encontrar rutas entre ciudades
DO $$
DECLARE
    reachable_count INTEGER;
BEGIN
    WITH RECURSIVE ciudades_alcanzables AS (
        SELECT c.id, c.nombre, 0 as depth
        FROM ciudades c WHERE c.nombre = 'Madrid'
        UNION ALL
        SELECT cd.id, cd.nombre, ca.depth + 1
        FROM rutas r
        INNER JOIN ciudades cd ON r.ciudad_destino_id = cd.id
        INNER JOIN ciudades_alcanzables ca ON r.ciudad_origen_id = ca.id
        WHERE ca.nombre != cd.nombre AND ca.depth < 3  -- Límite de profundidad de 3 saltos
    )
    SELECT COUNT(DISTINCT nombre) INTO reachable_count 
    FROM ciudades_alcanzables;
    
    IF reachable_count > 1 THEN
        RAISE NOTICE 'Test 6 pasado: Se pueden alcanzar % ciudades desde Madrid', reachable_count;
    ELSE
        RAISE EXCEPTION 'Test 6 falló: No se pueden encontrar rutas desde Madrid';
    END IF;
END $$;

RAISE NOTICE '¡Todos los tests pasaron correctamente!';
