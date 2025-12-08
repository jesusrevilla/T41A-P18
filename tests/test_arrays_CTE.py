import psycopg2
import pytest

DB_CONFIG = {
    "dbname": "test_db",
    "user": "postgres",
    "password": "postgres",
    "host": "localhost",
    "port": 5432
}

# conexión global que usarán los tests
db_connection = psycopg2.connect(**DB_CONFIG)

def test_etiqueta_tecnologia():
    with db_connection.cursor() as cur:
        cur.execute("SELECT nombre FROM productos WHERE etiqueta @> ARRAY['tecnología'];")
        resultados = [row[0] for row in cur.fetchall()]
    assert set(resultados) == {"Laptop Dell", "Smartphone Samsung"}

def test_jerarquia():
    with db_connection.cursor() as cur:
        cur.execute("SELECT * FROM jerarquia_empleados;")
        resultados = [row[0] for row in cur.fetchall()]
    assert set(resultados) == {"Luis", "Coral", "Marta", "Pedro", "Lupe"}

def test_ciudad():
    with db_connection.cursor() as cur:
        cur.execute("SELECT ciudad FROM recorrido;")
        resultados = {row[0] for row in cur.fetchall()}
    assert resultados == {"A", "B", "C", "D", "E"}
