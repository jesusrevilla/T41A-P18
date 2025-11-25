import psycopg2
import pytest

DB_CONFIG = {
    "dbname": "test_db",
    "user": "postgres",
    "password": "postgres",
    "host": "localhost",
    "port": 5432
}

def run_query(q):
    with psycopg2.connect(**DB_CONFIG) as conn:
        with conn.cursor() as cur:
            cur.execute(q)
            try:
                return cur.fetchall()
            except:
                return None

# ====================================================
#               TEST ARRAYS
# ====================================================

def test_productos_tecnologia():
    result = run_query("""
        SELECT nombre FROM productos
        WHERE 'tecnología' = ANY(etiquetas);
    """)
    nombres = [r[0] for r in result]
    assert "Laptop Gamer" in nombres
    assert "Smartphone" in nombres
    assert len(result) == 2

# ====================================================
#              TEST CTE RECURSIVA EMPLEADOS
# ====================================================

def test_subordinados_de_luis():
    result = run_query("""
        WITH RECURSIVE sub AS (
            SELECT id, nombre, jefe_id
            FROM empleados
            WHERE nombre = 'Luis'
            UNION ALL
            SELECT e.id, e.nombre, e.jefe_id
            FROM empleados e
            INNER JOIN sub s ON e.jefe_id = s.id
        )
        SELECT nombre FROM sub;
    """)

    nombres = [r[0] for r in result]

    assert "Luis" in nombres
    assert "Marta" in nombres
    assert "Pedro" in nombres
    assert "Sofía" in nombres
    assert len(nombres) == 4

# ====================================================
#              TEST GRAFO DE CIUDADES
# ====================================================

def test_ciudades_desde_A():
    result = run_query("""
        WITH RECURSIVE rutas AS (
            SELECT id, nombre, conexiones
            FROM ciudades
            WHERE nombre = 'Ciudad A'

            UNION ALL

            SELECT c.id, c.nombre, c.conexiones
            FROM ciudades c
            JOIN rutas r ON c.id = ANY(r.conexiones)
        )
        SELECT DISTINCT nombre FROM rutas;
    """)
    nombres = [r[0] for r in result]

    assert "Ciudad A" in nombres
    assert "Ciudad B" in nombres
    assert "Ciudad C" in nombres
    assert "Ciudad D" in nombres
    assert "Ciudad E" in nombres
    assert len(nombres) == 5
