import psycopg2

DB_CONFIG = dict(
    host="localhost",
    dbname="test_db",
    user="postgres",
    password="postgres"
)

def test_connection():
    conn = psycopg2.connect(**DB_CONFIG)
    conn.close()
    assert True

def test_table_exists():
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor()
    cur.execute("""
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_name = 'empleados';
    """)
    result = cur.fetchone()
    conn.close()

    assert result is not None

def test_employee_data_inserted():
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor()
    cur.execute("SELECT COUNT(*) FROM empleados;")
    count = cur.fetchone()[0]
    conn.close()

    assert count > 0

def test_recursive_cte_returns_rows():
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor()

    cur.execute("""
        WITH RECURSIVE subordinates AS (
            SELECT id, nombre, jefe_id, 0 AS nivel
            FROM empleados
            WHERE id = 3     -- Director de TI

            UNION ALL

            SELECT e.id, e.nombre, e.jefe_id, s.nivel + 1
            FROM empleados e
            JOIN subordinates s ON e.jefe_id = s.id
        )
        SELECT * FROM subordinates;
    """)

    rows = cur.fetchall()
    conn.close()

    # Debe devolver al menos al jefe + subordinados
    assert len(rows) >= 1
