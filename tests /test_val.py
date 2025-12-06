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

def test_productos_con_tecnologia():
    """Debe existir al menos un producto con la etiqueta 'tecnología'."""
    query = """
        SELECT nombre
        FROM productos
        WHERE 'tecnología' = ANY (etiquetas);
    """
    result = run_query(query)
    print(f"Productos con tecnología: {result}")

    assert len(result) >= 1


def test_laptop_tiene_computadoras():
    """La Laptop X200 debe tener la etiqueta 'computadoras'."""
    query = """
        SELECT etiquetas
        FROM productos
        WHERE nombre = 'Laptop X200';
    """
    result = run_query(query)
    etiquetas = result[0][0]

    print(f"Etiquetas de Laptop X200: {etiquetas}")

    assert "computadoras" in etiquetas


def test_cafetera_no_tecnologia():
    """La Cafetera Pro NO debe tener la etiqueta 'tecnología'."""
    query = """
        SELECT nombre
        FROM productos
        WHERE nombre = 'Cafetera Pro' AND 'tecnología' = ANY(etiquetas);
    """
    result = run_query(query)

    print(f"Resultado búsqueda Cafetera Pro con tecnología: {result}")

    assert len(result) == 0


def test_subordinados_de_luis():
    """Luis debe tener subordinados: Pedro y Ana."""
    query = """
        WITH RECURSIVE subalternos AS (
            SELECT id, nombre, jefe_id
            FROM empleados
            WHERE nombre = 'Luis'
            UNION ALL
            SELECT e.id, e.nombre, e.jefe_id
            FROM empleados e
            INNER JOIN subalternos s ON e.jefe_id = s.id
        )
        SELECT nombre FROM subalternos WHERE nombre != 'Luis';
    """

    result = run_query(query)
    subordinados = [row[0] for row in result]

    print(f"Subordinados de Luis: {subordinados}")

    assert "Pedro" in subordinados
    assert "Ana" in subordinados


def test_ceo_sin_jefe():
    """Carla debe tener jefe_id = NULL (es la CEO)."""
    result = run_query("SELECT jefe_id FROM empleados WHERE nombre = 'Carla';")
    
    print(f"jefe_id de Carla: {result[0][0]}")

    assert result[0][0] is None


def test_lucia_depende_marta():
    """Lucía debe tener jefe_id = 3 (Marta)."""
    query = """
        SELECT jefe_id FROM empleados WHERE nombre = 'Lucía';
    """
    result = run_query(query)
    jefe_id = result[0][0]

    print(f"jefe_id de Lucía: {jefe_id}")

    assert jefe_id == 3
