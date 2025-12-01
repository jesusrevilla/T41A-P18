import psycopg2
import pytest
from typing import List, Tuple

# --- CONFIGURACIÓN DE LA BASE DE DATOS  ---
DB_CONFIG = {
    "dbname": "test_db",
    "user": "postgres",
    "password": "postgres",
    "host": "localhost",
    "port": 5432
}

# --- FUNCIONES DE UTILIDAD ---
def run_query(query: str) -> List[Tuple]:
    """Ejecuta una consulta SQL y retorna los resultados (fetchall)."""
    with psycopg2.connect(**DB_CONFIG) as conn:
        with conn.cursor() as cur:
            cur.execute(query)
            try:
                
                return cur.fetchall()
            except psycopg2.ProgrammingError:
                return []

# --- PRUEBAS PARA 01_array_products.sql (Arrays) ---

def test_array_query_by_tag():
    """Verifica que la consulta de productos por la etiqueta 'tecnología' sea correcta."""

    query = """
    SELECT COUNT(*) 
    FROM productos_array 
    WHERE 'tecnología' = ANY(etiquetas);
    """
    result = run_query(query)
    
    assert result[0][0] == 2, f"Se esperaban 2 productos con 'tecnología', se encontraron {result[0][0]}."


# --- PRUEBAS PARA 02_cte_empleados_jerarquia.sql (CTE Recursiva - Jerarquía) ---


def test_empleados_subordinados_count():
    """Verifica que la CTE recursiva encuentre 3 subordinados para el Jefe (ID 2)."""
    # Valida la recursividad para estructuras jerárquicas.
    query = """
    WITH RECURSIVE subordinados_red AS (
        -- Base: El gerente (ID 2)
        SELECT id, nombre, jefe_id, 0 AS nivel FROM empleados WHERE id = 2
        UNION ALL
        -- Recursión: Subordinados
        SELECT e.id, e.nombre, e.jefe_id, r.nivel + 1
        FROM empleados e
        INNER JOIN subordinados_red r ON e.jefe_id = r.id
    )
    SELECT COUNT(*) FROM subordinados_red WHERE nivel > 0;
    """
    result = run_query(query)
    # El ID 2 (Gerente A) tiene 3 subordinados directos/indirectos en el setup de datos
    assert result[0][0] == 3, f"Se esperaban 3 subordinados para el ID 2, se encontraron {result[0][0]}."


# --- PRUEBAS PARA 03_array_city_connections.sql & 04_cte_reachable_cities.sql (Grafo) ---


def test_ciudades_alcanzables_count():
    """Verifica el número total de ciudades ÚNICAS alcanzables desde 'Atenas'."""
    # Valida la lógica de la CTE recursiva para un Grafo (alcanzabilidad).
    query = """
    WITH RECURSIVE ciudades_alcanzables AS (
        SELECT nombre AS ciudad_actual, ARRAY[nombre] AS ruta_seguida FROM ciudades WHERE nombre = 'Atenas'
        UNION ALL
        SELECT c.conexion, r.ruta_seguida || c.conexion
        FROM ciudades_alcanzables r
        JOIN ciudades o ON r.ciudad_actual = o.nombre
        CROSS JOIN unnest(o.conexiones) AS c(conexion)
        WHERE NOT (c.conexion = ANY(r.ruta_seguida))
    )
    -- Contamos las ciudades únicas (incluyendo 'Atenas')
    SELECT COUNT(DISTINCT ciudad_actual) FROM ciudades_alcanzables;
    """
    result = run_query(query)
    # En el setup de datos, las 7 ciudades son alcanzables desde Atenas (7 nodos en el grafo)
    assert result[0][0] == 7, f"Se esperaban 7 ciudades únicas alcanzables, se encontraron {result[0][0]}."

def test_ciudades_max_distance():
    """Verifica la máxima distancia (saltos) para alcanzar todas las ciudades."""
    # Valida que la recursión explore la profundidad máxima del grafo.
    query = """
    WITH RECURSIVE ciudades_alcanzables AS (
        SELECT nombre AS ciudad_actual, 0 AS distancia, ARRAY[nombre] AS ruta_seguida FROM ciudades WHERE nombre = 'Atenas'
        UNION ALL
        SELECT c.conexion, r.distancia + 1, r.ruta_seguida || c.conexion
        FROM ciudades_alcanzables r
        JOIN ciudades o ON r.ciudad_actual = o.nombre
        CROSS JOIN unnest(o.conexiones) AS c(conexion)
        WHERE NOT (c.conexion = ANY(r.ruta_seguida))
    )
    -- La distancia máxima para conectar todos los nodos en ese grafo es 6
    SELECT MAX(distancia) FROM ciudades_alcanzables;
    """
    result = run_query(query)
    # Se espera una distancia máxima de 6 (A->...->G)
    assert result[0][0] == 6, f"Se esperaba una distancia máxima de 6, se encontró {result[0][0]}."
