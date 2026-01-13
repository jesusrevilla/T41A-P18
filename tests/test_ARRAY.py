import psycopg2
import pytest

def test_arrays_filtering():
    conn = None
    cur = None
    try:
        conn = psycopg2.connect(
            dbname='test_db',
            user='postgres',
            password='postgres',
            host='localhost',
            port='5432'
        )
        cur = conn.cursor()

        cur.execute("DROP TABLE IF EXISTS productos CASCADE;")
        cur.execute("""
            CREATE TABLE productos (
                id SERIAL PRIMARY KEY,
                nombre TEXT,
                etiquetas TEXT[]
            );
        """)

        cur.execute("""
            INSERT INTO productos (nombre, etiquetas) VALUES 
            ('Teclado', ARRAY['Tecnologia', 'RGB', 'Mecanico']),
            ('Audifonos', ARRAY['Sonido', 'Negros', 'Diadema']),
            ('Mouse', ARRAY['RGB', 'Inalambrico', 'Razer']);
        """)

        cur.execute("""
            SELECT nombre FROM productos 
            WHERE etiquetas @> ARRAY['Tecnologia'];
        """)
        resultados = cur.fetchall()
        nombres = [row[0] for row in resultados]

        assert 'Teclado' in nombres
        assert len(nombres) == 1
        assert 'Mouse' not in nombres 

    finally:
        if conn:
            if cur:
                cur.close()
            conn.close()
