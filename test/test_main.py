import pytest
import psycopg2
import os

@pytest.fixture(scope="module")
def db_conn():
    try:
        conn = psycopg2.connect(
            dbname="test_db",
            user="postgres",
            password="postgres",
            host="localhost",
            port="5432"
        )
        yield conn
        conn.close()
    except psycopg2.OperationalError as e:
        pytest.fail(f"No se pudo conectar a la base de datos de PostgreSQL: {e}")

def test_producto_tecnologia_conteo(db_conn):
    with db_conn.cursor() as cur:
        cur.execute("SELECT COUNT(*) FROM productos WHERE 'tecnología' = ANY(etiquetas);")
        count = cur.fetchone()[0]
        assert count == 3, "Deberían existir 3 productos de 'tecnología'"

def test_producto_tecnologia_nombres(db_conn):
    with db_conn.cursor() as cur:
        cur.execute("SELECT nombre FROM productos WHERE 'tecnología' = ANY(etiquetas);")
        results = cur.fetchall()
        nombres = [row[0] for row in results]
        
        assert "Laptop Pro" in nombres
        assert "Teclado Mecánico RGB" in nombres
        assert "Monitor 4K UHD" in nombres
        assert "Teléfono" not in nombres

def test_cte_subordinados_de_ana(db_conn):
    query_cte = """
    WITH RECURSIVE red_empleados AS (
        SELECT id, nombre, jefe_id 
        FROM empleados 
        WHERE jefe_id = 2

        UNION ALL

        SELECT e.id, e.nombre, e.jefe_id
        FROM empleados e
        INNER JOIN red_empleados r ON e.jefe_id = r.id
    )
    SELECT nombre FROM red_empleados ORDER BY nombre;
    """
    with db_conn.cursor() as cur:
        cur.execute(query_cte)
        results = cur.fetchall()
        nombres = [row[0] for row in results]
        
        assert len(nombres) == 2, "Ana debería tener 2 subordinados en total"
        assert "Maria (Desarrollador)" in nombres
        assert "Luis (Pasante)" in nombres
        assert "Pedro (Desarrollador)" not in nombres