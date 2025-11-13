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
        psycopg2.extras.register_hstore(conn)
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
    SELECT * FROM productos
    WHERE 'tecnología' ILIKE ANY(categoria)
    ORDER BY id;
    """
    result = run_query(db_conn, query)

    assert len(result) > 0

