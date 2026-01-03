import psycopg2
import pytest

DB = {
    "dbname": "test_db",
    "user": "postgres",
    "password": "postgres",
    "host": "localhost",
    "port": 5432
}

@pytest.fixture(scope="module")
def conn():
    c = psycopg2.connect(**DB)
    yield c
    c.close()

def test_productos_tecnologia(conn):
    with conn.cursor() as cur:
        cur.execute("SELECT COUNT(*) FROM productos WHERE 'tecnología' = ANY(etiquetas);")
        count = cur.fetchone()[0]
        assert count == 2  # Laptop y Smartphone

def test_jerarquia_ana(conn):
    with conn.cursor() as cur:
        cur.execute("""
            WITH RECURSIVE jerarquia AS (
                SELECT id, nombre, jefe_id FROM empleados WHERE nombre = 'Ana'
                UNION ALL
                SELECT e.id, e.nombre, e.jefe_id
                FROM empleados e
                INNER JOIN jerarquia j ON e.jefe_id = j.id
            )
            SELECT COUNT(*) FROM jerarquia;
        """)
        count = cur.fetchone()[0]
        assert count == 5 
