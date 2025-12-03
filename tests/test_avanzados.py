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
def database_ciudades():
    """
    Una fixture que crea la tabla 'ciudades2' e inserta el mapa de rutas
    antes de cada prueba, y la elimina después.
    """
    conn = None
    cur = None
    try:
        # --- 1. SETUP (Arreglar) ---
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor()

        # Limpiamos por si acaso
        cur.execute("DROP TABLE IF EXISTS ciudades2;")

        # (A) Crear la tabla
        cur.execute("""
            CREATE TABLE ciudades2 (
                id SERIAL PRIMARY KEY,
                nombre TEXT,
                rutas_directas TEXT[]
            );
        """)

        # (B) Insertar los datos de prueba
        cur.execute("""
            INSERT INTO ciudades2 (nombre, rutas_directas)
            VALUES 
            ('San Luis Potosí', ARRAY['Ciudad Fernandez', 'Soledad de Graciano Sanchez', 'Ahualulco']),
            ('Ciudad Fernandez', ARRAY['Rioverde', 'Cerritos', 'Villa de Reyes']),
            ('Ahualulco', ARRAY['Moctezuma', 'Matehuala', 'Cerritos']);
        """)
        
        conn.commit()
        
        # --- 2. YIELD (Ejecutar Prueba) ---
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

def test_ciudades_alcanzables_desde_slp(database_ciudades):
    """
    Prueba que la CTE recursiva encuentre todas las ciudades
    alcanzables desde 'San Luis Potosí', evitando ciclos.
    """
    
    # --- 1. ARRANGE (Arreglar) ---
    # La fixture 'database_ciudades' ya creó el mapa.
    
    # --- 2. ACT (Actuar) ---
    # Definimos la consulta recursiva exacta del ejercicio.
    query = """
        WITH RECURSIVE viajes_posibles (ciudad, visitadas) AS (
            
            -- Caso base: La ciudad inicial
            SELECT
                nombre,
                ARRAY[nombre] AS visitadas
            FROM
                ciudades2
            WHERE
                nombre = 'San Luis Potosí' 

            UNION ALL

            -- Paso recursivo: explorar rutas
            SELECT
                s.ruta_siguiente,
                v.visitadas || s.ruta_siguiente
            FROM
                viajes_posibles AS v
            -- Unimos con la tabla para obtener las rutas de la ciudad actual
            JOIN
                ciudades2 AS c ON v.ciudad = c.nombre
            -- Expandimos el array de rutas a filas individuales
            CROSS JOIN
                unnest(c.rutas_directas) AS s(ruta_siguiente)
                
            -- Control de ciclos: no visitar una ciudad ya en el path
            WHERE
                NOT (s.ruta_siguiente = ANY(v.visitadas))
        )
        SELECT DISTINCT ciudad FROM viajes_posibles;
    """
    
    # Usamos la conexión que nos pasó la fixture
    with database_ciudades.cursor() as cur:
        cur.execute(query)
        resultados = cur.fetchall()

    # --- 3. ASSERT (Verificar) ---
    
    # Convertimos la lista de tuplas en un set para una comparación
    # sin importar el orden.
    ciudades_obtenidas = {row[0] for row in resultados}
    
    # Definimos el resultado exacto que esperamos
    # basándonos en el grafo insertado
    ciudades_esperadas = {
        # --- Nivel 0 ---
        'San Luis Potosí',         # El inicio
        
        # --- Nivel 1 (Rutas desde SLP) ---
        'Ciudad Fernandez',
        'Soledad de Graciano Sanchez', # Se detiene aquí (no tiene fila)
        'Ahualulco',
        
        # --- Nivel 2 (Rutas desde Ciudad Fernandez) ---
        'Rioverde',                
        'Cerritos',               
        'Villa de Reyes',          
        
        # --- Nivel 2 (Rutas desde Ahualulco) ---
        'Moctezuma',               
        'Matehuala',               
        
    }

    print(f"Obtenidas: {ciudades_obtenidas}")
    print(f"Esperadas: {ciudades_esperadas}")

    # Verificamos que los sets son idénticos
    assert ciudades_obtenidas == ciudades_esperadas
    assert len(ciudades_obtenidas) == 9
