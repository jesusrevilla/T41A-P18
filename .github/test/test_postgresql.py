import psycopg2
import pytest
from pathlib import Path

DB_CONFIG = {
    "host": "localhost",
    "dbname": "postgres",
    "user": "postgres",
    "password": "postgres",
}

@pytest.fixture(scope="module")
def conn():
    connection = psycopg2.connect(**DB_CONFIG)
    yield connection
    connection.close()

@pytest.fixture
def cursor(conn):
    cur = conn.cursor()
    yield cur
    conn.rollback()
    cur.close()

def run_sql_file(cursor, filename):
    """Ejecuta un archivo SQL completo"""
    sql_path = Path(__file__).parent.parent / filename
    with open(sql_path, "r", encoding="utf-8") as f:
        cursor.execute(f.read())

def test_arrays_productos(cursor):
    run_sql_file(cursor, "arrays_productos.sql")
    cursor.execute("SELECT COUNT(*) FROM productos_array;")
    count = cursor.fetchone()[0]
    assert count >= 3, "No se insertaron al menos 3 productos"

    cursor.execute("""
        SELECT nombre FROM productos_array
        WHERE 'tecnología' = ANY(etiquetas);
    """)
    resultados = {r[0] for r in cursor.fetchall()}
    assert {"Laptop", "Smartwatch"}.issubset(resultados), \
        "La consulta de productos con etiqueta 'tecnología' no devolvió los esperados"

def test_cte_empleados(cursor):
    run_sql_file(cursor, "cte_empleados.sql")
    cursor.execute("SELECT COUNT(*) FROM empleados;")
    total = cursor.fetchone()[0]
    assert total >= 5, "La tabla empleados no tiene suficientes registros"

    cursor.execute("""
        WITH RECURSIVE jerarquia AS (
          SELECT id, nombre, jefe_id FROM empleados WHERE nombre = 'Ana'
          UNION ALL
          SELECT e.id, e.nombre, e.jefe_id
          FROM empleados e
          INNER JOIN jerarquia j ON e.jefe_id = j.id
        )
        SELECT nombre FROM jerarquia;
    """)
    nombres = {r[0] for r in cursor.fetchall()}
    assert {"Ana", "Luis", "Marta", "Pedro", "Sofía"}.issubset(nombres), \
        "La CTE recursiva no devolvió la jerarquía completa"

