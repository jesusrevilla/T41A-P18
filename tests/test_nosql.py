import psycopg2
import pytest

DB_CONFIG = {
    "dbname": "test_db",
    "user": "postgres",
    "password": "postgres",
    "host": "localhost",
    "port": 5432
}

def run_query(query):
    with psycopg2.connect(**DB_CONFIG) as conn:
        with conn.cursor() as cur:
            cur.execute(query)
            return cur.fetchall()

def test_tecnologia_array():
  result = run_query("SELECT nombre from productos WHERE etiquetas@>ARRAY['TECNOLOGIA'];")
  productos={row[0] for row in result}
  assert "SMARTPHONE" in productos
  assert "LAPTOP" in productos

def test_red_subordinados():
  result = run_query("SELECT * FROM subordinados_view;")
  empleados={row[1] for row in result}
  assert len(empleados)==4

def test_red_rutas():
  result = run_query("SELECT DISTINCT * FROM alcanzables_view;")
  print(f'resultado del query: {result}')
  rutas={row[1] for row in result}
  assert len(rutas)==9
  
