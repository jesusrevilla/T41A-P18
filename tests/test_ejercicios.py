import psycopg2
import pytest
import os

DB_PARAMS = {
    "host": "localhost",
    "database": "test_db",
    "user": "postgres",
    "password": "postgres",
    "port": "5432"
}

@pytest.fixture(scope="module")
def db_connection():
    try:
        conn = psycopg2.connect(**DB_PARAMS)
        yield conn
    finally:
        if 'conn' in locals() and conn:
            conn.close()

def test_01_productos_table_exists(db_connection):
    cursor = db_connection.cursor()
    cursor.execute("""
        SELECT EXISTS (
            SELECT 1 
            FROM information_schema.tables 
            WHERE table_name = 'productos'
        );
    """)
    assert cursor.fetchone()[0] == True
    cursor.close()

def test_01_productos_contains_tecnologia(db_connection):
    cursor = db_connection.cursor()
    cursor.execute("""
        SELECT COUNT(nombre) 
        FROM productos 
        WHERE 'tecnología' = ANY(etiquetas);
    """)
    expected_count = 2 
    actual_count = cursor.fetchone()[0]
    assert actual_count == expected_count
    cursor.close()
    
def test_02_ciudades_table_exists(db_connection):
    cursor = db_connection.cursor()
    cursor.execute("""
        SELECT EXISTS (
            SELECT 1 
            FROM information_schema.tables 
            WHERE table_name = 'ciudades'
        );
    """)
    assert cursor.fetchone()[0] == True
    cursor.close()

def test_02_ciudades_reachable_count(db_connection):
    cursor = db_connection.cursor()
    cursor.execute("""
        WITH RECURSIVE viaje AS (
            SELECT nombre, conexiones, ARRAY[nombre] AS ruta_recorrida
            FROM ciudades
            WHERE nombre = 'San Luis Potosí'
            
            UNION ALL
            
            SELECT c.nombre, c.conexiones, v.ruta_recorrida || c.nombre
            FROM ciudades c
            JOIN viaje v ON c.nombre = ANY(v.conexiones)
            WHERE NOT (c.nombre = ANY(v.ruta_recorrida))
        )
        SELECT COUNT(DISTINCT nombre) FROM viaje;
    """)
    expected_count = 7 
    actual_count = cursor.fetchone()[0]
    assert actual_count == expected_count
    cursor.close()
