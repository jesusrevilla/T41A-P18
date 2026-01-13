import psycopg2

def run_query(query):
    conn = psycopg2.connect(
        dbname="test_db",
        user="postgres",
        password="postgres",
        host="localhost"
    )
    cur = conn.cursor()
    cur.execute(query)
    result = cur.fetchall()
    conn.close()
    return result

def test_producto_tecnologia():
    result = run_query("SELECT nombre FROM productos WHERE 'tecnología' = ANY(etiquetas);")
    nombres = [r[0] for r in result]
    assert "Laptop" in nombres
    assert "Teléfono" in nombres

def test_cte_subordinados():
    query = """
    WITH RECURSIVE jerarquia AS (
        SELECT id, nombre, jefe_id FROM empleados WHERE nombre = 'Director'
        UNION ALL
        SELECT e.id, e.nombre, e.jefe_id
        FROM empleados e
        INNER JOIN jerarquia j ON e.jefe_id = j.id
    )
    SELECT nombre FROM jerarquia;
    """
    result = run_query(query)
    nombres = [r[0] for r in result]
    assert "Gerente" in nombres
    assert "Analista" in nombres
    assert "Técnico" in nombres
