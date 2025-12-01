import psycopg2
import pytest

DB_CONFIG = {
    "host": "localhost",
    "database": "test_db",
    "user": "postgres",
    "password": "postgres"
}

def run_query(query):
    """Ejecuta un SELECT y devuelve los resultados como lista de tuplas."""
    with psycopg2.connect(**DB_CONFIG) as conn:
        with conn.cursor() as cur:
            cur.execute(query)
            try:
                return cur.fetchall()
            except psycopg2.ProgrammingError:
                return []


# ============================================
# FIXTURE GLOBAL (CONEXIÓN PARA LOS TESTS)
# ============================================

@pytest.fixture
def db_conn():
    conn = psycopg2.connect(**DB_CONFIG)
    yield conn
    conn.close()


# ============================================
# TESTS TABLA USUARIOS
# ============================================

def test_nombre_ana():
    result = run_query("SELECT data->>'nombre' FROM usuarios WHERE id = 1;")
    assert result[0][0] == "Ana"


def test_usuario_activo():
    result = run_query("SELECT data->>'activo' FROM usuarios WHERE id = 1;")
    assert result[0][0] == "true"


def test_edad_juan():
    result = run_query("SELECT data->>'edad' FROM usuarios WHERE id = 2;")
    assert result[0][0] == "25"


def test_tabla_existe():
    result = run_query("""
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_name = 'usuarios';
    """)
    assert result, "La tabla 'usuarios' no existe."


def test_columna_data_es_jsonb():
    result = run_query("""
        SELECT data_type 
        FROM information_schema.columns
        WHERE table_name = 'usuarios' AND column_name = 'data';
    """)
    assert result[0][0] == "jsonb"


# ============================================
# TESTS TABLA PRODUCTOS
# ============================================

def test_producto_tecnologia_nombres(db_conn):
    with db_conn.cursor() as cur:
        cur.execute("SELECT nombre FROM productos WHERE 'tecnología' = ANY(etiquetas);")
        resultados = cur.fetchall()

    nombres = [row[0] for row in resultados]

    assert "Laptop Pro" in nombres
    assert "Teclado Mecánico RGB" in nombres
    assert "Monitor 4K UHD" in nombres
    assert "Teléfono" not in nombres


# ============================================
# TESTS CTE SUBORDINADOS
# ============================================

def test_cte_subordinados_de_ana(db_conn):
    query_cte = """
    WITH RECURSIVE red_empleados AS (
        SELECT id, nombre, jefe_id 
        FROM empleados 
        WHERE jefe_id = 1

        UNION ALL

        SELECT e.id, e.nombre, e.jefe_id
        FROM empleados e
        INNER JOIN red_empleados r ON e.jefe_id = r.id
    )
    SELECT nombre FROM red_empleados ORDER BY nombre;
    """

    with db_conn.cursor() as cur:
        cur.execute(query_cte)
        resultados = cur.fetchall()

    nombres = [row[0] for row in resultados]

    assert len(nombres) == 2
    assert "Maria (Desarrollador)" in nombres
    assert "Luis (Pasante)" in nombres
