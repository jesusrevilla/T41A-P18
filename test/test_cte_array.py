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

def test_funcion_obtener_subordinados_de_jefe_2(db_conn):
    
    query = "SELECT * FROM obtener_subordinados_de(2) ORDER BY id_empleado;"
    result = run_query(db_conn, query)
    esperado = [
        {'id_jefe': 2, 'nombre_jefe': 'Jose', 'id_empleado': 3, 'nombre_empleado': 'Juan'},
        {'id_jefe': 2, 'nombre_jefe': 'Jose', 'id_empleado': 4, 'nombre_empleado': 'Brandon'},
        {'id_jefe': 2, 'nombre_jefe': 'Jose', 'id_empleado': 5, 'nombre_empleado': 'Rafael'}
    ]
    
    assert result == esperado

def test_funcion_obtener_ciudades_alcanzables(db_conn):
    query = """
    SELECT * FROM obtener_ciudades_alcanzables(1)
    ORDER BY id_ciudad, distancia;
    """
    result = run_query(db_conn, query)

    esperado = [
        {'id_ciudad': 1, 'nombre_ciudad': 'Ciudad de México', 'distancia': 0, 'camino_recorrido': [1]},
        {'id_ciudad': 2, 'nombre_ciudad': 'San Luis Potosí', 'distancia': 2, 'camino_recorrido': [1, 5, 2]},
        {'id_ciudad': 3, 'nombre_ciudad': 'Monterrey', 'distancia': 3, 'camino_recorrido': [1, 5, 2, 3]},
        {'id_ciudad': 3, 'nombre_ciudad': 'Monterrey', 'distancia': 4, 'camino_recorrido': [1, 5, 2, 4, 3]},
        {'id_ciudad': 4, 'nombre_ciudad': 'Guadalajara', 'distancia': 3, 'camino_recorrido': [1, 5, 2, 4]},
        {'id_ciudad': 5, 'nombre_ciudad': 'Querétaro', 'distancia': 1, 'camino_recorrido': [1, 5]}
    ]
    
    assert result == esperado
