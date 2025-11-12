import psycopg2
import pytest


DB_CONFIG = {
    "host": "localhost",
    "database": "test_db",
    "user": "postgres",
    "password": "postgres"
}


def run_query(query):
    """Ejecuta una consulta SQL y devuelve los resultados como lista de tuplas."""
    with psycopg2.connect(**DB_CONFIG) as conn:
        with conn.cursor() as cur:
            cur.execute(query)
            try:
                result = cur.fetchall()
            except psycopg2.ProgrammingError:
                result = []
    return result




def test_nombre_ana():
    """Verifica que el usuario con id=1 se llama Ana."""
    result = run_query("SELECT data->>'nombre' FROM usuarios WHERE id = 1;")
    print(f"resultado del query: {result}")
    assert result[0][0] == "Ana"


def test_usuario_activo():
    """Verifica que el usuario con id=1 está activo."""
    result = run_query("SELECT data->>'activo' FROM usuarios WHERE id = 1;")
    assert result[0][0] == "true"


def test_edad_juan():
    """Verifica que el usuario con id=2 tiene 25 años."""
    result = run_query("SELECT data->>'edad' FROM usuarios WHERE id = 2;")
    assert result[0][0] == "25"



def test_tabla_existe():
    """Comprueba que la tabla 'usuarios' existe en la base de datos."""
    result = run_query("""
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_name = 'usuarios';
    """)
    assert result, "La tabla 'usuarios' no existe."


def test_columna_data_es_jsonb():
    """Verifica que la columna 'data' es de tipo JSONB."""
    result = run_query("""
        SELECT data_type 
        FROM information_schema.columns
        WHERE table_name = 'usuarios' AND column_name = 'data';
    """)
    assert result[0][0] == "jsonb"
