import psycopg2
import pytest
import psycopg2.extras

DB_CONFIG = {
    "dbname": "test_db",
    "user": "postgres",
    "password": "postgres",
    "host": "localhost",
    "port": 5432
}

@pytest.fixture(scope="function")
def db_conn():
    conn = None
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        yield conn 
    finally:
        if conn:
            conn.rollback() 
            conn.close()

def run_query(conn, query, params=None):
    with conn.cursor() as cur:
        cur.execute(query, params)
        try:
            return cur.fetchall()
        except psycopg2.ProgrammingError:
            return None

def test_consulta_productos_array_tecnologia(db_conn):
    query = """
    SELECT * FROM productos WHERE 'tecnología' = ANY(etiquetas);
    """
    result = run_query(db_conn, query)
    assert len(result) > 0

def test_funcion_obtener_subordinados_de_jefe_2(db_conn):

    query = """WITH RECURSIVE red_jefes AS (
        SELECT id, nombre, jefe_id FROM empleados WHERE id = 2
        UNION ALL
        SELECT e.id, e.nombre, e.jefe_id
        FROM empleados e
        INNER JOIN red_jefes r ON e.jefe_id = r.id
    )
    SELECT * FROM red_jefes;"""
    result = run_query(db_conn, query)
    assert len(result) > 0

def test_funcion_obtener_ciudades_alcanzables(db_conn):
    query = """
    WITH RECURSIVE red_rutas AS (
        SELECT id, nombre, ruta_id, ARRAY[id] AS visitados
        FROM ciudades
        WHERE nombre = 'Amsterdam'
        UNION ALL
        SELECT c.id, c.nombre, c.ruta_id, r.visitados || c.id
        FROM ciudades c
        JOIN red_rutas r ON c.id = ANY(r.ruta_id)
        WHERE NOT c.id = ANY(r.visitados)
    )
    SELECT DISTINCT id, nombre, ruta_id FROM red_rutas;
    """
    result = run_query(db_conn, query)
    assert len(result) > 0
