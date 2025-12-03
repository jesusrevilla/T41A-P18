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
def database_empleados():
    """
    Una fixture que crea la tabla 'empleados' e inserta la jerarquía
    antes de cada prueba, y la elimina después.
    """
    conn = None
    cur = None
    try:
        # --- 1. SETUP (Arreglar) ---
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor()

        # Limpiamos por si acaso
        cur.execute("DROP TABLE IF EXISTS empleados;")

        # (A) Crear la tabla
        cur.execute("""
            CREATE TABLE empleados (
                id SERIAL PRIMARY KEY,
                nombre TEXT,
                jefe_id INT
            );
        """)

        # (B) Insertar los datos de prueba
        cur.execute("""
            INSERT INTO empleados (id, nombre, jefe_id) VALUES
            (1, 'Ana (CEO)', NULL),
            (2, 'Carlos (VP IT)', 1),
            (3, 'Maria (VP Finanzas)', 1),
            (4, 'Pedro (Manager IT)', 2),
            (5, 'Laura (Manager Finanzas)', 3),
            (6, 'Juan (Dev)', 4),
            (7, 'Sofia (Contadora)', 5);
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

def test_subordinados_de_carlos(database_empleados):
    """
    Prueba que la CTE recursiva encuentre correctamente
    a 'Carlos' y a todos sus subordinados directos e indirectos.
    """
    
    # --- 1. ARRANGE (Arreglar) ---
    # La fixture 'database_empleados' ya creó la jerarquía.
    
    # --- 2. ACT (Actuar) ---
    # Definimos la consulta recursiva.
    # Seleccionamos solo el 'nombre' para facilitar la aserción.
    query = """
        WITH RECURSIVE red_empleados AS (
            -- Caso base: el jefe del que partimos
            SELECT id, nombre, jefe_id 
            FROM empleados 
            WHERE nombre = 'Carlos (VP IT)'

            UNION ALL

            -- Paso recursivo: los empleados que reportan a alguien
            -- que YA está en el set de resultados (red_empleados)
            SELECT a.id, a.nombre, a.jefe_id
            FROM empleados a
            INNER JOIN red_empleados r ON a.jefe_id = r.id
        )
        SELECT nombre FROM red_empleados;
    """
    
    # Usamos la conexión que nos pasó la fixture
    with database_empleados.cursor() as cur:
        cur.execute(query)
        resultados = cur.fetchall()

    # --- 3. ASSERT (Verificar) ---
    
    # Convertimos la lista de tuplas [('Carlos...',), ('Pedro...',), ('Juan...')]
    # en un set {'Carlos...', 'Pedro...', 'Juan...'}
    nombres_obtenidos = {row[0] for row in resultados}
    
    # Definimos el resultado exacto que esperamos
    nombres_esperados = {
        'Carlos (VP IT)',     # El mismo (caso base)
        'Pedro (Manager IT)', # Subordinado directo
        'Juan (Dev)'          # Subordinado indirecto
    }

    print(f"Obtenidos: {nombres_obtenidos}")
    print(f"Esperados: {nombres_esperados}")

    # Verificamos que los sets son idénticos
    assert nombres_obtenidos == nombres_esperados
    
    # Verificaciones adicionales para robustez
    assert len(nombres_obtenidos) == 3
    assert 'Ana (CEO)' not in nombres_obtenidos
    assert 'Sofia (Contadora)' not in nombres_obtenidos
