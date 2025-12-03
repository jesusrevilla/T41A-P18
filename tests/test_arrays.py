import psycopg2
import pytest

# --- Configuración de la Base de Datos ---

DB_CONFIG = {
    "dbname": "test_db",   # Asegúrate que esta base de datos exista
    "user": "postgres",
    "password": "postgres",
    "host": "localhost",
    "port": 5432
}

# --- Fixture de Base de Datos ---

@pytest.fixture(scope="function")
def database():
    """
    Una fixture que crea la tabla 'productos' e inserta datos
    antes de cada prueba, y la elimina después.
    """
    conn = None
    cur = None
    try:
        # --- 1. SETUP (Arreglar) ---
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor()

        # Limpiamos por si acaso
        cur.execute("DROP TABLE IF EXISTS productos;")

        # (A) Crear la tabla
        cur.execute("""
            CREATE TABLE productos (
                id SERIAL PRIMARY KEY,
                nombre TEXT,
                etiquetas TEXT[]
            );
        """)

        # (B) Insertar los datos de prueba
        cur.execute("""
            INSERT INTO productos (nombre, etiquetas)
            VALUES 
            ('Mouse', ARRAY['tecnología', 'periferico', 'inalambrico']),
            ('Monitor', ARRAY['tecnología', '1080p', 'IA']),
            ('Playera', ARRAY['niño', 'azul', 'descuento']);
        """)
        
        conn.commit()
        
        # --- 2. YIELD (Ejecutar Prueba) ---
        # Hacemos 'yield' de la conexión para que la prueba pueda usarla
        yield conn

    finally:
        # --- 3. TEARDOWN (Limpiar) ---
        
        # 1. Cierra el cursor original del setup (si existe)
        if cur:
            cur.close()
        
        # 2. Asegúrate de que la conexión esté abierta para limpiar
        if conn:
            if conn.closed:
                # Si la prueba la cerró, la reabrimos
                conn = psycopg2.connect(**DB_CONFIG)

            # 3. Crea un NUEVO cursor solo para la limpieza
            try:
                # Usamos 'with' para que se cierre solo
                with conn.cursor() as cleanup_cur:
                    
                    # --- IMPORTANTE ---
                    # Cambia esta línea por la tabla correcta en CADA fixture
                    # Ejemplo para la fixture 'database':
                    cleanup_cur.execute("DROP TABLE IF EXISTS productos;")
                    
                    # En 'database_empleados' usa:
                    # cleanup_cur.execute("DROP TABLE IF EXISTS empleados;")
                    
                    # En 'database_ciudades' usa:
                    # cleanup_cur.execute("DROP TABLE IF EXISTS ciudades2;")
                
                # 4. Confirma (commit) el DROP TABLE
                conn.commit()
            
            finally:
                # 5. Cierra la conexión
                conn.close()

# --- Función de Prueba ---

def test_consulta_etiqueta_tecnologia(database):
    """
    Prueba que la consulta por la etiqueta 'tecnología' 
    devuelva exactamente los productos correctos.
    
    El argumento 'database' le dice a pytest que ejecute 
    la fixture 'database' antes de esta función.
    """
    
    # --- 1. ARRANGE (Arreglar) ---
    # La fixture 'database' ya hizo todo el setup.
    
    # --- 2. ACT (Actuar) ---
    query = "SELECT nombre FROM productos WHERE 'tecnología' = ANY(etiquetas);"
    
    # Usamos la conexión que nos pasó la fixture
    with database.cursor() as cur:
        cur.execute(query)
        resultados = cur.fetchall()

    # --- 3. ASSERT (Verificar) ---
    
    # Verificamos los resultados. Es mejor usar un 'set'
    # porque no nos importa el orden en que la BD los devuelve.
    
    # Convertimos la lista de tuplas [('Mouse',), ('Monitor',)] en un set {'Mouse', 'Monitor'}
    nombres_obtenidos = {row[0] for row in resultados}
    
    nombres_esperados = {'Mouse', 'Monitor'}

    print(f"Obtenidos: {nombres_obtenidos}")
    print(f"Esperados: {nombres_esperados}")

    assert nombres_obtenidos == nombres_esperados
    assert len(nombres_obtenidos) == 2
    assert 'Playera' not in nombres_obtenidos
