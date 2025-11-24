
import psycopg2
import pytest

def test_recursive_employees():
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

        cur.execute("DROP TABLE IF EXISTS empleados CASCADE;")
        cur.execute("""
            CREATE TABLE empleados (
                id SERIAL PRIMARY KEY,
                nombre TEXT,
                jefe_id INT
            );
        """)
      
        cur.execute("""
            INSERT INTO empleados (nombre, jefe_id) VALUES
            ('Ana', NULL),   
            ('Luis', 1),       
            ('Marta', 1),      
            ('Pedro', 2);    
        """)

        cur.execute("""
            WITH RECURSIVE subordinados AS (
                SELECT id, nombre, jefe_id 
                FROM empleados 
                WHERE nombre = 'Ana'
                
                UNION ALL
                
                SELECT e.id, e.nombre, e.jefe_id
                FROM empleados e
                INNER JOIN subordinados s ON e.jefe_id = s.id 
            )
            SELECT nombre FROM subordinados;
        """)
        
        resultados = cur.fetchall()
        nombres_obtenidos = [row[0] for row in resultados]

        assert 'Ana' in nombres_obtenidos     
        assert 'Luis' in nombres_obtenidos   
        assert 'Marta' in nombres_obtenidos 
        assert 'Pedro' in nombres_obtenidos   
        assert len(nombres_obtenidos) == 4

    finally:
        if conn:
            if cur:
                cur.close()
            conn.close()
          
