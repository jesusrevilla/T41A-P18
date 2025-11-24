
import psycopg2
import pytest

def test_recursive_cities():
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

        cur.execute("DROP TABLE IF EXISTS red_ciudades CASCADE;")
        cur.execute("""
            CREATE TABLE red_ciudades (
                nombre TEXT PRIMARY KEY,
                conexiones TEXT[] 
            );
        """)

        cur.execute("""
            INSERT INTO red_ciudades (nombre, conexiones) VALUES
            ('CDMX',        ARRAY['Guadalajara', 'Monterrey']),
            ('Guadalajara', ARRAY['Vallarta']),
            ('Monterrey',   ARRAY['Cancun']),
            ('Cancun',      ARRAY['Madrid']);
        """)
        cur.execute("""
            WITH RECURSIVE ruta_viaje AS (
                SELECT 
                    nombre AS ciudad_origen, 
                    conexiones
                FROM red_ciudades
                WHERE nombre = 'CDMX' 
                
                UNION
                
                SELECT 
                    c.nombre, 
                    c.conexiones
                FROM red_ciudades c
                INNER JOIN ruta_viaje r 
                    ON c.nombre = ANY(r.conexiones)
            )
            SELECT ciudad_origen FROM ruta_viaje;
        """)
        
        resultados = cur.fetchall()
        ciudades_alcanzadas = [row[0] for row in resultados]

        assert 'CDMX' in ciudades_alcanzadas
        assert 'Guadalajara' in ciudades_alcanzadas
        assert 'Monterrey' in ciudades_alcanzadas
        
        assert 'Cancun' in ciudades_alcanzadas
        
        assert len(ciudades_alcanzadas) == 4 

    finally:
        if conn:
            if cur:
                cur.close()
            conn.close()
          
